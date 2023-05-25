import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart' as logger_impl;
import 'package:slidemix/firebase_options.dart';

/// Log to Logcat only in debug mode, send logs to Crashlytics in other cases.
class Logger {
  static final logger_impl.Logger _loggerImpl = logger_impl.Logger();

  const Logger._();

  static bool get _crashlyticsEnabled => !kDebugMode;

  static Future init() async {
    FlutterError.onError = _fatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      Logger.e('Uncaught asynchronous error', error, stack);
      return true;
    };

    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(_crashlyticsEnabled);
  }

  static void d(String message) {
    if (_crashlyticsEnabled) {
      FirebaseCrashlytics.instance.log(message);
    } else {
      _loggerImpl.d(message);
    }
  }

  static void e(String message, [dynamic error, StackTrace? stackTrace]) {
    if (_crashlyticsEnabled) {
      FirebaseCrashlytics.instance.log(message);
      FirebaseCrashlytics.instance.recordError(error, stackTrace, reason: message);
    } else {
      _loggerImpl.e(message, error, stackTrace);
    }
  }

  static void _fatalError(FlutterErrorDetails flutterErrorDetails) {
    if (_crashlyticsEnabled) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(flutterErrorDetails);
    } else {
      _loggerImpl.wtf(
        flutterErrorDetails.exception,
        flutterErrorDetails.exception,
        flutterErrorDetails.stack,
      );
    }
  }
}
