import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart' as logger_impl;
import 'package:slidemix/firebase_options.dart';
import 'package:slidemix/navigation.dart';

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

    await Firebase.initializeApp(
      name: 'SlideMix',
      options: DefaultFirebaseOptions.currentPlatform,
    );
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
      FirebaseCrashlytics.instance
          .recordError(error, stackTrace, reason: message);
    } else {
      _loggerImpl.e(message, error: error, stackTrace: stackTrace);
    }
  }

  static void _fatalError(FlutterErrorDetails flutterErrorDetails) {
    if (_crashlyticsEnabled) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(flutterErrorDetails);
    } else {
      _loggerImpl.f(
        flutterErrorDetails.exception,
        error: flutterErrorDetails.exception,
        stackTrace: flutterErrorDetails.stack,
      );
    }
  }

  static NavigatorObserver navigatorObserver = _NavigationLogger();

  static void screen(Route route) {
    navigatorObserver.didPush(route, null);
  }
}

class _NavigationLogger extends RouteObserver<Route<dynamic>> {
  @override
  void didPush(Route route, Route? previousRoute) {
    Logger.d(
        'didPush ${_routeToLog(route)}, previous=${_routeToLog(previousRoute)}');
    _onScreenShown(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    Logger.d(
        'didReplace ${_routeToLog(newRoute)}, oldRoute=${_routeToLog(oldRoute)}');
    if (newRoute != null) _onScreenShown(newRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    Logger.d(
        'didPop ${_routeToLog(route)}, previous=${_routeToLog(previousRoute)}');
    if (previousRoute != null) _onScreenShown(previousRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    Logger.d(
        'didRemove ${_routeToLog(route)}, previous=${_routeToLog(previousRoute)}');
    if (previousRoute != null) _onScreenShown(previousRoute);
  }

  String _routeToLog(Route<dynamic>? route) {
    if (route == null) return '';
    return <String>[
      "'${route.settings.name}'",
      if (route.settings.arguments != null)
        "arguments:${route.settings.arguments.toString()}",
    ].join(' ');
  }

  void _onScreenShown(Route<dynamic> route) {
    if (route.settings.name == '/') {
      // Ignore initial route, we will log inside WelcomeScreen when it's shown
      return;
    }

    String screenClass = 'null';
    if (route.settings is AppRouteSettings) {
      screenClass = (route.settings as AppRouteSettings).screenClass.toString();
    }

    if (Logger._crashlyticsEnabled) {
      FirebaseAnalytics.instance
          .logScreenView(
            screenName: route.settings.name,
            screenClass: screenClass,
          )
          .ignore();
    } else {
      Logger._loggerImpl.w('onScreenShown $screenClass, ${_routeToLog(route)}');
    }
  }
}
