import 'dart:ui';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

class CrashlyticsService {
  void initialize() {
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  void log(String message) {
    FirebaseCrashlytics.instance.log(message);
  }

  Future<void> recordError(dynamic exception, StackTrace? stackTrace, {bool fatal = false}) async {
    await FirebaseCrashlytics.instance.recordError(exception, stackTrace, fatal: fatal);
  }

  Future<void> setCrashlyticsCollectionEnabled(bool enabled) async {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(enabled);
  }
}
