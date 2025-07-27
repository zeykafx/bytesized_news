import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mobx/mobx.dart';

part 'purchase_store.g.dart';

class PurchaseStore = _PurchaseStore with _$PurchaseStore;

abstract class _PurchaseStore with Store {
  Set<String> productIds = <String>{'premium'};

  @observable
  InAppPurchase inAppPurchase = InAppPurchase.instance;

  @observable
  bool storeAvailable = true;

  @observable
  StreamSubscription<List<PurchaseDetails>>? subscription;

  @observable
  List<ProductDetails> products = [];

  @observable
  bool loading = false;

  @action
  Future<void> initIAP() async {
    storeAvailable = await inAppPurchase.isAvailable();
    if (!storeAvailable) {
      if (kDebugMode) {
        print("Couldn't connect to the store");
      }
    }

    final Stream purchaseUpdated = inAppPurchase.purchaseStream;
    subscription = purchaseUpdated.listen(
      (purchaseDetailsList) {
        listenToPurchaseUpdated(purchaseDetailsList);
      },
      onDone: () {
        subscription?.cancel();
      },
      onError: (error) {
        if (kDebugMode) {
          print(error);
        }
      },
    ) as StreamSubscription<List<PurchaseDetails>>?;

    final ProductDetailsResponse response = await inAppPurchase.queryProductDetails(productIds);

    if (response.notFoundIDs.isNotEmpty) {
      if (kDebugMode) {
        print("Couldn't find ids, ${response.notFoundIDs.toString()}");
      }
    }
    List<ProductDetails> productDetails = response.productDetails;
    if (kDebugMode) {
      print(productDetails);
    }
    products.clear();
    products.addAll(productDetails);
  }

  @action
  Future<void> listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
    for (PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        print("Purchase Pending: ${purchaseDetails.productID}");

        loading = true;
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          print("Error purchasing: ${purchaseDetails.error?.message}");
          loading = false;
        } else if (purchaseDetails.status == PurchaseStatus.purchased || purchaseDetails.status == PurchaseStatus.restored) {
          print("Purchase Successfull: ${purchaseDetails.productID}");
          loading = false;
        }
        if (purchaseDetails.pendingCompletePurchase) {
          print("Completing purchase of product: ${purchaseDetails.productID}");
          await InAppPurchase.instance.completePurchase(purchaseDetails);
        }
      }
    }
  }
}
