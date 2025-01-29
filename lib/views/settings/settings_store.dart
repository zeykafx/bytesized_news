import 'package:bytesized_news/models/feed/feed.dart';
import 'package:bytesized_news/models/feedGroup/feedGroup.dart';
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

enum FeedListSort { byDate, today, unread, read, bookmarked, feed, feedGroup }

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
    case FeedListSort.bookmarked:
      return "Bookmarked";
    case FeedListSort.feed:
      return "Feed";
    case FeedListSort.feedGroup:
      return "Feed Group";
  }
}

@JsonSerializable()
class SettingsStore extends _SettingsStore with _$SettingsStore {
  SettingsStore();

  factory SettingsStore.fromJson(Map<String, dynamic> json) =>
      _$SettingsStoreFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsStoreToJson(this);
}

abstract class _SettingsStore with Store {
  static const defaultDarkMode = DarkMode.system;
  static const defaultSort = FeedListSort.byDate;

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
  setSort(FeedListSort newSort) {
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

  static const defaultUserInterests = [
    "Technology",
    "Politics",
  ];

  @JsonKey(defaultValue: defaultUserInterests)
  @observable
  List<String> userInterests = defaultUserInterests;
}
