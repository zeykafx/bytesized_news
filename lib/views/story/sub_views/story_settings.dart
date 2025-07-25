import 'dart:async';
import 'package:bytesized_news/views/settings/settings.dart';
import 'package:bytesized_news/views/settings/settings_store.dart';
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
  Timer? timer;

  static const double textWidth = 35;

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
                              SizedBox(
                                width: textWidth,
                                child: Text(
                                  storyStore.settingsStore.fontSize.toString(),
                                ),
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

                      // Text aligment
                      ListTile(
                        title: Text("Text Alignment"),
                        trailing: DropdownButton(
                            items: TextAlign.values.map((alignment) {
                              return DropdownMenuItem<String>(
                                value: textAlignString(alignment),
                                child: Text(textAlignString(alignment)),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              storyStore.settingsStore.textAlignment = TextAlign.values[textAlignmentValues.indexOf(value!)];

                              storyStore.htmlWidgetKey =
                                  UniqueKey(); // Force update the key of the html widget to force the widget to call the buildstyles function again
                            },
                            value: textAlignString(storyStore.settingsStore.textAlignment)),
                      ),

                      // font weight
                      ListTile(
                        title: Text("Font Weight (Boldness)"),
                        trailing: DropdownButton(
                            items: TextWidth.values.map((width) {
                              return DropdownMenuItem<String>(
                                value: textWidthToString(width),
                                child: Text(textWidthToString(width)),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              storyStore.settingsStore.textWidth = TextWidth.values[textWidthValues.indexOf(value!)];
                            },
                            value: textWidthToString(storyStore.settingsStore.textWidth)),
                      ),

                      // Line height
                      ListTile(
                        title: const Text("Line Height"),
                        subtitle: SizedBox(
                          width: 150,
                          child: Row(
                            children: [
                              SizedBox(
                                width: textWidth,
                                child: Text(
                                  storyStore.settingsStore.lineHeight.toStringAsFixed(2),
                                ),
                              ),
                              Expanded(
                                child: Slider(
                                  year2023: false, // todo: to fix (somehow)
                                  label: storyStore.settingsStore.lineHeight.toStringAsFixed(2),
                                  value: storyStore.settingsStore.lineHeight,
                                  min: 0,
                                  max: 2,
                                  divisions: 40,
                                  onChanged: (newVal) {
                                    storyStore.settingsStore.lineHeight = newVal;

                                    // debounce the key update (to avoid excessive rebuilds while the user moves the slider)
                                    timer?.cancel();
                                    timer = Timer.periodic(Duration(seconds: 1), (tmr) {
                                      storyStore.htmlWidgetKey =
                                          UniqueKey(); // Force update the key of the html widget to force the widget to call the buildstyles function again

                                      timer?.cancel();
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Viewer Horizontal padding
                      ListTile(
                        title: const Text("Horizontal padding"),
                        subtitle: SizedBox(
                          width: 150,
                          child: Row(
                            children: [
                              SizedBox(
                                width: textWidth,
                                child: Text(
                                  storyStore.settingsStore.horizontalPadding.toStringAsFixed(0),
                                ),
                              ),
                              Expanded(
                                child: Slider(
                                  year2023: false, // todo: to fix (somehow)
                                  label: storyStore.settingsStore.horizontalPadding.toStringAsFixed(0),
                                  value: storyStore.settingsStore.horizontalPadding,
                                  min: 0.0,
                                  max: 20.0,
                                  divisions: 40,
                                  onChanged: (newVal) {
                                    storyStore.settingsStore.horizontalPadding = newVal;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Viewer Max Width
                      ListTile(
                        title: const Text("Max width"),
                        subtitle: SizedBox(
                          width: 150,
                          child: Row(
                            children: [
                              SizedBox(
                                width: textWidth,
                                child: Text(
                                  storyStore.settingsStore.storyReaderMaxWidth.toStringAsFixed(0),
                                ),
                              ),
                              Expanded(
                                child: Slider(
                                  year2023: false, // todo: to fix (somehow)
                                  label: storyStore.settingsStore.storyReaderMaxWidth.toStringAsFixed(0),
                                  value: storyStore.settingsStore.storyReaderMaxWidth,
                                  min: 200.0,
                                  max: 1200.0,
                                  divisions: 20,
                                  onChanged: (newVal) {
                                    storyStore.settingsStore.storyReaderMaxWidth = newVal;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Font
                      ListTile(
                        title: Text("Font"),
                        trailing: DropdownButton(
                            items: FontFamily.values.map((font) {
                              return DropdownMenuItem<String>(
                                value: fontFamilyToString(font),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(fontFamilyToString(font),
                                        style: TextStyle(fontWeight: storyStore.settingsStore.fontFamily == font ? FontWeight.w600 : FontWeight.normal)),
                                    Text(fontFamilyToExplanation(font), style: TextStyle(color: Theme.of(context).dividerColor, fontSize: 12)),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              storyStore.settingsStore.fontFamily = FontFamily.values[fontFamilyValues.indexOf(value!)];

                              storyStore.htmlWidgetKey =
                                  UniqueKey(); // Force update the key of the html widget to force the widget to call the buildstyles function again
                            },
                            value: fontFamilyToString(storyStore.settingsStore.fontFamily)),
                      ),

                      // Other reader mode settings here
                    ],
                  ),
                  SettingsSection(
                    title: "AI Summary Settings",
                    children: [
                      // SHOW AI SUMMARY ON STORY PAGE LOAD
                      ListTile(
                        title: const Text(
                          "Show AI Summary on Page Load",
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
                          "Fetch AI Summary on Page Load",
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
