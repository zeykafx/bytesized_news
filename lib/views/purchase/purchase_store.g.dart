// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PurchaseStore on _PurchaseStore, Store {
  late final _$inAppPurchaseAtom =
      Atom(name: '_PurchaseStore.inAppPurchase', context: context);

  @override
  InAppPurchase get inAppPurchase {
    _$inAppPurchaseAtom.reportRead();
    return super.inAppPurchase;
  }

  @override
  set inAppPurchase(InAppPurchase value) {
    _$inAppPurchaseAtom.reportWrite(value, super.inAppPurchase, () {
      super.inAppPurchase = value;
    });
  }

  late final _$storeAvailableAtom =
      Atom(name: '_PurchaseStore.storeAvailable', context: context);

  @override
  bool get storeAvailable {
    _$storeAvailableAtom.reportRead();
    return super.storeAvailable;
  }

  @override
  set storeAvailable(bool value) {
    _$storeAvailableAtom.reportWrite(value, super.storeAvailable, () {
      super.storeAvailable = value;
    });
  }

  late final _$subscriptionAtom =
      Atom(name: '_PurchaseStore.subscription', context: context);

  @override
  StreamSubscription<List<PurchaseDetails>>? get subscription {
    _$subscriptionAtom.reportRead();
    return super.subscription;
  }

  @override
  set subscription(StreamSubscription<List<PurchaseDetails>>? value) {
    _$subscriptionAtom.reportWrite(value, super.subscription, () {
      super.subscription = value;
    });
  }

  late final _$productsAtom =
      Atom(name: '_PurchaseStore.products', context: context);

  @override
  List<ProductDetails> get products {
    _$productsAtom.reportRead();
    return super.products;
  }

  @override
  set products(List<ProductDetails> value) {
    _$productsAtom.reportWrite(value, super.products, () {
      super.products = value;
    });
  }

  late final _$loadingAtom =
      Atom(name: '_PurchaseStore.loading', context: context);

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

  late final _$initIAPAsyncAction =
      AsyncAction('_PurchaseStore.initIAP', context: context);

  @override
  Future<void> initIAP() {
    return _$initIAPAsyncAction.run(() => super.initIAP());
  }

  late final _$listenToPurchaseUpdatedAsyncAction =
      AsyncAction('_PurchaseStore.listenToPurchaseUpdated', context: context);

  @override
  Future<void> listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) {
    return _$listenToPurchaseUpdatedAsyncAction
        .run(() => super.listenToPurchaseUpdated(purchaseDetailsList));
  }

  @override
  String toString() {
    return '''
inAppPurchase: ${inAppPurchase},
storeAvailable: ${storeAvailable},
subscription: ${subscription},
products: ${products},
loading: ${loading}
    ''';
  }
}
