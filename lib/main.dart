import 'package:cpmoviemaker/movies/movies.dart';
import 'package:cpmoviemaker/repository/movies_repository.dart';
import 'package:cpmoviemaker/movies/movies_viewmodel.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CPMovieMaker',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        primaryTextTheme: TextTheme(
          title: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      home: MoviesScreen(
        MoviesViewModel(MoviesRepositoryImpl()),
        'CPMovieMaker',
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
