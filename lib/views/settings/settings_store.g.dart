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
          FeedListSort.byDate;

Map<String, dynamic> _$SettingsStoreToJson(SettingsStore instance) =>
    <String, dynamic>{
      'darkMode': _$DarkModeEnumMap[instance.darkMode]!,
      'sort': _$FeedListSortEnumMap[instance.sort]!,
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
  String toString() {
    return '''
darkMode: ${darkMode},
sort: ${sort}
    ''';
  }
}
