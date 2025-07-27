import 'package:flutter/foundation.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:bytesized_news/views/purchase/purchase_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class PurchaseView extends StatefulWidget {
  const PurchaseView({super.key});

  @override
  State<PurchaseView> createState() => _PurchaseViewState();
}

class _PurchaseViewState extends State<PurchaseView> {
  PurchaseStore purchaseStore = PurchaseStore();

  @override
  void initState() {
    purchaseStore.initIAP();
    super.initState();
  }

  @override
  void dispose() {
    purchaseStore.subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Scaffold(
        appBar: AppBar(title: const Text("Upgrade")),
        body: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 800),
            child: Column(
              children: [
                if (purchaseStore.loading) ...[
                  const Center(child: LinearProgressIndicator()),
                ],
                if (purchaseStore.products.isEmpty) ...[
                  const Text("Failed to load products from the store."),
                ],
                for (ProductDetails product in purchaseStore.products)
                  Card(
                    margin: EdgeInsets.all(8.0),
                    elevation: 1.0,
                    child: ListTile(
                      leading: Icon(LucideIcons.coins),
                      title: Text(product.description),
                      subtitle: Text(product.price),
                      enabled: !purchaseStore.loading,
                      enableFeedback: true,
                      onTap: () {
                        if (kDebugMode) {
                          print("Starting purchase of item with id: ${product.id}");
                        }
                        final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
                        InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
                      },
                    ),
                  )
              ],
            ),
          ),
        ),
      );
    });
  }
}
