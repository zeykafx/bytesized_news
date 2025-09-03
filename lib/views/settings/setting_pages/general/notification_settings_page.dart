import 'dart:io';

import 'package:bytesized_news/database/db_utils.dart';
import 'package:bytesized_news/models/feed/feed.dart';
import 'package:bytesized_news/views/auth/auth_store.dart';
import 'package:bytesized_news/views/settings/setting_pages/general/notification_settings_page_store.dart';
import 'package:bytesized_news/views/settings/settings_store.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  late SettingsStore settingsStore;
  late DbUtils dbUtils;
  NotificationsPageStore notificationsPageStore = NotificationsPageStore();

  @override
  void initState() {
    super.initState();
    settingsStore = context.read<SettingsStore>();
    AuthStore authStore = context.read<AuthStore>();
    notificationsPageStore.init(authStore);

    notificationsPageStore.loadFeeds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: Observer(
        builder: (context) {
          return Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 18),
              constraints: BoxConstraints(
                maxWidth: settingsStore.maxWidth,
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text("Show notification after background synchronization"),
                        subtitle: const Text("Get notified when new articles of certain feeds are fetched after a background sync."),
                        value: settingsStore.showNotificationAfterBgSync,
                        onChanged: (value) {
                          settingsStore.showNotificationAfterBgSync = value;

                          if (Platform.isAndroid) {
                            FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
                            flutterLocalNotificationsPlugin
                                .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
                                ?.requestNotificationsPermission();
                          }
                        },
                      ),

                      Text(
                        "Feeds",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.primary),
                      ),

                      if (notificationsPageStore.loading) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: LinearProgressIndicator(
                            year2023: false,
                          ),
                        ),
                      ],

                      if (!notificationsPageStore.loading) ...[
                        ...notificationsPageStore.feeds.map((Feed feed) {
                          return SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: CachedNetworkImage(
                                    imageUrl: feed.iconUrl,
                                    height: 30,
                                    width: 30,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    feed.name,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                            value: feed.notifyAfterBgSync,
                            onChanged: (value) => notificationsPageStore.handleItemChange(feed, value),
                          );
                        }),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
