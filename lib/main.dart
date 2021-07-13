import 'package:com_feelsoftware_slidemix/colors.dart';
import 'package:com_feelsoftware_slidemix/navigation.dart';
import 'package:com_feelsoftware_slidemix/providers.dart';
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
      title: 'SlideMix',
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
