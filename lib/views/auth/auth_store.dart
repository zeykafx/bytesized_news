import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';

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

  _AuthStore() {
    user = auth.currentUser;
  }

  Future<void> init() async {
    if (user == null) {
      initialized = true;
      return;
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

    // Setup auto run reactions for each of these fields
    autorun((_) {
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
  }
}
