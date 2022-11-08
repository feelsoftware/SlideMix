import 'package:flutter/material.dart';
import 'package:slidemix/colors.dart';
import 'package:slidemix/database.dart';
import 'package:slidemix/setup.dart';
import 'package:slidemix/welcome/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init DB
  final database = await $FloorAppDatabase.databaseBuilder('slidemix.db').build();

  runApp(SlideMixApp(
    appDatabase: database,
  ));
}

class SlideMixApp extends StatelessWidget {
  final AppDatabase appDatabase;

  const SlideMixApp({
    super.key,
    required this.appDatabase,
  });

  @override
  Widget build(BuildContext context) {
    return Setup(
      appDatabase: appDatabase,
      child: MaterialApp(
        title: 'SlideMix',
        theme: ThemeData(
          primarySwatch: primarySwatch,
          scaffoldBackgroundColor: AppColors.background,
        ),
        debugShowCheckedModeBanner: false,
        home: const WelcomeScreen(),
      ),
    );
  }
}
