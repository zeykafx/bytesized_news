import 'package:bytesized_news/views/auth/auth_store.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:bytesized_news/views/purchase/purchase_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

class PurchaseView extends StatefulWidget {
  const PurchaseView({super.key});

  @override
  State<PurchaseView> createState() => _PurchaseViewState();
}

class _PurchaseViewState extends State<PurchaseView> {
  PurchaseStore purchaseStore = PurchaseStore();
  late AuthStore authStore;

  @override
  void initState() {
    authStore = context.read<AuthStore>();
    purchaseStore.initIAP(authStore);

    reaction((_) => purchaseStore.hasAlert, (bool hasAlert) {
      // if there is an alert to show, show it in a snackbar
      if (hasAlert) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(purchaseStore.alertMessage),
            duration: Duration(seconds: 30),
          ),
        );
        purchaseStore.hasAlert = false;
        purchaseStore.alertMessage = "";
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    purchaseStore.subscription?.cancel();

    super.dispose();
  }

  Widget _buildFeatureItem(BuildContext context, IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 1),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCard(String title, String description, {bool isInfo = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: isInfo
            ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3)
            : Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isInfo ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.3) : Theme.of(context).colorScheme.error.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(
            isInfo ? Icons.info_rounded : Icons.error,
            color: isInfo ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.error,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isInfo ? Theme.of(context).colorScheme.onPrimaryContainer : Theme.of(context).colorScheme.onErrorContainer,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isInfo ? Theme.of(context).colorScheme.onPrimaryContainer : Theme.of(context).colorScheme.onErrorContainer,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms, curve: Curves.easeInOutQuad);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Scaffold(
        appBar: AppBar(title: const Text("Upgrade to Premium")),
        body: Align(
          alignment: Alignment.topCenter,
          child: Container(
            constraints: BoxConstraints(maxWidth: 800),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.primaryContainer,
                            Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.workspace_premium,
                                color: Theme.of(context).colorScheme.primary,
                                size: 32,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                "Upgrade to Premium",
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "The premium features of Bytesized News are features that induce cost on my end. I'm a student, I cannot afford to provide these features for free. The premium upgrade is a one time purchase that will help pay for these server costs.",
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                                ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Features Section
                    Text(
                      "Premium Features",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 16),

                    _buildFeatureItem(
                      context,
                      LucideIcons.zap,
                      "Instant Article Summarization",
                      "Get quick summaries for any articles",
                    ),
                    _buildFeatureItem(
                      context,
                      LucideIcons.heart,
                      "Personalized News Suggestions",
                      "Tailored content based on your taste profile",
                    ),
                    _buildFeatureItem(
                      context,
                      LucideIcons.folder_sync,
                      "Cross-Device Synchronization",
                      "Keep your feeds and groups in sync across all of your devices",
                    ),
                    _buildFeatureItem(
                      context,
                      LucideIcons.coffee,
                      "Support Development",
                      "Help me continue improving Bytesized News",
                    ),

                    const SizedBox(height: 8),

                    // Pricing Info
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                LucideIcons.info,
                                color: Theme.of(context).colorScheme.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Important note",
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                              children: <TextSpan>[
                                TextSpan(text: 'All products below offer '),
                                TextSpan(text: 'the same premium features', style: const TextStyle(fontWeight: FontWeight.w600)),
                                TextSpan(text: '. Choose the price that works best for you.'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    Text(
                      "Available Products",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 16),

                    if (purchaseStore.loading) ...[
                      const Center(
                          child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: LinearProgressIndicator(),
                      )),
                    ],

                    if (authStore.hasUserRefunded) ...[
                      buildCard(
                        "Premium upgrades unavailable",
                        "You have refunded purchase(s) in the past, this prevents you from purchasing upgrades to prevent abuse. Please contact me at corentin.detry(at)gmail.com if you believe this is a mistake.",
                      ),
                    ] else ...[
                      // Error card if we cant load the products from the store
                      if (purchaseStore.products.isEmpty) ...[
                        buildCard("Failed to load products from the store", "Please check your internet connection and try again"),
                      ],

                      if (authStore.userTier != Tier.free) ...[
                        buildCard(
                          "You already have premium!",
                          "You have already purchased a premium upgrade, but you can always purchase another one to support the development of this app. Thank you again for your support!",
                          isInfo: true,
                        ),
                        const SizedBox(height: 16),
                      ],

                      // All products
                      for (ProductDetails product in purchaseStore.products)
                        Container(
                          margin: const EdgeInsets.only(bottom: 16.0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.6),
                                Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.4),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: purchaseStore.loading || purchaseStore.purchasedProducts.contains(product)
                                  ? null
                                  : () {
                                      if (kDebugMode) {
                                        print("Starting purchase of item with id: ${product.id}");
                                      }
                                      final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
                                      InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
                                    },
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        // Crown icon
                                        Container(
                                          padding: const EdgeInsets.all(12.0),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Icon(
                                            Icons.workspace_premium,
                                            color: Theme.of(context).colorScheme.primary,
                                            size: 24,
                                          ),
                                        ),
                                        const SizedBox(width: 16),

                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // Title
                                              Text(
                                                product.title,
                                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                      fontWeight: FontWeight.w500,
                                                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                                                    ),
                                              ),
                                              const SizedBox(height: 4),
                                              // description
                                              Text(
                                                product.description,
                                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                      color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.primary,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            product.price,
                                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                  color: Theme.of(context).colorScheme.onPrimary,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ),
                                        if (purchaseStore.loading) ...[
                                          const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          ),
                                        ] else if (purchaseStore.purchasedProducts.contains(product)) ...[
                                          Text(
                                            "Purchased!",
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                  color: Theme.of(context).colorScheme.primary,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ] else ...[
                                          Row(
                                            children: [
                                              Text(
                                                "Tap to purchase",
                                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                      color: Theme.of(context).colorScheme.primary,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                              ),
                                              const SizedBox(width: 8),
                                              Icon(
                                                LucideIcons.arrow_right,
                                                color: Theme.of(context).colorScheme.primary,
                                                size: 16,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ).animate().fadeIn(
                              curve: Curves.easeInOutQuad,
                              duration: 400.ms,
                            ),
                    ],

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
