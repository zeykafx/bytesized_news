import 'dart:math';

import 'package:bytesized_news/views/auth/auth_store.dart';
import 'package:bytesized_news/views/settings/settings_store.dart';
import 'package:bytesized_news/views/settings/shared/settings_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class AppearanceSettingsSection extends StatefulWidget {
  const AppearanceSettingsSection({super.key});

  @override
  State<AppearanceSettingsSection> createState() => _AppearanceSettingsSectionState();
}

class _AppearanceSettingsSectionState extends State<AppearanceSettingsSection> with TickerProviderStateMixin {
  late final SettingsStore settingsStore;
  late final AuthStore authStore;
  late TabController tabController;
  late PageController pageController;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    settingsStore = context.read<SettingsStore>();
    authStore = context.read<AuthStore>();
    tabController = TabController(length: (colorSeeds.length + 3) ~/ 4, vsync: this);
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
    tabController.dispose();
  }

  void handlePageViewChanged(int currentPageIndex) {
    tabController.index = currentPageIndex;
    setState(() {
      currentIndex = currentPageIndex;
    });
  }

  void updateCurrentPageIndex(int index) {
    tabController.index = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return SettingsSection(
          title: "Look & Feel",
          onlySection: true,
          children: [
            // Font
            ListTile(
              title: Text("App Font"),
              trailing: DropdownButton(
                items: FontFamily.values.map((font) {
                  return DropdownMenuItem<String>(
                    value: fontFamilyToString(font),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fontFamilyToString(font),
                          style: TextStyle(fontWeight: settingsStore.appFontFamily == font ? FontWeight.w600 : FontWeight.normal),
                        ),
                        Text(fontFamilyToExplanation(font), style: TextStyle(color: Theme.of(context).dividerColor, fontSize: 12)),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (String? value) {
                  settingsStore.appFontFamily = FontFamily.values[fontFamilyValues.indexOf(value!)];

                },
                value: fontFamilyToString(settingsStore.appFontFamily),
              ),
            ),
            
            // DARK MODE
            ListTile(
              title: const Text("Dark Mode"),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: SegmentedButton(
                  style: const ButtonStyle(visualDensity: VisualDensity.compact),
                  segments: darkModeNames
                      .map(
                        (option) => ButtonSegment(
                          value: option,
                          label: Text(option, overflow: TextOverflow.ellipsis),
                        ),
                      )
                      .toList(),
                  selected: {darkModeNames[settingsStore.darkMode.index]},
                  onSelectionChanged: (selection) async {
                    settingsStore.setDarkMode(DarkMode.values[darkModeNames.indexOf(selection.first)]);
                  },
                ),
              ),
            ),

            SwitchListTile(
              title: const Text("Use dynamic color"),
              subtitle: Text("App's theme based on your wallpaper"),
              value: settingsStore.useDynamicColor,
              onChanged: (value) {
                settingsStore.useDynamicColor = value;
              },
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 5,
              children: [
                Center(
                  child: SizedBox(
                    height: 80,
                    child: PageView(
                      controller: pageController,
                      onPageChanged: handlePageViewChanged,
                      children: [
                        for (int i = 0; i < (colorSeeds.length + 3) ~/ 4; i++) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 5,
                            children: [
                              for (Color color in colorSeeds.getRange(i * 4, min((i + 1) * 4, colorSeeds.length))) ...[
                                ColorButton(
                                  color: color,
                                  colorScheme: ColorScheme.fromSeed(seedColor: color),
                                  settingsStore: settingsStore,
                                ),
                              ],
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                TabPageSelector(
                  controller: tabController,
                  color: Theme.of(context).colorScheme.primaryContainer,
                  selectedColor: Theme.of(context).colorScheme.primary,
                  borderStyle: BorderStyle.none,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class ColorButton extends StatelessWidget {
  const ColorButton({
    super.key,
    required this.color,
    required this.colorScheme,
    required this.settingsStore,
  });

  final Color color;
  final ColorScheme colorScheme;
  final SettingsStore settingsStore;

  @override
  Widget build(BuildContext context) {
    int colorIndex = colorSeeds.indexOf(color);

    BorderRadius borderRadius = BorderRadius.circular(16);

    return Material(
      color: Theme.of(context).colorScheme.surfaceContainer,
      // color: Colors.transparent,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: () {
          settingsStore.colorSeedIndex = colorIndex;
          settingsStore.useDynamicColor = false;
        },
        borderRadius: borderRadius,
        child: Padding(
          padding: EdgeInsets.all(14),
          child: ClipOval(
            child: SizedBox(
              width: 48,
              height: 48,
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 0,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          color: colorScheme.primary, // primary color
                          width: 48,
                          height: 24,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 0,
                        children: [
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              color: colorScheme.primaryFixedDim, // secondary
                              width: 24,
                              height: 24,
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              color: colorScheme.tertiaryFixedDim, // tertiary
                              width: 24,
                              height: 24,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Observer(
                    builder: (context) {
                      if (colorIndex == settingsStore.colorSeedIndex && !settingsStore.useDynamicColor) {
                        return Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surfaceContainer,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(Icons.check_rounded),
                          ),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate(delay: 100.ms).fadeIn(duration: 300.ms, curve: Curves.easeInOutQuad);
  }
}
