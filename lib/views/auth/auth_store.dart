import 'dart:convert';
import 'dart:io';
import 'package:bytesized_news/database/db_utils.dart';
import 'package:bytesized_news/models/feed/feed.dart';
import 'package:bytesized_news/models/feedGroup/feedGroup.dart';
import 'package:bytesized_news/views/auth/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:mobx/mobx.dart';
import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';

part 'auth_store.g.dart';

class AuthStore = _AuthStore with _$AuthStore;

enum Tier { free, premium }

// Defaults
const defaultUserInterests = [
  "Technology",
  "Politics",
];

int defaultNumberOfSuggestionsDaily = 20;
int defaultNumberOfSummariesDaily = 100;
int suggestionsIntervalMinutes = 10;
int summariesIntervalSeconds = 10;

abstract class _AuthStore with Store {
  // Fields
  @observable
  FirebaseAuth auth = FirebaseAuth.instance;

  @observable
  FirebaseFunctions functions = FirebaseFunctions.instanceFor(region: "europe-west1");

  @observable
  bool initialized = false;

  @observable
  User? user;

  @observable
  Tier userTier = Tier.free;

  @observable
  List<String> userInterests = defaultUserInterests;

  @observable
  DateTime? builtUserProfileDate;

  @observable
  int suggestionsLeftToday = defaultNumberOfSuggestionsDaily;

  @observable
  DateTime? lastSuggestionDate;

  @observable
  int summariesLeftToday = defaultNumberOfSummariesDaily;

  @observable
  DateTime? lastSummaryDate;

  @observable
  String? deviceId;

  late DbUtils dbUtils;
  Isar isar = Isar.getInstance()!;

  _AuthStore() {
    user = auth.currentUser;
  }

