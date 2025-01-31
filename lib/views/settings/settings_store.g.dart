// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingsStore _$SettingsStoreFromJson(Map<String, dynamic> json) =>
    SettingsStore()
      ..darkMode = $enumDecodeNullable(_$DarkModeEnumMap, json['darkMode'],
              unknownValue: DarkMode.system) ??
          DarkMode.system
      ..sort = $enumDecodeNullable(_$FeedListSortEnumMap, json['sort'],
              unknownValue: FeedListSort.byDate) ??
          FeedListSort.byDate
      ..sortFeedName = json['sortFeedName'] as String?
      ..sortFeedGroupName = json['sortFeedGroupName'] as String?
      ..useReaderModeByDefault = json['useReaderModeByDefault'] as bool? ?? true
      ..showAiSummaryOnLoad = json['showAiSummaryOnLoad'] as bool? ?? true
      ..fetchAiSummaryOnLoad = json['fetchAiSummaryOnLoad'] as bool? ?? false
      ..mutedKeywords = (json['mutedKeywords'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          []
      ..keepArticles = $enumDecodeNullable(
              _$KeepArticlesLengthEnumMap, json['keepArticles']) ??
          KeepArticlesLength.threeMonths;

Map<String, dynamic> _$SettingsStoreToJson(SettingsStore instance) =>
    <String, dynamic>{
      'darkMode': _$DarkModeEnumMap[instance.darkMode]!,
      'sort': _$FeedListSortEnumMap[instance.sort]!,
      'sortFeedName': instance.sortFeedName,
      'sortFeedGroupName': instance.sortFeedGroupName,
      'useReaderModeByDefault': instance.useReaderModeByDefault,
      'showAiSummaryOnLoad': instance.showAiSummaryOnLoad,
      'fetchAiSummaryOnLoad': instance.fetchAiSummaryOnLoad,
      'mutedKeywords': instance.mutedKeywords,
      'keepArticles': _$KeepArticlesLengthEnumMap[instance.keepArticles]!,
    };

const _$DarkModeEnumMap = {
  DarkMode.system: 'system',
  DarkMode.dark: 'dark',
  DarkMode.light: 'light',
};

const _$FeedListSortEnumMap = {
  FeedListSort.byDate: 'byDate',
  FeedListSort.today: 'today',
  FeedListSort.unread: 'unread',
  FeedListSort.read: 'read',
  FeedListSort.bookmarked: 'bookmarked',
  FeedListSort.feed: 'feed',
  FeedListSort.feedGroup: 'feedGroup',
};

const _$KeepArticlesLengthEnumMap = {
  KeepArticlesLength.oneWeek: 'oneWeek',
  KeepArticlesLength.oneMonth: 'oneMonth',
  KeepArticlesLength.threeMonths: 'threeMonths',
  KeepArticlesLength.sixMonths: 'sixMonths',
  KeepArticlesLength.oneYear: 'oneYear',
};

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SettingsStore on _SettingsStore, Store {
  late final _$darkModeAtom =
      Atom(name: '_SettingsStore.darkMode', context: context);

  @override
  DarkMode get darkMode {
    _$darkModeAtom.reportRead();
    return super.darkMode;
  }

  @override
  set darkMode(DarkMode value) {
    _$darkModeAtom.reportWrite(value, super.darkMode, () {
      super.darkMode = value;
    });
  }

  late final _$sortAtom = Atom(name: '_SettingsStore.sort', context: context);

  @override
  FeedListSort get sort {
    _$sortAtom.reportRead();
    return super.sort;
  }

  @override
  set sort(FeedListSort value) {
    _$sortAtom.reportWrite(value, super.sort, () {
      super.sort = value;
    });
  }

  late final _$sortFeedAtom =
      Atom(name: '_SettingsStore.sortFeed', context: context);

  @override
  Feed? get sortFeed {
    _$sortFeedAtom.reportRead();
    return super.sortFeed;
  }

  @override
  set sortFeed(Feed? value) {
    _$sortFeedAtom.reportWrite(value, super.sortFeed, () {
      super.sortFeed = value;
    });
  }

  late final _$sortFeedNameAtom =
      Atom(name: '_SettingsStore.sortFeedName', context: context);

  @override
  String? get sortFeedName {
    _$sortFeedNameAtom.reportRead();
    return super.sortFeedName;
  }

  @override
  set sortFeedName(String? value) {
    _$sortFeedNameAtom.reportWrite(value, super.sortFeedName, () {
      super.sortFeedName = value;
    });
  }

  late final _$sortFeedGroupAtom =
      Atom(name: '_SettingsStore.sortFeedGroup', context: context);

  @override
  FeedGroup? get sortFeedGroup {
    _$sortFeedGroupAtom.reportRead();
    return super.sortFeedGroup;
  }

  @override
  set sortFeedGroup(FeedGroup? value) {
    _$sortFeedGroupAtom.reportWrite(value, super.sortFeedGroup, () {
      super.sortFeedGroup = value;
    });
  }

  late final _$sortFeedGroupNameAtom =
      Atom(name: '_SettingsStore.sortFeedGroupName', context: context);

  @override
  String? get sortFeedGroupName {
    _$sortFeedGroupNameAtom.reportRead();
    return super.sortFeedGroupName;
  }

  @override
  set sortFeedGroupName(String? value) {
    _$sortFeedGroupNameAtom.reportWrite(value, super.sortFeedGroupName, () {
      super.sortFeedGroupName = value;
    });
  }

  late final _$useReaderModeByDefaultAtom =
      Atom(name: '_SettingsStore.useReaderModeByDefault', context: context);

  @override
  bool get useReaderModeByDefault {
    _$useReaderModeByDefaultAtom.reportRead();
    return super.useReaderModeByDefault;
  }

  @override
  set useReaderModeByDefault(bool value) {
    _$useReaderModeByDefaultAtom
        .reportWrite(value, super.useReaderModeByDefault, () {
      super.useReaderModeByDefault = value;
    });
  }

  late final _$showAiSummaryOnLoadAtom =
      Atom(name: '_SettingsStore.showAiSummaryOnLoad', context: context);

  @override
  bool get showAiSummaryOnLoad {
    _$showAiSummaryOnLoadAtom.reportRead();
    return super.showAiSummaryOnLoad;
  }

  @override
  set showAiSummaryOnLoad(bool value) {
    _$showAiSummaryOnLoadAtom.reportWrite(value, super.showAiSummaryOnLoad, () {
      super.showAiSummaryOnLoad = value;
    });
  }

  late final _$fetchAiSummaryOnLoadAtom =
      Atom(name: '_SettingsStore.fetchAiSummaryOnLoad', context: context);

  @override
  bool get fetchAiSummaryOnLoad {
    _$fetchAiSummaryOnLoadAtom.reportRead();
    return super.fetchAiSummaryOnLoad;
  }

  @override
  set fetchAiSummaryOnLoad(bool value) {
    _$fetchAiSummaryOnLoadAtom.reportWrite(value, super.fetchAiSummaryOnLoad,
        () {
      super.fetchAiSummaryOnLoad = value;
    });
  }

  late final _$loadingAtom =
      Atom(name: '_SettingsStore.loading', context: context);

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  late final _$mutedKeywordsAtom =
      Atom(name: '_SettingsStore.mutedKeywords', context: context);

  @override
  List<String> get mutedKeywords {
    _$mutedKeywordsAtom.reportRead();
    return super.mutedKeywords;
  }

  @override
  set mutedKeywords(List<String> value) {
    _$mutedKeywordsAtom.reportWrite(value, super.mutedKeywords, () {
      super.mutedKeywords = value;
    });
  }

  late final _$keepArticlesAtom =
      Atom(name: '_SettingsStore.keepArticles', context: context);

  @override
  KeepArticlesLength get keepArticles {
    _$keepArticlesAtom.reportRead();
    return super.keepArticles;
  }

  @override
  set keepArticles(KeepArticlesLength value) {
    _$keepArticlesAtom.reportWrite(value, super.keepArticles, () {
      super.keepArticles = value;
    });
  }

  late final _$_SettingsStoreActionController =
      ActionController(name: '_SettingsStore', context: context);

  @override
  void setDarkMode(DarkMode value) {
    final _$actionInfo = _$_SettingsStoreActionController.startAction(
        name: '_SettingsStore.setDarkMode');
    try {
      return super.setDarkMode(value);
    } finally {
      _$_SettingsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setSort(FeedListSort newSort) {
    final _$actionInfo = _$_SettingsStoreActionController.startAction(
        name: '_SettingsStore.setSort');
    try {
      return super.setSort(newSort);
    } finally {
      _$_SettingsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSortFeed(Feed feed) {
    final _$actionInfo = _$_SettingsStoreActionController.startAction(
        name: '_SettingsStore.setSortFeed');
    try {
      return super.setSortFeed(feed);
    } finally {
      _$_SettingsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSortFeedName(String feedName) {
    final _$actionInfo = _$_SettingsStoreActionController.startAction(
        name: '_SettingsStore.setSortFeedName');
    try {
      return super.setSortFeedName(feedName);
    } finally {
      _$_SettingsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSortFeedGroup(FeedGroup feedGroup) {
    final _$actionInfo = _$_SettingsStoreActionController.startAction(
        name: '_SettingsStore.setSortFeedGroup');
    try {
      return super.setSortFeedGroup(feedGroup);
    } finally {
      _$_SettingsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSortFeedGroupName(String feedGroupName) {
    final _$actionInfo = _$_SettingsStoreActionController.startAction(
        name: '_SettingsStore.setSortFeedGroupName');
    try {
      return super.setSortFeedGroupName(feedGroupName);
    } finally {
      _$_SettingsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUseReaderModeByDefault(bool value) {
    final _$actionInfo = _$_SettingsStoreActionController.startAction(
        name: '_SettingsStore.setUseReaderModeByDefault');
    try {
      return super.setUseReaderModeByDefault(value);
    } finally {
      _$_SettingsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setShowAiSummaryOnLoad(bool value) {
    final _$actionInfo = _$_SettingsStoreActionController.startAction(
        name: '_SettingsStore.setShowAiSummaryOnLoad');
    try {
      return super.setShowAiSummaryOnLoad(value);
    } finally {
      _$_SettingsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFetchAiSummaryOnLoad(bool value) {
    final _$actionInfo = _$_SettingsStoreActionController.startAction(
        name: '_SettingsStore.setFetchAiSummaryOnLoad');
    try {
      return super.setFetchAiSummaryOnLoad(value);
    } finally {
      _$_SettingsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
darkMode: ${darkMode},
sort: ${sort},
sortFeed: ${sortFeed},
sortFeedName: ${sortFeedName},
sortFeedGroup: ${sortFeedGroup},
sortFeedGroupName: ${sortFeedGroupName},
useReaderModeByDefault: ${useReaderModeByDefault},
showAiSummaryOnLoad: ${showAiSummaryOnLoad},
fetchAiSummaryOnLoad: ${fetchAiSummaryOnLoad},
loading: ${loading},
mutedKeywords: ${mutedKeywords},
keepArticles: ${keepArticles}
    ''';
  }
}
