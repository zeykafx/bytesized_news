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
          KeepArticlesLength.threeMonths
      ..fontSize = (json['fontSize'] as num?)?.toDouble() ?? 16.0
      ..textAlignment =
          $enumDecodeNullable(_$TextAlignEnumMap, json['textAlignment']) ??
              TextAlign.left
      ..textWidth =
          $enumDecodeNullable(_$TextWidthEnumMap, json['textWidth']) ??
              TextWidth.normal
      ..lineHeight = (json['lineHeight'] as num?)?.toDouble() ?? 1.2
      ..horizontalPadding =
          (json['horizontalPadding'] as num?)?.toDouble() ?? 8.0
      ..fontFamily =
          $enumDecodeNullable(_$FontFamilyEnumMap, json['fontFamily']) ??
              FontFamily.openSans
      ..markAsReadOnScroll = json['markAsReadOnScroll'] as bool? ?? false
      ..backgroundFetchInterval = $enumDecodeNullable(
              _$BackgroundFetchIntervalEnumMap,
              json['backgroundFetchInterval']) ??
          BackgroundFetchInterval.twelveHours
      ..skipBgSyncOnLowBattery = json['skipBgSyncOnLowBattery'] as bool? ?? true
      ..requireDeviceIdleForBgFetch =
          json['requireDeviceIdleForBgFetch'] as bool? ?? false
      ..storyTilesMinimalStyle =
          json['storyTilesMinimalStyle'] as bool? ?? false
      ..storyReaderMaxWidth =
          (json['storyReaderMaxWidth'] as num?)?.toDouble() ?? 800.0;

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
      'fontSize': instance.fontSize,
      'textAlignment': _$TextAlignEnumMap[instance.textAlignment]!,
      'textWidth': _$TextWidthEnumMap[instance.textWidth]!,
      'lineHeight': instance.lineHeight,
      'horizontalPadding': instance.horizontalPadding,
      'fontFamily': _$FontFamilyEnumMap[instance.fontFamily]!,
      'markAsReadOnScroll': instance.markAsReadOnScroll,
      'backgroundFetchInterval':
          _$BackgroundFetchIntervalEnumMap[instance.backgroundFetchInterval]!,
      'skipBgSyncOnLowBattery': instance.skipBgSyncOnLowBattery,
      'requireDeviceIdleForBgFetch': instance.requireDeviceIdleForBgFetch,
      'storyTilesMinimalStyle': instance.storyTilesMinimalStyle,
      'storyReaderMaxWidth': instance.storyReaderMaxWidth,
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
  FeedListSort.summarized: 'summarized',
  FeedListSort.downloaded: 'downloaded',
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

const _$TextAlignEnumMap = {
  TextAlign.left: 'left',
  TextAlign.center: 'center',
  TextAlign.right: 'right',
  TextAlign.justify: 'justify',
};

const _$TextWidthEnumMap = {
  TextWidth.extremelyThin: 'extremelyThin',
  TextWidth.veryThin: 'veryThin',
  TextWidth.thin: 'thin',
  TextWidth.normal: 'normal',
  TextWidth.bold: 'bold',
  TextWidth.veryBold: 'veryBold',
  TextWidth.extremelyBold: 'extremelyBold',
};

const _$FontFamilyEnumMap = {
  FontFamily.roboto: 'roboto',
  FontFamily.openSans: 'openSans',
  FontFamily.lora: 'lora',
  FontFamily.merriweather: 'merriweather',
  FontFamily.inter: 'inter',
  FontFamily.sourceSerif: 'sourceSerif',
  FontFamily.playfairDisplay: 'playfairDisplay',
  FontFamily.lato: 'lato',
  FontFamily.firaSans: 'firaSans',
  FontFamily.crimsonText: 'crimsonText',
};

