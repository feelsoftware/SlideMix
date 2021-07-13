import 'package:cpmoviemaker/entry_point/entry_point.dart';
import 'package:cpmoviemaker/entry_point/entry_point_viewmodel.dart';
import 'package:cpmoviemaker/movies/movies_viewmodel.dart';
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
          ChangeNotifierProvider(
            create: (_) => EntryPointViewModel(
              MoviesUseCaseImpl(),
            ),
          ),
        ],
        child: MyApp(),
      ),
    );

final Color primaryColor = Color(0xffff8955);
final Color secondaryColor = Color(0xffff5500);
final Color borderColor = Color(0xff9e9e9e);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CPMovieMaker',
      theme: ThemeData(
        primarySwatch: MaterialColor(
          primaryColor.value,
          <int, Color>{
            50: Color(primaryColor.value),
            100: Color(primaryColor.value),
            200: Color(primaryColor.value),
            300: Color(primaryColor.value),
            400: Color(primaryColor.value),
            500: Color(primaryColor.value),
            600: Color(primaryColor.value),
            700: Color(primaryColor.value),
            800: Color(primaryColor.value),
            900: Color(primaryColor.value),
          },
        ),
        primaryTextTheme: TextTheme(
          headline6: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      home: EntryPointScreen(
        Provider.of<EntryPointViewModel>(context, listen: false),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
