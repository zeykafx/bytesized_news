// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PurchaseStore on _PurchaseStore, Store {
  late final _$authStoreAtom = Atom(
    name: '_PurchaseStore.authStore',
    context: context,
  );

  @override
  AuthStore get authStore {
    _$authStoreAtom.reportRead();
    return super.authStore;
  }

  bool _authStoreIsInitialized = false;

  @override
  set authStore(AuthStore value) {
    _$authStoreAtom.reportWrite(
      value,
      _authStoreIsInitialized ? super.authStore : null,
      () {
        super.authStore = value;
        _authStoreIsInitialized = true;
      },
    );
  }

  late final _$loadingAtom = Atom(
    name: '_PurchaseStore.loading',
    context: context,
  );

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

  late final _$hasAlertAtom = Atom(
    name: '_PurchaseStore.hasAlert',
    context: context,
  );

  @override
  bool get hasAlert {
    _$hasAlertAtom.reportRead();
    return super.hasAlert;
  }

  @override
  set hasAlert(bool value) {
    _$hasAlertAtom.reportWrite(value, super.hasAlert, () {
      super.hasAlert = value;
    });
  }

  late final _$alertMessageAtom = Atom(
    name: '_PurchaseStore.alertMessage',
    context: context,
  );

  @override
  String get alertMessage {
    _$alertMessageAtom.reportRead();
    return super.alertMessage;
  }

  @override
  set alertMessage(String value) {
    _$alertMessageAtom.reportWrite(value, super.alertMessage, () {
      super.alertMessage = value;
    });
  }

  late final _$initIAPAsyncAction = AsyncAction(
    '_PurchaseStore.initIAP',
    context: context,
  );

  @override
  Future<void> initIAP(AuthStore aStore) {
    return _$initIAPAsyncAction.run(() => super.initIAP(aStore));
  }

  late final _$restorePurchaseAsyncAction = AsyncAction(
    '_PurchaseStore.restorePurchase',
    context: context,
  );

  @override
  Future<void> restorePurchase(BuildContext context) {
    return _$restorePurchaseAsyncAction.run(
      () => super.restorePurchase(context),
    );
  }

  @override
  String toString() {
    return '''
authStore: ${authStore},
loading: ${loading},
hasAlert: ${hasAlert},
alertMessage: ${alertMessage}
    ''';
  }
}
