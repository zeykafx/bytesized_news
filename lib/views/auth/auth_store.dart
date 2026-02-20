import 'package:bytesized_news/database/db_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isar_community/isar.dart';
import 'package:mobx/mobx.dart';

part 'auth_store.g.dart';

class AuthStore = _AuthStore with _$AuthStore;

enum Tier { free, premium }

// Defaults
const defaultUserInterests = [
  "News",
];

int defaultNumberOfSuggestionsDaily = 20;
int defaultNumberOfSummariesDaily = 100;
int suggestionsIntervalMinutes = 10;
int summariesIntervalSeconds = 10;
int maxUserInterests = 30;

abstract class _AuthStore with Store {
  @observable
  bool initialized = false;

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
  bool authLoading = false;

  late DbUtils dbUtils;
  Isar isar = Isar.getInstance()!;

  _AuthStore() {
    final twentyMinutesAgo = DateTime.now().toUtc().subtract(const Duration(minutes: 20));
    lastSuggestionDate = twentyMinutesAgo;
    lastSummaryDate = twentyMinutesAgo;
  }

  Future<bool> init(BuildContext? buildContext) async {
    if (kDebugMode) {
      print("AuthStore init started (BYOK mode, no Firebase)");
    }

    dbUtils = DbUtils(isar: isar);
    initialized = true;

    if (kDebugMode) {
      print("AuthStore init finished");
    }
    return true;
  }
}

