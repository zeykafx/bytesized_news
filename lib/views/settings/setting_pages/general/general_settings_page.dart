import 'package:bytesized_news/views/settings/setting_pages/general/background_sync_section.dart';
import 'package:bytesized_news/views/settings/setting_pages/general/cache_settings_section.dart';
import 'package:bytesized_news/views/settings/setting_pages/general/general_settings_section.dart';
import 'package:bytesized_news/views/settings/setting_pages/general/import_export_section.dart';
import 'package:bytesized_news/views/settings/shared/settings_page.dart';
import 'package:flutter/material.dart';

class GeneralSettingsPage extends StatelessWidget {
  const GeneralSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SettingsPage(
        title: "General",
        isMainView: false,
        sections: [
          const GeneralSettingsSection(),
          // if (!Platform.isIOS) ...[
          const BackgroundSyncSection(),
          // ],
          const ImportExportSection(),
          CacheSettingsSection(),
        ],
      ),
    );
  }
}
