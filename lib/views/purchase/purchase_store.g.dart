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

  late final _$functionsAtom =
      Atom(name: '_PurchaseStore.functions', context: context);

  @override
  FirebaseFunctions get functions {
    _$functionsAtom.reportRead();
    return super.functions;
  }

  @override
  set functions(FirebaseFunctions value) {
    _$functionsAtom.reportWrite(value, super.functions, () {
      super.functions = value;
    });
  }

  late final _$authStoreAtom =
      Atom(name: '_PurchaseStore.authStore', context: context);

  @override
  AuthStore get authStore {
    _$authStoreAtom.reportRead();
    return super.authStore;
  }

  bool _authStoreIsInitialized = false;

  @override
  set authStore(AuthStore value) {
    _$authStoreAtom.reportWrite(
        value, _authStoreIsInitialized ? super.authStore : null, () {
      super.authStore = value;
      _authStoreIsInitialized = true;
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
  ObservableList<ProductDetails> get products {
    _$productsAtom.reportRead();
    return super.products;
  }

  @override
  set products(ObservableList<ProductDetails> value) {
    _$productsAtom.reportWrite(value, super.products, () {
      super.products = value;
    });
  }

  late final _$purchasedProductsAtom =
      Atom(name: '_PurchaseStore.purchasedProducts', context: context);

  @override
  ObservableList<ProductDetails> get purchasedProducts {
    _$purchasedProductsAtom.reportRead();
    return super.purchasedProducts;
  }

  @override
  set purchasedProducts(ObservableList<ProductDetails> value) {
    _$purchasedProductsAtom.reportWrite(value, super.purchasedProducts, () {
      super.purchasedProducts = value;
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

  late final _$hasAlertAtom =
      Atom(name: '_PurchaseStore.hasAlert', context: context);

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

  late final _$alertMessageAtom =
      Atom(name: '_PurchaseStore.alertMessage', context: context);

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

  late final _$initIAPAsyncAction =
      AsyncAction('_PurchaseStore.initIAP', context: context);

  @override
  Future<void> initIAP(AuthStore aStore) {
    return _$initIAPAsyncAction.run(() => super.initIAP(aStore));
  }

  late final _$listenToPurchaseUpdatedAsyncAction =
      AsyncAction('_PurchaseStore.listenToPurchaseUpdated', context: context);

  @override
  Future<void> listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) {
    return _$listenToPurchaseUpdatedAsyncAction
        .run(() => super.listenToPurchaseUpdated(purchaseDetailsList));
  }

  late final _$restorePurchaseAsyncAction =
      AsyncAction('_PurchaseStore.restorePurchase', context: context);

  @override
  Future<void> restorePurchase(BuildContext context) {
    return _$restorePurchaseAsyncAction
        .run(() => super.restorePurchase(context));
  }

  late final _$loadFirestorePurchasesAsyncAction =
      AsyncAction('_PurchaseStore.loadFirestorePurchases', context: context);

  @override
  Future<void> loadFirestorePurchases() {
    return _$loadFirestorePurchasesAsyncAction
        .run(() => super.loadFirestorePurchases());
  }

  @override
  String toString() {
    return '''
inAppPurchase: ${inAppPurchase},
functions: ${functions},
authStore: ${authStore},
storeAvailable: ${storeAvailable},
subscription: ${subscription},
products: ${products},
purchasedProducts: ${purchasedProducts},
loading: ${loading},
hasAlert: ${hasAlert},
alertMessage: ${alertMessage}
    ''';
  }
}
