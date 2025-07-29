import 'dart:async';
import 'package:bytesized_news/views/auth/auth_store.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mobx/mobx.dart';

part 'purchase_store.g.dart';

class PurchaseStore = _PurchaseStore with _$PurchaseStore;

abstract class _PurchaseStore with Store {
  Set<String> productIds = <String>{'premium_low', 'premium', 'premium_high', 'premium_ultra'};

  @observable
  InAppPurchase inAppPurchase = InAppPurchase.instance;

  @observable
  FirebaseFunctions functions = FirebaseFunctions.instanceFor(region: "europe-west1");

  @observable
  late AuthStore authStore;

  @observable
  bool storeAvailable = true;

  @observable
  StreamSubscription<List<PurchaseDetails>>? subscription;

  @observable
  ObservableList<ProductDetails> products = <ProductDetails>[].asObservable();

  @observable
  ObservableList<ProductDetails> purchasedProducts = <ProductDetails>[].asObservable();

  @observable
  bool loading = false;

  @observable
  bool hasAlert = false;
  @observable
  String alertMessage = "";

  @action
  Future<void> restorePurchase(BuildContext context) async {
    try {
      await inAppPurchase.restorePurchases();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Successfully restored purchases!"),
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error restoring purchases: ${e.toString()}"),
          ),
        );
      }
    }
  }

  @action
  Future<void> initIAP(AuthStore aStore) async {
    if (kDebugMode) {
      print("Initializing In-App Purchase");
    }
    authStore = aStore;
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

    productDetails.sort((a, b) => a.rawPrice.toInt() - b.rawPrice.toInt());
    products.clear();
    products.addAll(productDetails);
  }

  @action
  Future<void> listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
    for (PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        if (kDebugMode) {
          print("Purchase Pending: ${purchaseDetails.productID}");
        }

        loading = true;
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          if (kDebugMode) {
            print("Error purchasing: ${purchaseDetails.error?.message}");
          }
          loading = false;
        } else if (purchaseDetails.status == PurchaseStatus.purchased || purchaseDetails.status == PurchaseStatus.restored) {
          if (kDebugMode) {
            print("Purchasing: ${purchaseDetails.productID}");
          }

          // call the function to verify the purchase
          final result = await functions.httpsCallable('verifyPurchases').call(
            {
              "source": purchaseDetails.verificationData.source,
              "productId": purchaseDetails.productID,
              "verificationData": purchaseDetails.verificationData.serverVerificationData,
            },
          );
          if (kDebugMode) {
            print("Response from verifyPurchases: ${result.data}");
          }

          var response = result.data as Map<String, dynamic>;
          if (response["error"] != null) {
            throw Exception(response["error"]);
          }

          // if the code isn't 200, then the verification failed
          if (response["status"] != 200) {
            if (kDebugMode) {
              print("Purchase verification failed: ${response["message"]}");
            }
            loading = false;
            alertMessage = "Failed to verify purchase: ${response["message"]}";
            hasAlert = true;
            // complete the purchase even if verification failed to prevent it from staying pending
            if (purchaseDetails.pendingCompletePurchase) {
              await InAppPurchase.instance.completePurchase(purchaseDetails);
            }

            return;
          }

          // verification successful
          if (kDebugMode) {
            print("Purchase verified successfully: ${purchaseDetails.productID}");
          }
          // update local state
          purchasedProducts.add(products.firstWhere((pro) => pro.id == purchaseDetails.productID));
          // update the auth store
          authStore.userTier = Tier.premium;

          // show success snackbar
          alertMessage = "Successfully purchased premium! Thank you!!";
          hasAlert = true;
          
          loading = false;
          // since the server has verified the purchase, we can complete it now
          if (purchaseDetails.pendingCompletePurchase) {
            if (kDebugMode) {
              print("Completing purchase of product: ${purchaseDetails.productID}");
            }
            await InAppPurchase.instance.completePurchase(purchaseDetails);
          }
        }
      }
    }
  }
}
