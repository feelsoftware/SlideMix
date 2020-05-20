import 'package:cpmoviemaker/movies/movies_viewmodel.dart';
import 'package:cpmoviemaker/navigation.dart';
import 'package:cpmoviemaker/usecase/movies_usecase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => MoviesViewModel(
              MoviesUseCaseImpl(),
            ),
          ),
        ],
        child: MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CPMovieMaker',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        primaryTextTheme: TextTheme(
          headline6: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      home: homeRouter.buildPage(context, null, null),
      debugShowCheckedModeBanner: false,
    );
  }
}
