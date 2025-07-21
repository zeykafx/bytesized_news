import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Note: code from: https://stackoverflow.com/questions/51835039/how-do-i-check-if-the-flutter-application-is-in-the-foreground-or-not

final lifecycleEventHandler = LifecycleEventHandler();

class LifecycleEventHandler extends WidgetsBindingObserver {
  var inBackground = true;

  LifecycleEventHandler();

  void init() {
    WidgetsBinding.instance.addObserver(lifecycleEventHandler);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        inBackground = false;
        if (kDebugMode) {
          print('in foreground');
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        inBackground = true;
        if (kDebugMode) {
          print('in background');
        }
        break;
    }
  }
}
