// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'curated_feeds_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CuratedFeedsStore on _CuratedFeedsStore, Store {
  late final _$curatedCategoriesAtom =
      Atom(name: '_CuratedFeedsStore.curatedCategories', context: context);

  @override
  List<CuratedFeedCategory> get curatedCategories {
    _$curatedCategoriesAtom.reportRead();
    return super.curatedCategories;
  }

  @override
  set curatedCategories(List<CuratedFeedCategory> value) {
    _$curatedCategoriesAtom.reportWrite(value, super.curatedCategories, () {
      super.curatedCategories = value;
    });
  }

  late final _$loadingAtom =
      Atom(name: '_CuratedFeedsStore.loading', context: context);

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

  late final _$readCuratedFeedsAsyncAction =
      AsyncAction('_CuratedFeedsStore.readCuratedFeeds', context: context);

  @override
  Future<void> readCuratedFeeds(BuildContext context) {
    return _$readCuratedFeedsAsyncAction
        .run(() => super.readCuratedFeeds(context));
  }

  @override
  String toString() {
    return '''
curatedCategories: ${curatedCategories},
loading: ${loading}
    ''';
  }
}
