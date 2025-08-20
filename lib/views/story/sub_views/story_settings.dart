import 'dart:async';
import 'package:bytesized_news/views/auth/auth_store.dart';
import 'package:bytesized_news/views/settings/sections/settings_section.dart';
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
  late SettingsStore settingsStore;
  late AuthStore authStore;
  Timer? timer;

  static const double textWidth = 35;

  @override
  void initState() {
    super.initState();
    storyStore = widget.storyStore;
    settingsStore = storyStore.settingsStore;
    authStore = storyStore.authStore;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Story Settings')),
      body: Observer(
        builder: (context) {
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
                          title: const Text("Use Reader Mode by Default"),
                          onTap: () {
                            settingsStore.setUseReaderModeByDefault(!settingsStore.useReaderModeByDefault);
                          },
                          trailing: Switch(
                            value: settingsStore.useReaderModeByDefault,
                            onChanged: (value) {
                              settingsStore.setUseReaderModeByDefault(value);
                            },
                          ),
                        ),

                        // Switch to webview if reader mode is too short
                        SwitchListTile(
                          title: const Text("Auto switch to webview if reader article is too short"),
                          value: settingsStore.autoSwitchReaderTooShort,
                          onChanged: (value) {
                            settingsStore.autoSwitchReaderTooShort = value;
                          },
                        ),

                        // Always show the archive button
                        SwitchListTile(
                          title: const Text("Always show 'Fetch Archived link' button in bar"),
                          value: settingsStore.alwaysShowArchiveButton,
                          onChanged: (value) {
                            settingsStore.alwaysShowArchiveButton = value;
                          },
                        ),
                      ],
                    ),

                    SettingsSection(
                      title: "Summary Settings",
                      children: [
                        // SHOW AI SUMMARY ON STORY PAGE LOAD
                        SwitchListTile(
                          title: const Text("Show Summary on page load"),
                          value: authStore.userTier == Tier.premium ? settingsStore.showAiSummaryOnLoad : false,
                          onChanged: authStore.userTier == Tier.premium
                              ? (value) {
                                  settingsStore.setShowAiSummaryOnLoad(value);
                                }
                              : null,
                          // thumbIcon: WidgetStateProperty.resolveWith<Icon?>((Set<WidgetState> states) {
                          //   if (states.contains(WidgetState.selected)) {
                          //     return Icon(
                          //       Icons.check,
                          //       color:  Theme.of(context).colorScheme.onSurface,
                          //     );
                          //   }
                          //   // All other states will use the default thumbIcon.
                          //   return Icon(Icons.close, color: Theme.of(context).colorScheme.onPrimary);
                          // }),
                        ),

                        // FETCH AI SUMMARY ON STORY PAGE LOAD
                        SwitchListTile(
                          title: const Text("Generate Summary on page load"),
                          value: authStore.userTier == Tier.premium ? settingsStore.fetchAiSummaryOnLoad : false,
                          onChanged: authStore.userTier == Tier.premium
                              ? (value) {
                                  settingsStore.setFetchAiSummaryOnLoad(value);
                                }
                              : null,
                        ),
                      ],
                    ),

                    SettingsSection(
                      title: "Reader Font Settings",
                      children: [
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
                                    Text(
                                      fontFamilyToString(font),
                                      style: TextStyle(fontWeight: settingsStore.fontFamily == font ? FontWeight.w600 : FontWeight.normal),
                                    ),
                                    Text(fontFamilyToExplanation(font), style: TextStyle(color: Theme.of(context).dividerColor, fontSize: 12)),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              settingsStore.fontFamily = FontFamily.values[fontFamilyValues.indexOf(value!)];

                              storyStore.htmlWidgetKey =
                                  UniqueKey(); // Force update the key of the html widget to force the widget to call the buildstyles function again
                            },
                            value: fontFamilyToString(settingsStore.fontFamily),
                          ),
                        ),

                        // Text aligment
                        ListTile(
                          title: Text("Text Alignment"),
                          trailing: DropdownButton(
                            items: TextAlign.values.map((alignment) {
                              return DropdownMenuItem<String>(value: textAlignString(alignment), child: Text(textAlignString(alignment)));
                            }).toList(),
                            onChanged: (String? value) {
                              settingsStore.textAlignment = TextAlign.values[textAlignmentValues.indexOf(value!)];

                              storyStore.htmlWidgetKey =
                                  UniqueKey(); // Force update the key of the html widget to force the widget to call the buildstyles function again
                            },
                            value: textAlignString(settingsStore.textAlignment),
                          ),
                        ),

                        // font weight
                        ListTile(
                          title: Text("Font Weight (Boldness)"),
                          trailing: DropdownButton(
                            items: TextWidth.values.map((width) {
                              return DropdownMenuItem<String>(value: textWidthToString(width), child: Text(textWidthToString(width)));
                            }).toList(),
                            onChanged: (String? value) {
                              settingsStore.textWidth = TextWidth.values[textWidthValues.indexOf(value!)];
                            },
                            value: textWidthToString(settingsStore.textWidth),
                          ),
                        ),

                        // Viewer font size
                        ListTile(
                          title: const Text("Reader Mode Font Size"),
                          subtitle: SizedBox(
                            width: 150,
                            child: Row(
                              children: [
                                SizedBox(width: textWidth, child: Text(settingsStore.fontSize.toString())),
                                Expanded(
                                  child: Slider(
                                    year2023: false, // todo: to fix (somehow)
                                    label: settingsStore.fontSize.toString(),
                                    value: settingsStore.fontSize ?? 16.0,
                                    min: 10.0,
                                    max: 30.0,
                                    divisions: 40,
                                    onChanged: (newVal) {
                                      settingsStore.setFontSize(newVal);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Line height
                        ListTile(
                          title: const Text("Line Height"),
                          subtitle: SizedBox(
                            width: 150,
                            child: Row(
                              children: [
                                SizedBox(width: textWidth, child: Text(settingsStore.lineHeight.toStringAsFixed(2))),
                                Expanded(
                                  child: Slider(
                                    year2023: false, // todo: to fix (somehow)
                                    label: settingsStore.lineHeight.toStringAsFixed(2),
                                    value: settingsStore.lineHeight,
                                    min: 0,
                                    max: 2,
                                    divisions: 40,
                                    onChanged: (newVal) {
                                      settingsStore.lineHeight = newVal;

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
                                SizedBox(width: textWidth, child: Text(settingsStore.horizontalPadding.toStringAsFixed(0))),
                                Expanded(
                                  child: Slider(
                                    year2023: false, // todo: to fix (somehow)
                                    label: settingsStore.horizontalPadding.toStringAsFixed(0),
                                    value: settingsStore.horizontalPadding,
                                    min: 0.0,
                                    max: 20.0,
                                    divisions: 40,
                                    onChanged: (newVal) {
                                      settingsStore.horizontalPadding = newVal;
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
                                SizedBox(width: textWidth, child: Text(settingsStore.storyReaderMaxWidth.toStringAsFixed(0))),
                                Expanded(
                                  child: Slider(
                                    year2023: false, // todo: to fix (somehow)
                                    label: settingsStore.storyReaderMaxWidth.toStringAsFixed(0),
                                    value: settingsStore.storyReaderMaxWidth,
                                    min: 200.0,
                                    max: 1200.0,
                                    divisions: 20,
                                    onChanged: (newVal) {
                                      settingsStore.storyReaderMaxWidth = newVal;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Other reader mode settings here
                      ],
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
