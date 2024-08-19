import 'package:bytesized_news/views/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../story_store.dart';

class StorySettings extends StatefulWidget {
  final StoryStore storyStore;

  const StorySettings({super.key, required this.storyStore});

  @override
  State<StorySettings> createState() => _StorySettingsState();
}

class _StorySettingsState extends State<StorySettings> {
  late StoryStore storyStore;

  @override
  void initState() {
    super.initState();
    storyStore = widget.storyStore;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Story Settings'),
      ),
      body: Observer(builder: (context) {
        return SingleChildScrollView(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SettingsSection(title: "Story View Settings", children: [
                    // USE READER MODE BY DEFAULT
                    ListTile(
                      title: const Text(
                        "Use Reader Mode by Default",
                      ),
                      trailing: Switch(
                        value: storyStore.settingsStore.useReaderModeByDefault,
                        onChanged: (value) {
                          storyStore.settingsStore.setUseReaderModeByDefault(value);
                        },
                      ),
                    ),

                    // SHOW AI SUMMARY ON WEB PAGE LOAD
                    ListTile(
                      title: const Text(
                        "Show AI Summary on Web Page Load",
                      ),
                      trailing: Switch(
                        value: storyStore.settingsStore.showAiSummaryOnLoad,
                        onChanged: (value) {
                          storyStore.settingsStore.setShowAiSummaryOnLoad(value);
                        },
                      ),
                    ),
                  ])
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
