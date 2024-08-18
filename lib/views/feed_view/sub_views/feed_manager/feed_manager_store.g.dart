// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_manager_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FeedManagerStore on _FeedManagerStore, Store {
  Computed<bool>? _$areFeedGroupsSelectedComputed;

  @override
  bool get areFeedGroupsSelected => (_$areFeedGroupsSelectedComputed ??=
          Computed<bool>(() => super.areFeedGroupsSelected,
              name: '_FeedManagerStore.areFeedGroupsSelected'))
      .value;
  Computed<bool>? _$areFeedsSelectedComputed;

  @override
  bool get areFeedsSelected => (_$areFeedsSelectedComputed ??= Computed<bool>(
          () => super.areFeedsSelected,
          name: '_FeedManagerStore.areFeedsSelected'))
      .value;
  Computed<bool>? _$areMoreThanOneFeedGroupsSelectedComputed;

  @override
  bool get areMoreThanOneFeedGroupsSelected =>
      (_$areMoreThanOneFeedGroupsSelectedComputed ??= Computed<bool>(
              () => super.areMoreThanOneFeedGroupsSelected,
              name: '_FeedManagerStore.areMoreThanOneFeedGroupsSelected'))
          .value;

  late final _$selectionModeAtom =
      Atom(name: '_FeedManagerStore.selectionMode', context: context);

  @override
  bool get selectionMode {
    _$selectionModeAtom.reportRead();
    return super.selectionMode;
  }

  @override
  set selectionMode(bool value) {
    _$selectionModeAtom.reportWrite(value, super.selectionMode, () {
      super.selectionMode = value;
    });
  }

  late final _$selectedFeedsAtom =
      Atom(name: '_FeedManagerStore.selectedFeeds', context: context);

  @override
  ObservableList<Feed> get selectedFeeds {
    _$selectedFeedsAtom.reportRead();
    return super.selectedFeeds;
  }

  @override
  set selectedFeeds(ObservableList<Feed> value) {
    _$selectedFeedsAtom.reportWrite(value, super.selectedFeeds, () {
      super.selectedFeeds = value;
    });
  }

  late final _$selectedFeedGroupsAtom =
      Atom(name: '_FeedManagerStore.selectedFeedGroups', context: context);

  @override
  ObservableList<FeedGroup> get selectedFeedGroups {
    _$selectedFeedGroupsAtom.reportRead();
    return super.selectedFeedGroups;
  }

  @override
  set selectedFeedGroups(ObservableList<FeedGroup> value) {
    _$selectedFeedGroupsAtom.reportWrite(value, super.selectedFeedGroups, () {
      super.selectedFeedGroups = value;
    });
  }

  late final _$isarAtom =
      Atom(name: '_FeedManagerStore.isar', context: context);

  @override
  Isar get isar {
    _$isarAtom.reportRead();
    return super.isar;
  }

  @override
  set isar(Isar value) {
    _$isarAtom.reportWrite(value, super.isar, () {
      super.isar = value;
    });
  }

  late final _$dbUtilsAtom =
      Atom(name: '_FeedManagerStore.dbUtils', context: context);

  @override
  DbUtils get dbUtils {
    _$dbUtilsAtom.reportRead();
    return super.dbUtils;
  }

  bool _dbUtilsIsInitialized = false;

  @override
  set dbUtils(DbUtils value) {
    _$dbUtilsAtom
        .reportWrite(value, _dbUtilsIsInitialized ? super.dbUtils : null, () {
      super.dbUtils = value;
      _dbUtilsIsInitialized = true;
    });
  }

  late final _$initAsyncAction =
      AsyncAction('_FeedManagerStore.init', context: context);

  @override
  Future<void> init({required FeedStore feedStore}) {
    return _$initAsyncAction.run(() => super.init(feedStore: feedStore));
  }

  late final _$addFeedsToFeedGroupAsyncAction =
      AsyncAction('_FeedManagerStore.addFeedsToFeedGroup', context: context);

  @override
  Future<void> addFeedsToFeedGroup(List<FeedGroup> feedGroupsToAddFeedsTo) {
    return _$addFeedsToFeedGroupAsyncAction
        .run(() => super.addFeedsToFeedGroup(feedGroupsToAddFeedsTo));
  }

  late final _$handleDeleteAsyncAction =
      AsyncAction('_FeedManagerStore.handleDelete', context: context);

  @override
  Future<void> handleDelete({bool toggleSelection = true}) {
    return _$handleDeleteAsyncAction
        .run(() => super.handleDelete(toggleSelection: toggleSelection));
  }

  late final _$pinOrUnpinItemAsyncAction =
      AsyncAction('_FeedManagerStore.pinOrUnpinItem', context: context);

  @override
  Future<void> pinOrUnpinItem(dynamic feedOrFeedGroup, bool pin,
      {bool toggleSelection = true}) {
    return _$pinOrUnpinItemAsyncAction.run(() => super.pinOrUnpinItem(
        feedOrFeedGroup, pin,
        toggleSelection: toggleSelection));
  }

  late final _$reorderPinnedFeedsOrFeedGroupsAsyncAction = AsyncAction(
      '_FeedManagerStore.reorderPinnedFeedsOrFeedGroups',
      context: context);

  @override
  Future<void> reorderPinnedFeedsOrFeedGroups(int oldIndex, int newIndex) {
    return _$reorderPinnedFeedsOrFeedGroupsAsyncAction
        .run(() => super.reorderPinnedFeedsOrFeedGroups(oldIndex, newIndex));
  }

  late final _$_FeedManagerStoreActionController =
      ActionController(name: '_FeedManagerStore', context: context);

  @override
  void toggleSelectionMode() {
    final _$actionInfo = _$_FeedManagerStoreActionController.startAction(
        name: '_FeedManagerStore.toggleSelectionMode');
    try {
      return super.toggleSelectionMode();
    } finally {
      _$_FeedManagerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addSelectedFeed(Feed feed) {
    final _$actionInfo = _$_FeedManagerStoreActionController.startAction(
        name: '_FeedManagerStore.addSelectedFeed');
    try {
      return super.addSelectedFeed(feed);
    } finally {
      _$_FeedManagerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeSelectedFeed(Feed feed) {
    final _$actionInfo = _$_FeedManagerStoreActionController.startAction(
        name: '_FeedManagerStore.removeSelectedFeed');
    try {
      return super.removeSelectedFeed(feed);
    } finally {
      _$_FeedManagerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedFeed(List<Feed> feeds) {
    final _$actionInfo = _$_FeedManagerStoreActionController.startAction(
        name: '_FeedManagerStore.setSelectedFeed');
    try {
      return super.setSelectedFeed(feeds);
    } finally {
      _$_FeedManagerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addSelectedFeedGroup(FeedGroup feedGroup) {
    final _$actionInfo = _$_FeedManagerStoreActionController.startAction(
        name: '_FeedManagerStore.addSelectedFeedGroup');
    try {
      return super.addSelectedFeedGroup(feedGroup);
    } finally {
      _$_FeedManagerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeSelectedFeedGroup(FeedGroup feedGroup) {
    final _$actionInfo = _$_FeedManagerStoreActionController.startAction(
        name: '_FeedManagerStore.removeSelectedFeedGroup');
    try {
      return super.removeSelectedFeedGroup(feedGroup);
    } finally {
      _$_FeedManagerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedFeedGroup(List<FeedGroup> feedGroups) {
    final _$actionInfo = _$_FeedManagerStoreActionController.startAction(
        name: '_FeedManagerStore.setSelectedFeedGroup');
    try {
      return super.setSelectedFeedGroup(feedGroups);
    } finally {
      _$_FeedManagerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void createFeedGroupDialog(BuildContext context) {
    final _$actionInfo = _$_FeedManagerStoreActionController.startAction(
        name: '_FeedManagerStore.createFeedGroupDialog');
    try {
      return super.createFeedGroupDialog(context);
    } finally {
      _$_FeedManagerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void handleFeedTileLongPress(Feed feed) {
    final _$actionInfo = _$_FeedManagerStoreActionController.startAction(
        name: '_FeedManagerStore.handleFeedTileLongPress');
    try {
      return super.handleFeedTileLongPress(feed);
    } finally {
      _$_FeedManagerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void handleFeedTileTap(Feed feed) {
    final _$actionInfo = _$_FeedManagerStoreActionController.startAction(
        name: '_FeedManagerStore.handleFeedTileTap');
    try {
      return super.handleFeedTileTap(feed);
    } finally {
      _$_FeedManagerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void handleFeedGroupLongPress(FeedGroup feedGroup) {
    final _$actionInfo = _$_FeedManagerStoreActionController.startAction(
        name: '_FeedManagerStore.handleFeedGroupLongPress');
    try {
      return super.handleFeedGroupLongPress(feedGroup);
    } finally {
      _$_FeedManagerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void handleFeedGroupTap(FeedGroup feedGroup) {
    final _$actionInfo = _$_FeedManagerStoreActionController.startAction(
        name: '_FeedManagerStore.handleFeedGroupTap');
    try {
      return super.handleFeedGroupTap(feedGroup);
    } finally {
      _$_FeedManagerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectionMode: ${selectionMode},
selectedFeeds: ${selectedFeeds},
selectedFeedGroups: ${selectedFeedGroups},
isar: ${isar},
dbUtils: ${dbUtils},
areFeedGroupsSelected: ${areFeedGroupsSelected},
areFeedsSelected: ${areFeedsSelected},
areMoreThanOneFeedGroupsSelected: ${areMoreThanOneFeedGroupsSelected}
    ''';
  }
}
