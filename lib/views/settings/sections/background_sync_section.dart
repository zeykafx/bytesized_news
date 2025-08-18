import 'package:bytesized_news/main.dart' show taskName;
import 'package:bytesized_news/views/settings/sections/settings_section.dart';
import 'package:bytesized_news/views/settings/settings_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

class BackgroundSyncSection extends StatefulWidget {
  const BackgroundSyncSection({super.key});

  @override
  State<BackgroundSyncSection> createState() => _BackgroundSyncSectionState();
}

class _BackgroundSyncSectionState extends State<BackgroundSyncSection> {
  late final SettingsStore settingsStore;

  @override
  void initState() {
    super.initState();
    settingsStore = context.read<SettingsStore>();
  }

  Future<void> updateBackgroundTask() async {
    await Workmanager().cancelAll();
    // await Workmanager().cancelByUniqueName(taskName);

    await Workmanager().registerPeriodicTask(
      taskName,
      taskName,
      frequency: settingsStore.backgroundFetchInterval.value,
      // initialDelay: Duration(minutes: 30),
      constraints: Constraints(
        // Connected or metered mark the task as requiring internet
        networkType: NetworkType.connected,
        requiresDeviceIdle: settingsStore.requireDeviceIdleForBgFetch,
        requiresBatteryNotLow: settingsStore.skipBgSyncOnLowBattery,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return SettingsSection(
          title: "Background Sync",
          children: [
            // background sync interval
            ListTile(
              title: Text("Background sync interval"),
              trailing: DropdownButton(
                items: BackgroundFetchInterval.values.map((bgSyncInt) {
                  return DropdownMenuItem<String>(value: backgroundFetchIntervalString(bgSyncInt), child: Text(backgroundFetchIntervalString(bgSyncInt)));
                }).toList(),
                onChanged: (String? value) {
                  settingsStore.backgroundFetchInterval = BackgroundFetchInterval.values[backgroundFetchIntervalValues.indexOf(value!)];
                  updateBackgroundTask();
                },
                value: backgroundFetchIntervalString(settingsStore.backgroundFetchInterval),
              ),
            ),

            // Skip Background sync when low on battery (toggle)
            SwitchListTile(
              title: const Text("Skip sync when low on battery"),
              value: settingsStore.skipBgSyncOnLowBattery,
              onChanged: (value) {
                settingsStore.skipBgSyncOnLowBattery = value;
                updateBackgroundTask();
              },
            ),

            // Require device to be idle for bg sync (toggle)
            SwitchListTile(
              title: const Text("Require device to be idle for background sync"),
              value: settingsStore.requireDeviceIdleForBgFetch,
              onChanged: (value) {
                settingsStore.requireDeviceIdleForBgFetch = value;
                updateBackgroundTask();
              },
            ),
          ],
        );
      },
    );
  }
}
