import 'package:bytesized_news/models/feed/feed.dart';
import 'package:bytesized_news/models/feedGroup/feedGroup.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobx/mobx.dart';

part 'settings_store.g.dart';

enum DarkMode {
  system,
  dark,
  light,
}

String darkModeString(DarkMode darkMode) {
  return switch (darkMode) {
    DarkMode.system => "System",
    DarkMode.dark => "Dark",
    DarkMode.light => "Light",
  };
}

const darkModeNames = ["System", "Dark", "Light"];

enum FeedListSort {
  byDate,
  today,
  unread,
  read,
  summarized,
  downloaded,
  bookmarked,
  feed,
  feedGroup,
}

enum KeepArticlesLength {
  oneWeek(7),
  oneMonth(30),
  threeMonths(90),
  sixMonths(180),
  oneYear(365);

  const KeepArticlesLength(this.value);
  final int value;
}

String keepArticlesLengthString(KeepArticlesLength keepArticlesLength) {
  return switch (keepArticlesLength) {
    KeepArticlesLength.oneWeek => "1 Week",
    KeepArticlesLength.oneMonth => "1 Month",
    KeepArticlesLength.threeMonths => "3 Months",
    KeepArticlesLength.sixMonths => "6 Months",
    KeepArticlesLength.oneYear => "1 Year",
  };
}

const keepArticlesLengthValues = ["1 Week", "1 Month", "3 Months", "6 Months", "6 Months", "1 Year"];

String feedListSortToString(FeedListSort sort) {
  switch (sort) {
    case FeedListSort.byDate:
      return "All Articles";
    case FeedListSort.today:
      return "Today";
    case FeedListSort.unread:
      return "Unread";
    case FeedListSort.read:
      return "Read";
    case FeedListSort.summarized:
      return "Summarized";
    case FeedListSort.bookmarked:
      return "Bookmarked";
    case FeedListSort.downloaded:
      return "Downloaded";
    case FeedListSort.feed:
      return "Feed";
    case FeedListSort.feedGroup:
      return "Feed Group";
  }
}

enum TextAlign { left, center, right, justify }

String textAlignString(TextAlign textAlign) {
  return switch (textAlign) {
    TextAlign.left => "Left",
    TextAlign.center => "Center",
    TextAlign.right => "Right",
    TextAlign.justify => "Justify",
  };
}

const textAlignmentValues = ["Left", "Center", "Right", "Justify"];

enum TextWidth {
  extremelyThin,
  veryThin,
  thin,
  normal,
  bold,
  veryBold,
  extremelyBold,
}

const textWidthValues = ["Extremely Thin", "Very Thin", "Thin", "Normal", "Bold", "Very Bold", "Extremely Bold"];

String textWidthToString(TextWidth width) {
  return switch (width) {
    TextWidth.extremelyThin => "Extremely Thin",
    TextWidth.veryThin => "Very Thin",
    TextWidth.thin => "Thin",
    TextWidth.normal => "Normal",
    TextWidth.bold => "Bold",
    TextWidth.veryBold => "Very Bold",
    TextWidth.extremelyBold => "Extremely Bold",
  };
}

FontWeight widthToWeight(TextWidth width) {
  return switch (width) {
    TextWidth.extremelyThin => FontWeight.w100,
    TextWidth.veryThin => FontWeight.w200,
    TextWidth.thin => FontWeight.w300,
    TextWidth.normal => FontWeight.normal,
    TextWidth.bold => FontWeight.w600,
    TextWidth.veryBold => FontWeight.w800,
    TextWidth.extremelyBold => FontWeight.w900,
  };
}

enum FontFamily {
  roboto, // Current default
  openSans, // Most popular alternative
  lora, // Best serif for reading
  merriweather, // Screen-optimized serif
  inter, // Modern sans-serif
  sourceSerif, // Clean serif
  playfairDisplay, // Elegant serif
  lato, // Friendly sans-serif
  firaSans, // Humanist sans-serif
  crimsonText, // Classic book feel
}

const fontFamilyValues = ["Roboto", "Open Sans", "Lora", "Merriweather", "Inter", "Source Serif Pro", "Playfair Display", "Lato", "Fira Sans", "Crimson Text"];

String fontFamilyToString(FontFamily fontFamily) {
  return switch (fontFamily) {
    FontFamily.roboto => "Roboto",
    FontFamily.openSans => "Open Sans",
    FontFamily.lora => "Lora",
    FontFamily.merriweather => "Merriweather",
    FontFamily.inter => "Inter",
    FontFamily.sourceSerif => "Source Serif Pro",
    FontFamily.playfairDisplay => "Playfair Display",
    FontFamily.lato => "Lato",
    FontFamily.firaSans => "Fira Sans",
    FontFamily.crimsonText => "Crimson Text",
  };
}