const _$BackgroundFetchIntervalEnumMap = {
  BackgroundFetchInterval.never: 'never',
  BackgroundFetchInterval.thirtyMinutes: 'thirtyMinutes',
  BackgroundFetchInterval.oneHour: 'oneHour',
  BackgroundFetchInterval.oneHourAndAHalf: 'oneHourAndAHalf',
  BackgroundFetchInterval.twoHours: 'twoHours',
  BackgroundFetchInterval.threeHours: 'threeHours',
  BackgroundFetchInterval.sixHours: 'sixHours',
  BackgroundFetchInterval.twelveHours: 'twelveHours',
  BackgroundFetchInterval.oneDay: 'oneDay',
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

  late final _$fontSizeAtom =
      Atom(name: '_SettingsStore.fontSize', context: context);

  @override
  double? get fontSize {
    _$fontSizeAtom.reportRead();
    return super.fontSize;
  }

  @override
  set fontSize(double? value) {
    _$fontSizeAtom.reportWrite(value, super.fontSize, () {
      super.fontSize = value;
    });
  }

  late final _$textAlignmentAtom =
      Atom(name: '_SettingsStore.textAlignment', context: context);

  @override
  TextAlign get textAlignment {
    _$textAlignmentAtom.reportRead();
    return super.textAlignment;
  }

  @override
  set textAlignment(TextAlign value) {
    _$textAlignmentAtom.reportWrite(value, super.textAlignment, () {
      super.textAlignment = value;
    });
  }

  late final _$textWidthAtom =
      Atom(name: '_SettingsStore.textWidth', context: context);

  @override
  TextWidth get textWidth {
    _$textWidthAtom.reportRead();
    return super.textWidth;
  }

  @override
  set textWidth(TextWidth value) {
    _$textWidthAtom.reportWrite(value, super.textWidth, () {
      super.textWidth = value;
    });
  }

  late final _$lineHeightAtom =
      Atom(name: '_SettingsStore.lineHeight', context: context);

  @override
  double get lineHeight {
    _$lineHeightAtom.reportRead();
    return super.lineHeight;
  }

  @override
  set lineHeight(double value) {
    _$lineHeightAtom.reportWrite(value, super.lineHeight, () {
      super.lineHeight = value;
    });
  }

  late final _$horizontalPaddingAtom =
      Atom(name: '_SettingsStore.horizontalPadding', context: context);

  @override
  double get horizontalPadding {
    _$horizontalPaddingAtom.reportRead();
    return super.horizontalPadding;
  }

  @override
  set horizontalPadding(double value) {
    _$horizontalPaddingAtom.reportWrite(value, super.horizontalPadding, () {
      super.horizontalPadding = value;
    });
  }

  late final _$fontFamilyAtom =
      Atom(name: '_SettingsStore.fontFamily', context: context);

  @override
  FontFamily get fontFamily {
    _$fontFamilyAtom.reportRead();
    return super.fontFamily;
  }

  @override
  set fontFamily(FontFamily value) {
    _$fontFamilyAtom.reportWrite(value, super.fontFamily, () {
      super.fontFamily = value;
    });
  }

  late final _$markAsReadOnScrollAtom =
      Atom(name: '_SettingsStore.markAsReadOnScroll', context: context);

  @override
  bool get markAsReadOnScroll {
    _$markAsReadOnScrollAtom.reportRead();
    return super.markAsReadOnScroll;
  }

  @override
  set markAsReadOnScroll(bool value) {
    _$markAsReadOnScrollAtom.reportWrite(value, super.markAsReadOnScroll, () {
      super.markAsReadOnScroll = value;
    });
  }

  late final _$backgroundFetchIntervalAtom =
      Atom(name: '_SettingsStore.backgroundFetchInterval', context: context);

  @override
  BackgroundFetchInterval get backgroundFetchInterval {
    _$backgroundFetchIntervalAtom.reportRead();
    return super.backgroundFetchInterval;
  }

  @override
  set backgroundFetchInterval(BackgroundFetchInterval value) {
    _$backgroundFetchIntervalAtom
        .reportWrite(value, super.backgroundFetchInterval, () {
      super.backgroundFetchInterval = value;
    });
  }

  late final _$skipBgSyncOnLowBatteryAtom =
      Atom(name: '_SettingsStore.skipBgSyncOnLowBattery', context: context);

  @override
  bool get skipBgSyncOnLowBattery {
    _$skipBgSyncOnLowBatteryAtom.reportRead();
    return super.skipBgSyncOnLowBattery;
  }

  @override
  set skipBgSyncOnLowBattery(bool value) {
    _$skipBgSyncOnLowBatteryAtom
        .reportWrite(value, super.skipBgSyncOnLowBattery, () {
      super.skipBgSyncOnLowBattery = value;
    });
  }

  late final _$requireDeviceIdleForBgFetchAtom = Atom(
      name: '_SettingsStore.requireDeviceIdleForBgFetch', context: context);

  @override
  bool get requireDeviceIdleForBgFetch {
    _$requireDeviceIdleForBgFetchAtom.reportRead();
    return super.requireDeviceIdleForBgFetch;
  }

  @override
  set requireDeviceIdleForBgFetch(bool value) {
    _$requireDeviceIdleForBgFetchAtom
        .reportWrite(value, super.requireDeviceIdleForBgFetch, () {
      super.requireDeviceIdleForBgFetch = value;
    });
  }

  late final _$storyTilesMinimalStyleAtom =
      Atom(name: '_SettingsStore.storyTilesMinimalStyle', context: context);

  @override
  bool get storyTilesMinimalStyle {
    _$storyTilesMinimalStyleAtom.reportRead();
    return super.storyTilesMinimalStyle;
  }

  @override
  set storyTilesMinimalStyle(bool value) {
    _$storyTilesMinimalStyleAtom
        .reportWrite(value, super.storyTilesMinimalStyle, () {
      super.storyTilesMinimalStyle = value;
    });
  }

  late final _$storyReaderMaxWidthAtom =
      Atom(name: '_SettingsStore.storyReaderMaxWidth', context: context);

  @override
  double get storyReaderMaxWidth {
    _$storyReaderMaxWidthAtom.reportRead();
    return super.storyReaderMaxWidth;
  }

  @override
  set storyReaderMaxWidth(double value) {
    _$storyReaderMaxWidthAtom.reportWrite(value, super.storyReaderMaxWidth, () {
      super.storyReaderMaxWidth = value;
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
  void setSort(FeedListSort newSort) {
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
  void setFontSize(double newSize) {
    final _$actionInfo = _$_SettingsStoreActionController.startAction(
        name: '_SettingsStore.setFontSize');
    try {
      return super.setFontSize(newSize);
    } finally {
      _$_SettingsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTextAlignment(TextAlign newAlignment) {
    final _$actionInfo = _$_SettingsStoreActionController.startAction(
        name: '_SettingsStore.setTextAlignment');
    try {
      return super.setTextAlignment(newAlignment);
    } finally {
      _$_SettingsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTextWidth(TextWidth newWidth) {
    final _$actionInfo = _$_SettingsStoreActionController.startAction(
        name: '_SettingsStore.setTextWidth');
    try {
      return super.setTextWidth(newWidth);
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
keepArticles: ${keepArticles},
fontSize: ${fontSize},
textAlignment: ${textAlignment},
textWidth: ${textWidth},
lineHeight: ${lineHeight},
horizontalPadding: ${horizontalPadding},
fontFamily: ${fontFamily},
markAsReadOnScroll: ${markAsReadOnScroll},
backgroundFetchInterval: ${backgroundFetchInterval},
skipBgSyncOnLowBattery: ${skipBgSyncOnLowBattery},
requireDeviceIdleForBgFetch: ${requireDeviceIdleForBgFetch},
storyTilesMinimalStyle: ${storyTilesMinimalStyle},
storyReaderMaxWidth: ${storyReaderMaxWidth}
    ''';
  }
}
