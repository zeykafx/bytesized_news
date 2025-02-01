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

    if (userData["builtUserProfileDate"] != null) {
      builtUserProfileDate =
          DateTime.fromMillisecondsSinceEpoch(userData["builtUserProfileDate"]);
    }

    if (userData["suggestionsLeftToday"] != null &&
        userData["lastSuggestionDate"] != null) {
      suggestionsLeftToday = userData["suggestionsLeftToday"];
      lastSuggestionDate =
          DateTime.fromMillisecondsSinceEpoch(userData["lastSuggestionDate"]);

      // If the last suggestion date is not today, then reset the number of suggestions
      // Or if the day is not the same (i.e., at midnight, replenish the suggestions)
      if (DateTime.now().difference(lastSuggestionDate!).inDays > 0 ||
          DateTime.now().day != lastSuggestionDate!.day) {
        Future.delayed(Duration(milliseconds: 400), () {
          // Delay the update a bit so that it is caught by the mobx reaction and the new number is written to firebase
          suggestionsLeftToday = defaultNumberOfSuggestionsDaily;
          if (kDebugMode) {
            print(
                "Last suggestion was yesterday, updating the number of suggestions");
          }
        });
      }
    }

    if (userData["summariesLeftToday"] != null &&
        userData["lastSummaryDate"] != null) {
      summariesLeftToday = userData["summariesLeftToday"];
      lastSummaryDate =
          DateTime.fromMillisecondsSinceEpoch(userData["lastSummaryDate"]);

      // If the last summary date is not today, then reset the number of summaries
      // Or if the day is not the same (i.e., at midnight, replenish the summaries)
      if (DateTime.now().difference(lastSummaryDate!).inDays > 0 ||
          DateTime.now().day != lastSummaryDate!.day) {
        Future.delayed(Duration(milliseconds: 400), () {
          // Delay the update a bit so that it is caught by the mobx reaction and the new number is written to firebase
          summariesLeftToday = defaultNumberOfSummariesDaily;
          if (kDebugMode) {
            print(
                "Last summary was yesterday, updating the number of summaries");
          }
        });
      }
    }

    // If the limits have been lowered, drop down to those limits
    // The delay is used so that this is written to firestore
    if (summariesLeftToday > defaultNumberOfSummariesDaily) {
      Future.delayed(Duration(milliseconds: 400), () {
        summariesLeftToday = defaultNumberOfSummariesDaily;
      });
    }

    if (suggestionsLeftToday > defaultNumberOfSuggestionsDaily) {
      Future.delayed(Duration(milliseconds: 400), () {
        suggestionsLeftToday = defaultNumberOfSuggestionsDaily;
      });
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
    reaction((_) => suggestionsLeftToday, (_) {
      if (kDebugMode) {
        print("Updating suggestionsLeftToday");
      }

      FirebaseFirestore.instance.doc("/users/${user!.uid}").update({
        "suggestionsLeftToday": suggestionsLeftToday,
      });
    });

    reaction((_) => lastSuggestionDate, (_) {
      if (kDebugMode) {
        print("Updating lastSuggestionDate");
      }

      FirebaseFirestore.instance.doc("/users/${user!.uid}").update({
        "lastSuggestionDate": lastSuggestionDate!.millisecondsSinceEpoch,
      });
    });
    reaction((_) => summariesLeftToday, (_) {
      if (kDebugMode) {
        print("Updating summariesLeftToday");
      }

      FirebaseFirestore.instance.doc("/users/${user!.uid}").update({
        "summariesLeftToday": summariesLeftToday,
      });
    });
    reaction((_) => lastSummaryDate, (_) {
      if (kDebugMode) {
        print("Updating lastSummaryDate");
      }

      FirebaseFirestore.instance.doc("/users/${user!.uid}").update({
        "lastSummaryDate": lastSummaryDate!.millisecondsSinceEpoch,
      });
    });

    initialized = true;
  }
}
