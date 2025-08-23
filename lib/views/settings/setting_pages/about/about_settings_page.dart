import 'package:bytesized_news/views/settings/setting_pages/about/about_section.dart';
import 'package:bytesized_news/views/settings/shared/settings_page.dart';
import 'package:flutter/material.dart';

class AboutSettingsPage extends StatelessWidget {
  const AboutSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SettingsPage(
        title: "About",
        isMainView: false,
        sections: [
          const AboutSection(),
        ],
      ),
    );
  }
}
