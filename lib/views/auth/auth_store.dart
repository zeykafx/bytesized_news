import 'dart:convert';

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
const int defaultNumberOfSuggestionsDaily = 10;
const int defaultNumberOfSummariesDaily = 50;

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
      // if (DateTime.now().difference(lastSuggestionDate!).inDays > 0 || DateTime.now().day != lastSuggestionDate!.day) {
      //   suggestionsLeftToday = defaultNumberOfSuggestionsDaily;
      // }
    }

    if (userData["summariesLeftToday"] != null &&
        userData["lastSummaryDate"] != null) {
      summariesLeftToday = userData["summariesLeftToday"];
      lastSummaryDate =
          DateTime.fromMillisecondsSinceEpoch(userData["lastSummaryDate"]);

      // If the last summary date is not today, then reset the number of summaries
      // Or if the day is not the same (i.e., at midnight, replenish the summaries)
      // if (DateTime.now().difference(lastSummaryDate!).inDays > 0 || DateTime.now().day != lastSummaryDate!.day) {
      //   summariesLeftToday = defaultNumberOfSummariesDaily;
      // }
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