  Future<bool> init(BuildContext? buildContext) async {
    if (user == null) {
      initialized = true;
      return false;
    }

    dbUtils = DbUtils(isar: isar);

    // Fetch limits from firestore (this collection is read only for everyone)
    var limits = await FirebaseFirestore.instance.doc("/flags/limits").get();
    if (limits["suggestions"] != null) {
      defaultNumberOfSuggestionsDaily = limits["suggestions"];
    }
    if (limits["summaries"] != null) {
      defaultNumberOfSummariesDaily = limits["summaries"];
    }
    if (limits["suggestionsIntervalMinutes"] != null) {
      suggestionsIntervalMinutes = limits["suggestionsIntervalMinutes"];
    }
    if (limits["summariesIntervalSeconds"] != null) {
      summariesIntervalSeconds = limits["summariesIntervalSeconds"];
    }

    // Not sure if i want this actually, it adds a listener for each connected user...
    // And the probability that I want to change the limits and have that be reflected instantly in the app is low
    // TODO: Evaluate this later
    // FirebaseFirestore.instance.doc("/flags/limits").snapshots().listen(
    //   (event) {
    //     var newLimits = event.data()!;
    //     if (newLimits["suggestions"] != null) {
    //       defaultNumberOfSuggestionsDaily = newLimits["suggestions"];
    //     }
    //     if (newLimits["summaries"] != null) {
    //       defaultNumberOfSummariesDaily = newLimits["summaries"];
    //     }
    //     if (newLimits["suggestionsIntervalMinutes"] != null) {
    //       suggestionsIntervalMinutes = newLimits["suggestionsIntervalMinutes"];
    //     }
    //     if (newLimits["summariesIntervalSeconds"] != null) {
    //       summariesIntervalSeconds = newLimits["summariesIntervalSeconds"];
    //     }
    //   },
    //   onError: (error) => print("Listen failed: $error"),
    // );

    var userData = await FirebaseFirestore.instance.doc("/users/${user!.uid}").get();
    if (userData["tier"] != null) {
      if (userData["tier"] == "premium") {
        userTier = Tier.premium;
      }
    }

    if (userData["interests"] != null) {
      List<String> interests = [];
      for (String interest in userData["interests"]) {
        interests.add(interest);
      }
      userInterests = interests;
    }

    // builtUserProfileDate = DateTime.fromMillisecondsSinceEpoch(userData["builtUserProfileDate"] ?? 0);
    Timestamp builtUserProfileTimestamp = userData["builtUserProfileDate"];
    builtUserProfileDate = builtUserProfileTimestamp.toDate();

    if (userData["suggestionsLeftToday"] != null) {
      suggestionsLeftToday = userData["suggestionsLeftToday"];
      Timestamp timestampLastSuggestionDate = userData["lastSuggestionDate"];
      lastSuggestionDate = timestampLastSuggestionDate.toDate();
      // lastSuggestionDate = DateTime.fromMillisecondsSinceEpoch(userData["lastSuggestionDate"] ?? 0);
    }

    if (userData["summariesLeftToday"] != null) {
      summariesLeftToday = userData["summariesLeftToday"];
      // lastSummaryDate = DateTime.fromMillisecondsSinceEpoch(userData["lastSummaryDate"] ?? 0);
      Timestamp timestampLastSummaryDate = userData["lastSummaryDate"];
      lastSummaryDate = timestampLastSummaryDate.toDate();
    }

    // Get the current device's id and store that in firebase if it is different
    // We send this id along with each request, so if a user switches accounts on the same device
    // we can track that and move the limits to the other account.
    List<String?> fbDeviceIds = [];
    if (userData["deviceIds"] != null) {
      for (dynamic devId in userData["deviceIds"]) {
        fbDeviceIds.add(devId);
      }
    }

    String? localDeviceId = await _getId();
    if (user != null && (fbDeviceIds.isEmpty || !fbDeviceIds.contains(localDeviceId))) {
      if (kDebugMode) {
        print("Updating firebase device ID to add local device ID");
      }
      // fbDeviceIds.add(localDeviceId);

      HttpsCallableResult result;
      try {
        result = await functions.httpsCallable('onDeviceIdAdded').call(
          {
            "deviceId": localDeviceId,
          },
        );
      } catch (err) {
        if (kDebugMode) {
          print(err);
        }
        auth.signOut();
        Navigator.of(buildContext!).push(
          MaterialPageRoute(
            builder: (context) => const Auth(),
          ),
        );
        return false;
      }

      var response = result.data as Map<String, dynamic>;
      if (response["error"] != null) {
        // Show a snackbar and log out
        auth.signOut();
        if (buildContext != null) {
          ScaffoldMessenger.of(buildContext).showSnackBar(
            SnackBar(
              content: Text("You have been logged out, Another account has already registered this device."),
            ),
          );
          Navigator.of(buildContext).push(
            MaterialPageRoute(
              builder: (context) => const Auth(),
            ),
          );
        }
        if (kDebugMode) {
          print("SIGNING OUT USER");
        }
        return false;
      }
      // return response["summary"];
      deviceId = localDeviceId ?? "No Device ID";
    }

    // sync feeds with firestore ----
    List<Feed> localFeeds = await dbUtils.getFeeds();
    Map<String, Feed> localFeedsMap = {};
    for (Feed feed in localFeeds) {
      localFeedsMap[feed.id.toString()] = feed;
    }

    if (userData["feeds"] != null) {
      Map<String, dynamic> firestoreFeeds = userData["feeds"];

      // download and update feeds from firestore
      for (String feedId in firestoreFeeds.keys) {
        try {
          Feed firestoreFeed = Feed.fromJson(firestoreFeeds[feedId]);
          Feed? localFeed = localFeedsMap[feedId];

          if (localFeed == null) {
            // feed doesn't exist locally, add it
            await dbUtils.addFeed(firestoreFeed);
            if (kDebugMode) {
              print("Added new feed ${firestoreFeed.name} from firestore");
            }
          } else {
            // feed exists locally, check if firestore version is newer or different
            // compare by checking if any important fields have changed
            bool needsUpdate = _shouldUpdateLocalFeed(localFeed, firestoreFeed);

            if (needsUpdate) {
              await dbUtils.addFeed(firestoreFeed);
              if (kDebugMode) {
                print("Updated ${firestoreFeed.name} from firestore");
              }
            }
          }

          // Remove from local map so we know what's been processed
          localFeedsMap.remove(feedId);
        } catch (e) {
          if (kDebugMode) {
            print("Error processing feed $feedId: $e");
          }
        }
      }
    }

    // // upload any remaining local feeds to firestore (new feeds that don't exist in firestore)
    // if (localFeedsMap.isNotEmpty) {
    //   Map<String, dynamic> feedsToUpload = {};
    //   for (Feed feed in localFeedsMap.values) {
    //     feedsToUpload[feed.id.toString()] = feed.toJson();
    //   }

    //   await FirebaseFirestore.instance.doc("/users/${user!.uid}").update({
    //     "feeds": feedsToUpload,
    //   });

    //   if (kDebugMode) {
    //     print("Uploaded ${feedsToUpload.length} new feeds to firestore");
    //   }
    // }

    // sync feed groups with firestore ----
    List<Feed> allFeeds = await dbUtils.getFeeds(); // get updated feeds list
    List<FeedGroup> localFeedGroups = await dbUtils.getFeedGroups(allFeeds);
    Map<String, FeedGroup> localFeedGroupsMap = {};
    for (FeedGroup feedGroup in localFeedGroups) {
      localFeedGroupsMap[feedGroup.name] = feedGroup;
    }

    if (userData["feedGroups"] != null) {
      Map<String, dynamic> firestoreFeedGroups = userData["feedGroups"];

      for (String feedGroupName in firestoreFeedGroups.keys) {
        try {
          FeedGroup firestoreFeedGroup = FeedGroup.fromJson(firestoreFeedGroups[feedGroupName]);
          FeedGroup? localFeedGroup = localFeedGroupsMap[feedGroupName];

          if (localFeedGroup == null) {
            // feed group doesn't exist locally, add it
            await dbUtils.addFeedGroup(firestoreFeedGroup);
            if (kDebugMode) {
              print("Added new feed group ${firestoreFeedGroup.name} from firestore");
            }
          } else {
            // feed group exists locally, check if firestore version is different
            bool needsUpdate = _shouldUpdateLocalFeedGroup(localFeedGroup, firestoreFeedGroup);

            if (needsUpdate) {
              await dbUtils.addFeedGroup(firestoreFeedGroup);
              if (kDebugMode) {
                print("Updated ${firestoreFeedGroup.name} from firestore");
              }
            }
          }

          // remove from local map so we know what's been processed
          localFeedGroupsMap.remove(feedGroupName);
        } catch (e) {
          if (kDebugMode) {
            print("Error processing feed group $feedGroupName: $e");
          }
        }
      }
    }

    // // upload any remaining local feed groups to firestore
    // if (localFeedGroupsMap.isNotEmpty) {
    //   Map<String, dynamic> feedGroupsToUpload = {};
    //   for (FeedGroup feedGroup in localFeedGroupsMap.values) {
    //     feedGroupsToUpload[feedGroup.name] = feedGroup.toJson();
    //   }

    //   await FirebaseFirestore.instance.doc("/users/${user!.uid}").update({
    //     "feedGroups": feedGroupsToUpload,
    //   });

    //   if (kDebugMode) {
    //     print("Uploaded ${feedGroupsToUpload.length} new feed groups to firestore");
    //   }
    // }

    // Setup auto run reactions for each of these fields
    reaction((_) => userInterests, (_) async {
      if (kDebugMode) {
        print("Updating userInterests");
      }
      // Call the addUserInterests function
      final result = await FirebaseFunctions.instanceFor(region: "europe-west1").httpsCallable('addUserInterests').call(
        {
          "interests": userInterests,
        },
      );
      var response = result.data as Map<String, dynamic>;
      if (response["error"] != null) {
        throw Exception(response["error"]);
      }
    });

    initialized = true;
    return true;
  }

