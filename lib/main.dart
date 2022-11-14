import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slidemix/colors.dart';
import 'package:slidemix/database.dart';
import 'package:slidemix/localizations.dart';
import 'package:slidemix/navigation.dart';
import 'package:slidemix/setup.dart';
import 'package:slidemix/welcome/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init DB
  final database = await $FloorAppDatabase.databaseBuilder('slidemix.db').build();
  final sharedPreferences = await SharedPreferences.getInstance();

  GoogleFonts.config.allowRuntimeFetching = false;

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
