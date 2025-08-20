import 'dart:io';
import 'package:bytesized_news/views/auth/auth.dart';
import 'package:bytesized_news/views/auth/auth_store.dart';
import 'package:bytesized_news/views/auth/sub_views/keywords_bottom_sheet.dart';
import 'package:bytesized_news/views/purchase/purchase_view.dart';
import 'package:bytesized_news/views/reading_statistics_view/reading_statistics_view.dart';
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
  int readingStreak = 0;
  Duration totalReadingTime = Duration(hours: 0);
  int articlesRead = 0;

  @override
  void initState() {
    super.initState();
    authStore = context.read<AuthStore>();
    user = auth.currentUser;

    getReadingStats();
  }

  Future<void> getReadingStats() async {
    readingStreak = await authStore.dbUtils.getReadingDaysStreak();
    articlesRead = await authStore.dbUtils.getNumberArticlesRead();
    totalReadingTime = await authStore.dbUtils.getReadingTime();
    setState(() {});
  }

  Widget buildReadingStatsCard() {
    return Card.filled(
      margin: EdgeInsets.zero,
      color: Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.7),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ReadingStatisticsView()));
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(Icons.auto_stories, color: Theme.of(context).colorScheme.primary, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Reading Statistics",
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Theme.of(context).colorScheme.onSecondaryContainer.withValues(alpha: 0.6), size: 16),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ReadingStatsCardItem(context: context, title: "Streak", content: "$readingStreak days", icon: Icons.local_fire_department),
                    ReadingStatsCardItem(context: context, title: "Articles Read", content: articlesRead.toString(), icon: Icons.numbers_rounded),
                    ReadingStatsCardItem(
                      context: context,
                      title: "Total Time",
                      content: "${totalReadingTime.inHours}h ${totalReadingTime.inMinutes.remainder(60)}m",
                      icon: Icons.schedule,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "Tap to view detailed stats and reading history",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer.withValues(alpha: 0.6)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPremiumUpgradeCard() {
    if (!Platform.isAndroid) {
      return SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Theme.of(context).colorScheme.primaryContainer, Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5)],
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
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PurchaseView())).then((_) async {
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
                    Icon(Icons.workspace_premium, color: Theme.of(context).colorScheme.primary, size: 24),
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
      appBar: AppBar(title: const Text("Profile")),
      auth: auth,
      avatar: Column(
        children: [
          const CircleAvatar(radius: 30, child: Icon(Icons.person, size: 50)),
          const SizedBox(height: 10),
          Text(user?.email ?? "No Email", style: const TextStyle(fontSize: 16)),
        ],
      ),
      showDeleteConfirmationDialog: true,
      actions: [
        SignedOutAction((context) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const Auth()),
            (route) => false, // remove all routes
          );
        }),
      ],
      children: [
        Padding(padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4.0), child: const Divider(thickness: 0.5)),
        Container(
          padding: const EdgeInsets.only(top: 0, bottom: 5.0, left: 0.0),
          child: Text("General User Settings", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
        ),

        KeywordsBottomSheet(
          getKeywords: () {
            return authStore.userInterests;
          },
          title: "News Interests",
          additionCallback: (String text) {
            authStore.userInterests = [...authStore.userInterests, text];
          },
          removalCallback: (int index) {
            authStore.userInterests = [...authStore.userInterests..removeAt(index)];
          },
          removePadding: true,
        ),

        const SizedBox(height: 8),
        buildPremiumUpgradeCard(),

        const SizedBox(height: 8),
        buildReadingStatsCard(),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4.0),
          child: const Divider(thickness: 0.5),
        ),

        if (authStore.userTier == Tier.premium) ...[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 0.0, bottom: 5.0, left: 0.0),
                child: Text("AI Usage", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              ),
              Text("Summaries left today: ${authStore.summariesLeftToday}"),
              Text("Suggestions left today: ${authStore.suggestionsLeftToday}"),
              const SizedBox(height: 3),
              Text("Limits are reset daily at midnight UTC", style: TextStyle(color: Theme.of(context).dividerColor)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4.0),
            child: const Divider(thickness: 0.5),
          ),
        ],
      ],
    );
  }
}

class ReadingStatsCardItem extends StatelessWidget {
  const ReadingStatsCardItem({
    super.key,
    required this.context,
    required this.title,
    required this.content,
    required this.icon,
  });

  final BuildContext context;
  final String title;
  final String content;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
        const SizedBox(width: 3),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style:
                  Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSecondaryContainer.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                  ),
            ),
            Text(
              content,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),
            ),
          ],
        ),
      ],
    );
  }
}