String fontFamilyToExplanation(FontFamily fontFamily) {
  return switch (fontFamily) {
    FontFamily.roboto => "Popular default",
    FontFamily.openSans => "Default font",
    FontFamily.lora => "Best serif for reading",
    FontFamily.merriweather => "Screen-optimized serif",
    FontFamily.inter => "Modern sans-serif",
    FontFamily.sourceSerif => "Clean serif",
    FontFamily.playfairDisplay => "Elegant serif",
    FontFamily.lato => "Friendly sans-serif",
    FontFamily.firaSans => "Humanist sans-serif",
    FontFamily.crimsonText => "Classic book feel",
  };
}

TextStyle fontFamilyToGoogleFontTextStyle(FontFamily fontFamily) {
  return switch (fontFamily) {
    FontFamily.roboto => GoogleFonts.roboto(),
    FontFamily.openSans => GoogleFonts.openSans(),
    FontFamily.lora => GoogleFonts.lora(),
    FontFamily.merriweather => GoogleFonts.merriweather(),
    FontFamily.inter => GoogleFonts.inter(),
    FontFamily.sourceSerif => GoogleFonts.sourceSerif4(),
    FontFamily.playfairDisplay => GoogleFonts.playfairDisplay(),
    FontFamily.lato => GoogleFonts.lato(),
    FontFamily.firaSans => GoogleFonts.firaSans(),
    FontFamily.crimsonText => GoogleFonts.crimsonText(),
  };
}

enum BackgroundFetchInterval {
  never(Duration(days: 99)),
  thirtyMinutes(Duration(minutes: 30)),
  oneHour(Duration(hours: 1)),
  oneHourAndAHalf(Duration(hours: 1, minutes: 30)),
  twoHours(Duration(hours: 2)),
  threeHours(Duration(hours: 3)),
  sixHours(Duration(hours: 6)),
  twelveHours(Duration(hours: 12)),
  oneDay(Duration(days: 1));

  const BackgroundFetchInterval(this.value);
  final Duration value;
}

String backgroundFetchIntervalString(BackgroundFetchInterval backgroundFetchInterval) {
  return switch (backgroundFetchInterval) {
    BackgroundFetchInterval.never => "Never",
    BackgroundFetchInterval.thirtyMinutes => "30 minutes",
    BackgroundFetchInterval.oneHour => "1 hour",
    BackgroundFetchInterval.oneHourAndAHalf => "1.5 hours",
    BackgroundFetchInterval.twoHours => "2 hours",
    BackgroundFetchInterval.threeHours => "3 hours",
    BackgroundFetchInterval.sixHours => "6 hours",
    BackgroundFetchInterval.twelveHours => "12 hours",
    BackgroundFetchInterval.oneDay => "24 hours",
  };
}

const backgroundFetchIntervalValues = ["Never", "30 minutes", "1 hour", "1.5 hours", "2 hours", "3 hours", "6 hours", "12 hours", "24 hours"];

@JsonSerializable()
class SettingsStore extends _SettingsStore with _$SettingsStore {
  SettingsStore();

  factory SettingsStore.fromJson(Map<String, dynamic> json) => _$SettingsStoreFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsStoreToJson(this);
}

abstract class _SettingsStore with Store {
  // Defaults
  static const defaultDarkMode = DarkMode.system;
  static const defaultSort = FeedListSort.byDate;
  static const defaultMutedKeywords = <String>[];
  static const double defaultFontSize = 16.0;
  static const defaultTextWidth = TextWidth.normal;
  static const double defaultLineHeight = 1.2;
  static const double defaultHorizontalPadding = 8.0;
  static const defaultFontFamily = FontFamily.openSans;
  static const defaultMarkAsReadOnScroll = false;
  static const defaultBackgroundFetchInterval = BackgroundFetchInterval.twelveHours;
  static const defaultSkipBgFetchOnLowBattery = true;
  static const defaultRequireDeviceIdleForBgFetch = false;
  static const defaultStoryTilesMinimal = false;
  static const defaultStoryReaderMaxWidth = 800.0;
  static const defaultIsList = true;

  // Settings
  @JsonKey(defaultValue: defaultDarkMode, unknownEnumValue: DarkMode.system)
  @observable
  DarkMode darkMode = DarkMode.system;

  @action
  void setDarkMode(DarkMode value) {
    darkMode = value;
  }