  @action
  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      // var androidDeviceInfo = await deviceInfo.androidInfo;
      return AndroidId().getId(); // unique ID on Android
    }

    return "No Device Id";
  }

  @action
  bool _shouldUpdateLocalFeed(Feed localFeed, Feed firestoreFeed) {
    // compare important fields to determine if local feed should be updated

    // always prefer firestore data for these fields (user settings)
    if (localFeed.isPinned != firestoreFeed.isPinned ||
        localFeed.pinnedPosition != firestoreFeed.pinnedPosition ||
        localFeed.name != firestoreFeed.name ||
        localFeed.link != firestoreFeed.link) {
      return true;
    }
    return false;
  }

  @action
  bool _shouldUpdateLocalFeedGroup(FeedGroup localFeedGroup, FeedGroup firestoreFeedGroup) {
    // Compare important fields to determine if local feed group should be updated

    if (localFeedGroup.isPinned != firestoreFeedGroup.isPinned ||
        localFeedGroup.pinnedPosition != firestoreFeedGroup.pinnedPosition ||
        localFeedGroup.name != firestoreFeedGroup.name ||
        !_listsEqual(localFeedGroup.feedUrls, firestoreFeedGroup.feedUrls)) {
      return true;
    }

    return false;
  }

  @action
  bool _listsEqual(List<String> list1, List<String> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }
}
