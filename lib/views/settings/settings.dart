import 'package:bytesized_news/views/settings/setting_pages/about/about_settings_page.dart';
import 'package:bytesized_news/views/settings/setting_pages/appearance/appearance_settings_page.dart';
import 'package:bytesized_news/views/settings/setting_pages/general/general_settings_page.dart';
import 'package:bytesized_news/views/settings/setting_pages/reader/reader_settings_page.dart';
import 'package:bytesized_news/views/settings/shared/settings_page.dart';
import 'package:bytesized_news/views/settings/shared/top_lvl_settings_section.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SettingsPage(
        title: "Settings",
        isMainView: true,
        sections: [
          TopLvlSettingsSection(
            iconData: Icons.settings_applications_rounded,
            title: "General",
            subtitle: "Feed settings, background sync, import/export feeds",
            settingsPage: GeneralSettingsPage(),
          ),
          TopLvlSettingsSection(
            iconData: Icons.chrome_reader_mode_rounded,
            title: "Reader",
            subtitle: "Reader options, artificial intelligence, custom providers",
            settingsPage: ReaderSettingsPage(),
          ),
          TopLvlSettingsSection(
            iconData: Icons.palette_rounded,
            title: "Appearance",
            subtitle: "Dark theme, dynamic color",
            settingsPage: AppearanceSettingsPage(),
          ),
          TopLvlSettingsSection(
            iconData: Icons.info_rounded,
            title: "About",
            subtitle: "Version, source code",
            settingsPage: AboutSettingsPage(),
          ),
        ],
      ),
    );
  }
}
