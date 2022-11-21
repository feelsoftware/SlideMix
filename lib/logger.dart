import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart' as logger_impl;

/// Log to Logcat only in debug mode, send logs to Crashlytics only in release mode.
class Logger {
  static final logger_impl.Logger _loggerImpl = logger_impl.Logger();

  Logger._();

  static void d(String message) {
    if (kDebugMode) {
      _loggerImpl.d(message);
    }

    if (!kReleaseMode) return;
    FirebaseCrashlytics.instance.log(message);
  }

  static void e(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      _loggerImpl.e(message, error, stackTrace);
    }

    if (!kReleaseMode) return;
    FirebaseCrashlytics.instance.recordFlutterFatalError(FlutterErrorDetails(
      exception: Exception(message + error.toString()),
      stack: stackTrace,
    ));
  }
}
