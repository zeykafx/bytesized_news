import 'package:bytesized_news/views/settings/setting_pages/reader/ai_section.dart';
import 'package:bytesized_news/views/settings/setting_pages/reader/reader_font_section.dart';
import 'package:bytesized_news/views/settings/setting_pages/reader/reader_mode_section.dart';
import 'package:bytesized_news/views/settings/shared/settings_page.dart';
import 'package:flutter/material.dart';

class ReaderSettingsPage extends StatelessWidget {
  const ReaderSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SettingsPage(
        title: "Reader",
        isMainView: false,
        sections: [
          const ReaderModeSection(),
          const AiSection(),
          const ReaderFontSection(),
        ],
      ),
    );
  }
}
