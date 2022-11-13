import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slidemix/colors.dart';
import 'package:slidemix/database.dart';
import 'package:slidemix/navigation.dart';
import 'package:slidemix/setup.dart';
import 'package:slidemix/welcome/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init DB
  final database = await $FloorAppDatabase.databaseBuilder('slidemix.db').build();
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(SlideMixApp(
    appDatabase: database,
    sharedPreferences: sharedPreferences,
  ));
}

class SlideMixApp extends StatelessWidget {
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
        title: 'SlideMix',
        theme: ThemeData(
          primarySwatch: primarySwatch,
          scaffoldBackgroundColor: AppColors.background,
        ),
        debugShowCheckedModeBanner: false,
        navigatorObservers: [
          NavigationStackObserver(),
        ],
        home: const WelcomeScreen(),
      ),
    );
  }
}