  @JsonKey(defaultValue: defaultSort, unknownEnumValue: FeedListSort.byDate)
  @observable
  FeedListSort sort = FeedListSort.byDate;

  @action
  void setSort(FeedListSort newSort) {
    sort = newSort;
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @observable
  Feed? sortFeed;

  @action
  void setSortFeed(Feed feed) {
    sortFeed = feed;
  }

  @JsonKey(defaultValue: null)
  @observable
  String? sortFeedName;

  @action
  void setSortFeedName(String feedName) {
    sortFeedName = feedName;
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @observable
  FeedGroup? sortFeedGroup;

  @action
  void setSortFeedGroup(FeedGroup feedGroup) {
    sortFeedGroup = feedGroup;
  }

  @JsonKey(defaultValue: null)
  @observable
  String? sortFeedGroupName;

  @action
  void setSortFeedGroupName(String feedGroupName) {
    sortFeedGroupName = feedGroupName;
  }

  @JsonKey(defaultValue: true)
  @observable
  bool useReaderModeByDefault = true;

  @action
  void setUseReaderModeByDefault(bool value) {
    useReaderModeByDefault = value;
  }

  @JsonKey(defaultValue: true)
  @observable
  bool showAiSummaryOnLoad = true;

  @action
  void setShowAiSummaryOnLoad(bool value) {
    showAiSummaryOnLoad = value;
  }

  @JsonKey(defaultValue: false)
  @observable
  bool fetchAiSummaryOnLoad = false;

  @action
  void setFetchAiSummaryOnLoad(bool value) {
    fetchAiSummaryOnLoad = value;
  }

  @JsonKey(includeToJson: false, includeFromJson: false)
  @observable
  bool loading = false;

  @JsonKey(defaultValue: defaultMutedKeywords)
  @observable
  List<String> mutedKeywords = defaultMutedKeywords;

  // @JsonKey(defaultValue: defaultSuggestionsLeft)
  // @observable
  // int suggestionsLeftToday = defaultSuggestionsLeft;

  // @JsonKey(defaultValue: null)
  // @observable
  // DateTime? lastSuggestionDate;

  // @JsonKey(defaultValue: null)
  // @observable
  // DateTime? builtUserProfileDate;

  @JsonKey(defaultValue: KeepArticlesLength.threeMonths)
  @observable
  KeepArticlesLength keepArticles = KeepArticlesLength.threeMonths;

  @JsonKey(defaultValue: defaultFontSize)
  @observable
  double? fontSize = defaultFontSize;

  @action
  void setFontSize(double newSize) {
    fontSize = newSize;
  }

  @JsonKey(defaultValue: TextAlign.left)
  @observable
  TextAlign textAlignment = TextAlign.left;

  @action
  void setTextAlignment(TextAlign newAlignment) {
    textAlignment = newAlignment;
  }

  @JsonKey(defaultValue: defaultTextWidth)
  @observable
  TextWidth textWidth = defaultTextWidth;

  @action
  void setTextWidth(TextWidth newWidth) {
    textWidth = newWidth;
  }

  @JsonKey(defaultValue: defaultLineHeight)
  @observable
  double lineHeight = defaultLineHeight;

  @JsonKey(defaultValue: defaultHorizontalPadding)
  @observable
  double horizontalPadding = defaultHorizontalPadding;

  @JsonKey(defaultValue: defaultFontFamily)
  @observable
  FontFamily fontFamily = defaultFontFamily;

  @JsonKey(defaultValue: defaultMarkAsReadOnScroll)
  @observable
  bool markAsReadOnScroll = defaultMarkAsReadOnScroll;

  @JsonKey(defaultValue: defaultBackgroundFetchInterval)
  @observable
  BackgroundFetchInterval backgroundFetchInterval = defaultBackgroundFetchInterval;

  @JsonKey(defaultValue: defaultSkipBgFetchOnLowBattery)
  @observable
  bool skipBgSyncOnLowBattery = defaultSkipBgFetchOnLowBattery;

  @JsonKey(defaultValue: defaultRequireDeviceIdleForBgFetch)
  @observable
  bool requireDeviceIdleForBgFetch = defaultRequireDeviceIdleForBgFetch;

  @JsonKey(defaultValue: defaultStoryTilesMinimal)
  @observable
  bool storyTilesMinimalStyle = defaultStoryTilesMinimal;

  @JsonKey(defaultValue: defaultStoryReaderMaxWidth)
  @observable
  double storyReaderMaxWidth = defaultStoryReaderMaxWidth;

  @JsonKey(defaultValue: defaultIsList)
  @observable
  bool isList = defaultIsList;
}
