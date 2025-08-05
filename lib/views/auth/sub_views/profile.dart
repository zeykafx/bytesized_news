import 'dart:io';

import 'package:bytesized_news/views/auth/auth.dart';
import 'package:bytesized_news/views/auth/auth_store.dart';
import 'package:bytesized_news/views/auth/sub_views/keywords_bottom_sheet.dart';
import 'package:bytesized_news/views/purchase/purchase_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? user;
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController textEditingController = TextEditingController();
  late AuthStore authStore;

  @override
  void initState() {
    super.initState();
    authStore = context.read<AuthStore>();
    user = auth.currentUser;
  }

  Widget buildPremiumUpgradeCard() {
    if (!Platform.isAndroid) {
      return SizedBox.shrink();
    }
    
    return Container(
      width: double.infinity,
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.of(context)
                .push(
              MaterialPageRoute(
                builder: (context) => const PurchaseView(),
              ),
            )
                .then((_) async {
              setState(() {});
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.workspace_premium,
                      color: Theme.of(context).colorScheme.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      authStore.userTier == Tier.premium ? "You have premium!" : "Upgrade to Premium",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            // fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProfileScreen(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      auth: auth,
      avatar: Column(
        children: [
          const CircleAvatar(
            radius: 30,
            child: Icon(Icons.person, size: 50),
          ),
          const SizedBox(height: 10),
          Text(user?.email ?? "No Email", style: const TextStyle(fontSize: 16)),
        ],
      ),
      showDeleteConfirmationDialog: true,
      actions: [
        SignedOutAction((context) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const Auth(),
            ),
            (route) => false, // remove all routes
          );
        }),
      ],
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 0,
            vertical: 4.0,
          ),
          child: const Divider(thickness: 0.5),
        ),
        Container(
          padding: const EdgeInsets.only(top: 0, bottom: 5.0, left: 0.0),
          child: Text(
            "General User Settings",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
        KeywordsBottomSheet(
          getKeywords: () {
            return authStore.userInterests;
          },
          title: "News Interests",
          additionCallback: (String text) {
            authStore.userInterests = [
              ...authStore.userInterests,
              text,
            ];
          },
          removalCallback: (int index) {
            authStore.userInterests = [
              ...authStore.userInterests..removeAt(index),
            ];
          },
          removePadding: true,
        ),
        const SizedBox(height: 8),
        buildPremiumUpgradeCard(),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 0,
            vertical: 4.0,
          ),
          child: const Divider(thickness: 0.5),
        ),
        if (authStore.userTier == Tier.premium) ...[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 0.0, bottom: 5.0, left: 0.0),
                child: Text(
                  "AI Usage",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),
              Text(
                "Summaries left today: ${authStore.summariesLeftToday}",
              ),
              Text(
                "Suggestions left today: ${authStore.suggestionsLeftToday}",
              ),
              const SizedBox(height: 3),
              Text(
                "Limits are reset daily.",
                style: TextStyle(
                  color: Theme.of(context).dividerColor,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 0,
              vertical: 4.0,
            ),
            child: const Divider(thickness: 0.5),
          ),
        ],
      ],
    );
  }
}
