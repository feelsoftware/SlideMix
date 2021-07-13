import 'package:cpmoviemaker/navigation.dart';
import 'package:cpmoviemaker/providers.dart';
import 'package:cpmoviemaker/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(
      MultiProvider(
        providers: getProviders(),
        child: MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CPMovieMaker',
      theme: ThemeData(
        primarySwatch: primarySwatch,
        scaffoldBackgroundColor: AppColors.background,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: getInitialRoute(),
      routes: getRoutes(),
    );
  }
}
