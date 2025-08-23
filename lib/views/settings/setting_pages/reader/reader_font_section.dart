import 'dart:async';

import 'package:bytesized_news/views/auth/auth_store.dart';
import 'package:bytesized_news/views/settings/settings_store.dart';
import 'package:bytesized_news/views/settings/shared/settings_section.dart';
import 'package:bytesized_news/views/story/story_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class ReaderFontSection extends StatefulWidget {
  const ReaderFontSection({super.key, this.storyStore});
  final StoryStore? storyStore;

  @override
  State<ReaderFontSection> createState() => _ReaderModeSectionState();
}

class _ReaderModeSectionState extends State<ReaderFontSection> {
  late final SettingsStore settingsStore;
  late final AuthStore authStore;
  late StoryStore? storyStore;
  Timer? timer;

  static const double textWidth = 35;

  @override
  void initState() {
    super.initState();
    storyStore = widget.storyStore;
    settingsStore = context.read<SettingsStore>();
    authStore = context.read<AuthStore>();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return SettingsSection(
          title: "Reader Font Settings",
          onlySection: false,
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

                  if (storyStore != null) {
                    storyStore!.htmlWidgetKey =
                        UniqueKey(); // Force update the key of the html widget to force the widget to call the buildstyles function again
                  }
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

                  if (storyStore != null) {
                    storyStore!.htmlWidgetKey =
                        UniqueKey(); // Force update the key of the html widget to force the widget to call the buildstyles function again
                  }
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
                        year2023: false,
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
                        year2023: false,
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
                            if (storyStore != null) {
                              storyStore!.htmlWidgetKey =
                                  UniqueKey(); // Force update the key of the html widget to force the widget to call the buildstyles function again
                            }

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
                        year2023: false,
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
                        year2023: false,
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
          ],
        );
      },
    );
  }
}
