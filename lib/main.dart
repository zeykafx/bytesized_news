import 'dart:convert';
import 'dart:io';

import 'package:bytesized_news/background/background_fetch.dart';
import 'package:bytesized_news/background/life_cycle_event_handler.dart';
import 'package:bytesized_news/database/db_utils.dart';
import 'package:bytesized_news/models/ai_provider/ai_provider.dart';
import 'package:bytesized_news/models/feed/feed.dart';
import 'package:bytesized_news/models/feedGroup/feedGroup.dart';
import 'package:bytesized_news/models/story_reading/story_reading.dart';
import 'package:bytesized_news/views/auth/auth.dart';
import 'package:bytesized_news/views/auth/auth_store.dart';
import 'package:bytesized_news/views/welcome/welcome.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:bytesized_news/models/feedItem/feedItem.dart';
import 'package:bytesized_news/views/feed_view/feed_view.dart';
import 'package:bytesized_news/views/settings/settings_store.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:isar_community/isar.dart';
import 'package:workmanager/workmanager.dart';
import 'firebase_options.dart';
import 'package:path_provider/path_provider.dart';

final String taskName = "com.zeykafx.bytesized_news.btNewsBgFetch";

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    if (kDebugMode) {
      print("Running background task: $task");
    }
    if (task == taskName) {
      return BackgroundFetch.runBackgroundFetch();
    }
    return Future.value(false);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  lifecycleEventHandler.init();

  Animate.restartOnHotReload;

  Workmanager().initialize(
    callbackDispatcher,
  );

  // NOTE: this init code is largely from https://github.com/tommyxchow/frosty/blob/main/lib/main.dart
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // With the shared preferences instance, obtain the existing user settings if it exists.
  // If default settings don't exist, use an empty JSON string to use the default values.
  final String settings = prefs.getString("settings") ?? '{}';

  // initialize a settings store from the settings JSON string
  final settingsStore = SettingsStore.fromJson(jsonDecode(settings));

  // mobx reaction that will save the settings on disk every time they are changed
  autorun((_) => prefs.setString("settings", jsonEncode(settingsStore)));

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize AppCheck
  await FirebaseAppCheck.instance.activate(
    // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Safety Net provider
    // 3. Play Integrity provider
    androidProvider: AndroidProvider.debug,
    // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Device Check provider
    // 3. App Attest provider
    // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
    appleProvider: AppleProvider.debug,
  );

  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
    GoogleProvider(clientId: "286405169123-14tsnaatjeclvf6i5k9m7nsitm8qq6h1.apps.googleusercontent.com", iOSPreferPlist: true),
  ]);

  if (kReleaseMode) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open([
    FeedItemSchema,
    FeedSchema,
    FeedGroupSchema,
    StoryReadingSchema,
    AiProviderSchema,
  ], directory: dir.path);

  final AuthStore authStore = AuthStore();

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

      for (String feedUrl in settingsStore.sortFeedGroup!.feedUrls) {
        if (!feeds.any((feed) => feed.link == feedUrl)) {
          continue;
        }
        Feed feed = feeds.firstWhere((feed) => feed.link == feedUrl);

        settingsStore.sortFeedGroup!.feeds.add(feed);
      }
    }

    if (settingsStore.backgroundFetchInterval != BackgroundFetchInterval.never && Platform.isAndroid) {
      bool isScheduled = await Workmanager().isScheduledByUniqueName(taskName);
      if (!isScheduled) {
        await Workmanager().registerPeriodicTask(
          taskName,
          taskName,
          // frequency: Duration(hours: 8), // Ignored in IOS, set the duration in seconds in AppDelegate.swift
          frequency: settingsStore.backgroundFetchInterval.value,
          // initialDelay: Duration(minutes: 30),
          constraints: Constraints(
            // Connected or metered mark the task as requiring internet
            networkType: NetworkType.connected,
            requiresDeviceIdle: settingsStore.requireDeviceIdleForBgFetch,
            requiresBatteryNotLow: settingsStore.skipBgSyncOnLowBattery,
          ),
        );
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

    // Seed default AI providers if none exist
    final dbUtils = DbUtils(isar: Isar.getInstance()!);
    dbUtils.performMigrationIfNeeded();

    dbUtils.seedDefaultAiProvidersIfEmpty();
    // init the notification plugin if the user wants to be notified for even just one feed
    initNotifications(dbUtils);
  }

  ThemeData lightTheme(ColorScheme? lightColorScheme) {
    var baseTheme = ThemeData(brightness: Brightness.light);

    if (settingsStore.useDynamicColor) {
      return ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
        colorSchemeSeed: lightColorScheme == null ? Colors.red : null,
        brightness: Brightness.light,
        textTheme: fontFamilyToTextTheme(settingsStore.appFontFamily, baseTheme.textTheme),
      );
    } else {
      return ThemeData(
        useMaterial3: true,
        colorSchemeSeed: colorSeeds[settingsStore.colorSeedIndex],
        brightness: Brightness.light,
        textTheme: fontFamilyToTextTheme(settingsStore.appFontFamily, baseTheme.textTheme),
      );
    }
  }

  ThemeData darkTheme(ColorScheme? darkColorScheme) {
    var baseTheme = ThemeData(brightness: Brightness.dark);

    if (settingsStore.useDynamicColor) {
      return ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
        colorSchemeSeed: darkColorScheme == null ? Colors.red : null,
        brightness: Brightness.dark,
        textTheme: fontFamilyToTextTheme(settingsStore.appFontFamily, baseTheme.textTheme),
      );
    } else {
      return ThemeData(
        useMaterial3: true,
        colorSchemeSeed: colorSeeds[settingsStore.colorSeedIndex],
        brightness: Brightness.dark,
        textTheme: fontFamilyToTextTheme(settingsStore.appFontFamily, baseTheme.textTheme),
      );
    }
  }

  Future<void> initNotifications(DbUtils dbUtils) async {
    List<Feed> feeds = await dbUtils.getFeeds();
    if (feeds.any((feed) => feed.notifyAfterBgSync)) {
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
      const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('icon');
      final DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings();
      final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
        macOS: null,
        linux: null,
        windows: null,
      );
      await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (light, dark) {
        return Observer(
          builder: (context) {
            return MaterialApp(
              title: 'Bytesized News',
              theme: lightTheme(light),
              darkTheme: darkTheme(dark),
              themeMode: settingsStore.darkMode == DarkMode.system
                  ? ThemeMode.system
                  : settingsStore.darkMode == DarkMode.dark
                  ? ThemeMode.dark
                  : ThemeMode.light,
              home: user == null ? const Auth() : (settingsStore.hasShownWelcomeScreen ? const FeedView() : const Welcome()),
            );
          },
        );
      },
    );
  }
}
