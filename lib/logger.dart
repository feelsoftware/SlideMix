import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart' as logger_impl;

class Logger {
  static final logger_impl.Logger _loggerImpl = logger_impl.Logger();

  Logger._();

  static void d(String message) {
    _loggerImpl.d(message);
    FirebaseCrashlytics.instance.log(message);
  }

  static void e(String message, [dynamic error, StackTrace? stackTrace]) {
    _loggerImpl.e(message, error, stackTrace);
    FirebaseCrashlytics.instance.recordFlutterFatalError(FlutterErrorDetails(
      exception: Exception(message + error.toString()),
      stack: stackTrace,
    ));
  }
}
