import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:bytesized_news/models/feed/feed.dart';
import 'package:bytesized_news/models/feedGroup/feedGroup.dart';
import 'package:bytesized_news/views/auth/auth.dart';
import 'package:bytesized_news/views/auth/auth_store.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:bytesized_news/models/feedItem/feedItem.dart';
import 'package:bytesized_news/views/feed_view/feed_view.dart';
import 'package:bytesized_news/views/settings/settings_store.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:isar/isar.dart';
import 'firebase_options.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Animate.restartOnHotReload;

  await dotenv.load(fileName: ".env");

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
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
  ]);

  if (!Platform.isWindows) {
    // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    //
    // // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    // PlatformDispatcher.instance.onError = (error, stack) {
    //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    //   return true;
    // };
  }

  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [FeedItemSchema, FeedSchema, FeedGroupSchema],
    directory: dir.path,
  );

  final AuthStore authStore = AuthStore();
  await authStore.init();

  if (settingsStore.sortFeedName != null) {
    settingsStore.sortFeed = await isar.feeds.where().filter().nameEqualTo(settingsStore.sortFeedName!).findFirst();

    if (settingsStore.sortFeed == null) {
      settingsStore.sortFeedName = null;
      settingsStore.sortFeed = null;
      settingsStore.sort = FeedListSort.byDate;
    }
  }

  if (settingsStore.sortFeedGroupName != null) {
    settingsStore.sortFeedGroup = await isar.feedGroups.where().filter().nameEqualTo(settingsStore.sortFeedGroupName!).findFirst();
    if (settingsStore.sortFeedGroup == null) {
      settingsStore.sortFeedGroupName = null;
      settingsStore.sortFeedGroup = null;
      settingsStore.sort = FeedListSort.byDate;
    } else {
      List<Feed> feeds = await isar.feeds.where().findAll();

      for (String feedName in settingsStore.sortFeedGroup!.feedNames) {
        if (feeds.any((feed) => feed.name != feedName)) {
          continue;
        }
        Feed feed = feeds.firstWhere((feed) => feed.name == feedName);

        settingsStore.sortFeedGroup!.feeds.add(feed);
      }
    }
  }

  runApp(
    MultiProvider(
      providers: [
        Provider<SettingsStore>(create: (_) => settingsStore),
        Provider<AuthStore>(create: (_) => authStore),
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

  FirebaseAuth auth = FirebaseAuth.instance;

  User? user;

  @override
  void initState() {
    super.initState();
    settingsStore = context.read<SettingsStore>();
    user = auth.currentUser;
  }

  ThemeData lightTheme(ColorScheme? lightColorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,
      colorSchemeSeed: lightColorScheme == null ? Colors.red : null,
      brightness: Brightness.light,
    );
  }

  ThemeData darkTheme(ColorScheme? darkColorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme,
      colorSchemeSeed: darkColorScheme == null ? Colors.red : null,
      brightness: Brightness.dark,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (light, dark) {
        return Observer(
          builder: (context) {
            return MaterialApp(
              title: 'ByteSized News',
              theme: lightTheme(light),
              darkTheme: darkTheme(dark),
              themeMode: settingsStore.darkMode == DarkMode.system
                  ? ThemeMode.system
                  : settingsStore.darkMode == DarkMode.dark
                      ? ThemeMode.dark
                      : ThemeMode.light,
              home: user == null ? const Auth() : const FeedView(),
            );
          },
        );
      },
    );
  }
}
