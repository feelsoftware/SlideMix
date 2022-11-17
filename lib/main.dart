import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slidemix/colors.dart';
import 'package:slidemix/database.dart';
import 'package:slidemix/firebase_options.dart';
import 'package:slidemix/localizations.dart';
import 'package:slidemix/logger.dart';
import 'package:slidemix/navigation.dart';
import 'package:slidemix/setup.dart';
import 'package:slidemix/welcome/welcome.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // DB
  final database = await $FloorAppDatabase.databaseBuilder('slidemix.db').build();
  final sharedPreferences = await SharedPreferences.getInstance();

  // Locale
  timeago.setLocaleMessages('uk', timeago.UkMessages());

  // Fonts
  GoogleFonts.config.allowRuntimeFetching = false;

  // Crashlytics
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = (details) {
    Logger.e(details.toStringShort(), details.exception, details.stack);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    Logger.e('Uncaught asynchronous error', error, stack);
    return true;
  };

  runApp(SlideMixApp(
    appDatabase: database,
    sharedPreferences: sharedPreferences,
  ));
}

class SlideMixApp extends StatelessWidget {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  final AppDatabase appDatabase;
  final SharedPreferences sharedPreferences;

  const SlideMixApp({
    super.key,
    required this.appDatabase,
    required this.sharedPreferences,
  });

  @override
  Widget build(BuildContext context) {
    return Setup(
      appDatabase: appDatabase,
      sharedPreferences: sharedPreferences,
      child: MaterialApp(
        theme: _buildTheme(Brightness.light),
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        navigatorObservers: [
          NavigationStackObserver(),
          NavigationLogger(),
        ],
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        onGenerateTitle: (context) => AppLocalizations.of(context).appName,
        home: const WelcomeScreen(),
      ),
    );
  }

  ThemeData _buildTheme(brightness) {
    final baseTheme = ThemeData(
      primarySwatch: primarySwatch,
      scaffoldBackgroundColor: AppColors.background,
    );

    return baseTheme.copyWith(
      textTheme: GoogleFonts.robotoTextTheme(baseTheme.textTheme),
    );
  }
}
