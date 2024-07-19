import 'dart:convert';
import 'dart:ui';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:myapp/views/home/home.dart';
import 'package:myapp/views/settings/settings_store.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // NOTE: this init code is largely from https://github.com/tommyxchow/frosty/blob/main/lib/main.dart
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // With the shared preferences instance, obtain the existing user settings if it exists.
  // If default settings don't exist, use an empty JSON string to use the default values.
  final String settings = prefs.getString("settings") ?? '{}';

  // initialize a settings store from the settings JSON string
  final settingsStore = SettingsStore.fromJson(jsonDecode(settings));

  // mobx reaction that will save the settings on disk every time they are changed
  autorun((_) => prefs.setString("settings", jsonEncode(settingsStore)));

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(
    MultiProvider(
      providers: [
        Provider<SettingsStore>(create: (_) => settingsStore),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final SettingsStore settingsStore;

  @override
  void initState() {
    super.initState();
    settingsStore = context.read<SettingsStore>();
  }

  ColorScheme? lightColorScheme;
  ColorScheme? darkColorScheme;

  ThemeData lightTheme(ColorScheme? lightColorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,
      colorSchemeSeed: lightColorScheme == null ? Colors.orange : null,
      brightness: Brightness.light,
    );
  }

  ThemeData darkTheme(ColorScheme? darkColorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme,
      colorSchemeSeed: darkColorScheme == null ? Colors.orange : null,
      brightness: Brightness.dark,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (light, dark) {
        lightColorScheme = light;
        darkColorScheme = dark;

        return Observer(
          builder: (context) {
            return MaterialApp(
              title: 'ByteSized News',
              theme: lightTheme(lightColorScheme),
              darkTheme: darkTheme(darkColorScheme),
              themeMode: settingsStore.darkMode == DarkMode.system
                  ? ThemeMode.system
                  : settingsStore.darkMode == DarkMode.dark
                      ? ThemeMode.dark
                      : ThemeMode.light,
              home: const Home(),
            );
          },
        );
      },
    );
  }
}
