import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Note: code from: https://stackoverflow.com/questions/51835039/how-do-i-check-if-the-flutter-application-is-in-the-foreground-or-not

final lifecycleEventHandler = LifecycleEventHandler();

class LifecycleEventHandler extends WidgetsBindingObserver {
  var inBackground = false;

  // callback system for components that need lifecycle notifications
  final List<VoidCallback> backgroundCallbacks = [];
  final List<VoidCallback> foregroundCallbacks = [];

  LifecycleEventHandler();

  void init() {
    WidgetsBinding.instance.addObserver(lifecycleEventHandler);
  }

  // register callbacks for background events
  void addBackgroundCallback(VoidCallback callback) {
    if (!backgroundCallbacks.contains(callback)) {
      backgroundCallbacks.add(callback);
    }
  }

  // register callbacks for foreground events
  void addForegroundCallback(VoidCallback callback) {
    if (!foregroundCallbacks.contains(callback)) {
      foregroundCallbacks.add(callback);
    }
  }

  void removeBackgroundCallback(VoidCallback callback) {
    backgroundCallbacks.remove(callback);
  }

  void removeForegroundCallback(VoidCallback callback) {
    foregroundCallbacks.remove(callback);
  }

  void clearAllCallbacks() {
    backgroundCallbacks.clear();
    foregroundCallbacks.clear();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        if (inBackground) {
          inBackground = false;
          if (kDebugMode) {
            print('App resumed - in foreground');
          }

          // notify all foreground callbacks
          for (final callback in foregroundCallbacks) {
            try {
              callback();
            } catch (e) {
              if (kDebugMode) {
                print('Error in foreground callback: $e');
              }
            }
          }
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        if (!inBackground) {
          inBackground = true;
          if (kDebugMode) {
            print('App paused - in background');
          }

          // notify all bg callbacks
          for (final callback in backgroundCallbacks) {
            try {
              callback();
            } catch (e) {
              if (kDebugMode) {
                print('Error in background callback: $e');
              }
            }
          }
        }
        break;
    }
  }

  void dispose() {
    clearAllCallbacks();
    WidgetsBinding.instance.removeObserver(this);
    // super.dispose();
  }
}
