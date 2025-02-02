import 'dart:io';

import 'package:bytesized_news/views/auth/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
int summariesIntervalSeconds = 30;

abstract class _AuthStore with Store {
  // Fields
  @observable
  FirebaseAuth auth = FirebaseAuth.instance;

  @observable
  FirebaseFunctions functions =
      FirebaseFunctions.instanceFor(region: "europe-west1");

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

  _AuthStore() {
    user = auth.currentUser;
  }

  Future<bool> init(BuildContext? buildContext) async {
    if (user == null) {
      initialized = true;
      return false;
    }
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

    var userData =
        await FirebaseFirestore.instance.doc("/users/${user!.uid}").get();
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

    builtUserProfileDate = DateTime.fromMillisecondsSinceEpoch(
        userData["builtUserProfileDate"] ?? 0);

    if (userData["suggestionsLeftToday"] != null) {
      suggestionsLeftToday = userData["suggestionsLeftToday"];
      lastSuggestionDate = DateTime.fromMillisecondsSinceEpoch(
          userData["lastSuggestionDate"] ?? 0);
    }

    if (userData["summariesLeftToday"] != null) {
      summariesLeftToday = userData["summariesLeftToday"];
      lastSummaryDate =
          DateTime.fromMillisecondsSinceEpoch(userData["lastSummaryDate"] ?? 0);
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
    if (fbDeviceIds.isEmpty || !fbDeviceIds.contains(localDeviceId)) {
      if (kDebugMode) {
        print("Updating firebase device ID to add local device ID");
      }
      // fbDeviceIds.add(localDeviceId);
      // FirebaseFirestore.instance.doc("/users/${user!.uid}").update({
      //   "deviceIds": fbDeviceIds,
      // });
      final result = await functions.httpsCallable('onDeviceIdAdded').call(
        {
          "deviceId": localDeviceId,
        },
      );
      var response = result.data as Map<String, dynamic>;
      if (response["error"] != null) {
        // Show a snackbar and log out
        auth.signOut();
        if (buildContext != null) {
          ScaffoldMessenger.of(buildContext).showSnackBar(
            SnackBar(
              content: Text(
                  "You have been logged out, Another account has already registered this device."),
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

    // Setup auto run reactions for each of these fields
    reaction((_) => userInterests, (_) {
      if (kDebugMode) {
        print("Updating userInterests");
      }
      FirebaseFirestore.instance.doc("/users/${user!.uid}").update({
        "interests": userInterests,
      });
    });
    reaction((_) => builtUserProfileDate, (_) {
      if (kDebugMode) {
        print("Updating builtUserProfileDate");
      }

      FirebaseFirestore.instance.doc("/users/${user!.uid}").update({
        "builtUserProfileDate": builtUserProfileDate!.millisecondsSinceEpoch,
      });
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
  }
}
