import 'package:bytesized_news/database/db_utils.dart';
import 'package:bytesized_news/views/auth/auth_store.dart';
import 'package:bytesized_news/views/auth/sub_views/alert_message.dart';
import 'package:bytesized_news/views/settings/settings_store.dart';
import 'package:bytesized_news/views/settings/shared/settings_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:isar_community/isar.dart';
import 'package:provider/provider.dart';

class CacheSettingsSection extends StatefulWidget {
  const CacheSettingsSection({super.key});

  @override
  State<CacheSettingsSection> createState() => _CacheSettingsSectionState();
}

class _CacheSettingsSectionState extends State<CacheSettingsSection> {
  late final SettingsStore settingsStore;
  late final AuthStore authStore;
  late DbUtils dbUtils;

  @override
  void initState() {
    super.initState();
    settingsStore = context.read<SettingsStore>();
    authStore = context.read<AuthStore>();
    dbUtils = DbUtils(isar: Isar.getInstance()!);
  }

  // from: https://github.com/tommyxchow/frosty/blob/6fb0c75f38e4c04958707df51277df5e80d75db8/lib/screens/settings/other_settings.dart#L29
  Future<void> showConfirmDialogResetSettings(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset all settings'),
        content: const Text('Are you sure you want to reset all settings?'),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              HapticFeedback.heavyImpact();

              settingsStore.resetSettings();

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All settings reset'),
                ),
              );
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return SettingsSection(
          title: "Cache & Settings",
          onlySection: false,
          children: [
            ListTile(
              title: Text("Reset settings"),
              subtitle: const Text("Reset all the settings to their default values (Provider configurations not included)"),

              onTap: () => showConfirmDialogResetSettings(context),
            ),

            // ListTile(title: Text("Clear cache"), onTap: () => showConfirmDialogResetSettings(context)),
            ListTile(
              title: const Text("Delete all downloaded articles & images"),
              subtitle: const Text("This will delete the downloaded articles' text as well as their cached images"),
              onTap: () async {
                await showConfirmDialogClearCache(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showConfirmDialogClearCache(BuildContext context) async {
    int numberOfDownloadedItems = await dbUtils.numberOfItemsDownloaded();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Clear the cache"),
          content: Text("Are you sure you want to delete the downloaded text and images of $numberOfDownloadedItems items from the cache?"),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Okay'),
              onPressed: () async {
                try {
                  int numDeleted = await dbUtils.deleteDownloadedItems();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Successfully deleted $numDeleted items from the cache"), behavior: SnackBarBehavior.floating),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error deleting downloaded items: $e"), behavior: SnackBarBehavior.floating),
                  );
                }

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
