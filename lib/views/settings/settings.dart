import 'package:bytesized_news/views/settings/sections/about_section.dart';
import 'package:bytesized_news/views/settings/sections/background_sync_section.dart';
import 'package:bytesized_news/views/settings/sections/general_settings.dart';
import 'package:bytesized_news/views/settings/sections/import_export_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:bytesized_news/views/settings/settings_store.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late final SettingsStore settingsStore;

  @override
  void initState() {
    super.initState();
    settingsStore = context.read<SettingsStore>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Observer(
        builder: (context) {
          return SingleChildScrollView(
            child: Center(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Visibility(visible: settingsStore.loading, child: const CircularProgressIndicator()),
                  ),
                  Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const GeneralSettings(),
                            // if (!Platform.isIOS) ...[
                            const BackgroundSyncSection(),
                            // ],
                            const ImportExportSection(),
                            const AboutSection(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

