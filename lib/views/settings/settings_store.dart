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

enum FeedListSort { byDate, today, unread, read, bookmarked }

String feedListSortToString(FeedListSort sort) {
  switch (sort) {
    case FeedListSort.byDate:
      return "By Date";
    case FeedListSort.today:
      return "Today";
    case FeedListSort.unread:
      return "Unread";
    case FeedListSort.read:
      return "Read";
    case FeedListSort.bookmarked:
      return "Bookmarked";
  }
}

@JsonSerializable()
class SettingsStore extends _SettingsStore with _$SettingsStore {
  SettingsStore();

  factory SettingsStore.fromJson(Map<String, dynamic> json) => _$SettingsStoreFromJson(json);

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
}
