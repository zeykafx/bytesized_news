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
                  SettingsSection(
                    title: "Story Reader Settings",
                    children: [
                      // USE READER MODE BY DEFAULT
                      ListTile(
                        title: const Text(
                          "Use Reader Mode by Default",
                        ),
                        onTap: () {
                          storyStore.settingsStore.setUseReaderModeByDefault(!storyStore.settingsStore.useReaderModeByDefault);
                        },
                        trailing: Switch(
                          value: storyStore.settingsStore.useReaderModeByDefault,
                          onChanged: (value) {
                            storyStore.settingsStore.setUseReaderModeByDefault(value);
                          },
                        ),
                      ),

                      // Viewer font size
                      ListTile(
                        title: const Text("Reader Mode Font Size"),
                        subtitle: SizedBox(
                          width: 150,
                          child: Row(
                            children: [
                              Text(
                                storyStore.settingsStore.fontSize.toString(),
                              ),
                              Expanded(
                                child: Slider(
                                  year2023: false, // todo: to fix (somehow)
                                  label: storyStore.settingsStore.fontSize.toString(),
                                  value: storyStore.settingsStore.fontSize ?? 16.0,
                                  min: 10.0,
                                  max: 30.0,
                                  divisions: 40,
                                  onChanged: (newVal) {
                                    storyStore.settingsStore.setFontSize(newVal);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SettingsSection(
                    title: "AI Summary Settings",
                    children: [
                      // SHOW AI SUMMARY ON STORY PAGE LOAD
                      ListTile(
                        title: const Text(
                          "Show AI Summary on Page Load (Premium)",
                        ),
                        onTap: () {
                          storyStore.settingsStore.setShowAiSummaryOnLoad(!storyStore.settingsStore.showAiSummaryOnLoad);
                        },
                        trailing: Switch(
                          value: storyStore.settingsStore.showAiSummaryOnLoad,
                          onChanged: (value) {
                            storyStore.settingsStore.setShowAiSummaryOnLoad(value);
                          },
                        ),
                      ),

                      // FETCH AI SUMMARY ON STORY PAGE LOAD
                      ListTile(
                        title: const Text(
                          "Fetch AI Summary on Page Load (Premium)",
                        ),
                        onTap: () {
                          storyStore.settingsStore.setFetchAiSummaryOnLoad(!storyStore.settingsStore.fetchAiSummaryOnLoad);
                        },
                        trailing: Switch(
                          value: storyStore.settingsStore.fetchAiSummaryOnLoad,
                          onChanged: (value) {
                            storyStore.settingsStore.setFetchAiSummaryOnLoad(value);
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
