import 'package:cpmoviemaker/creation/creation.dart';
import 'package:cpmoviemaker/creation/creation_viewmodel.dart';
import 'package:cpmoviemaker/movies/movies.dart';
import 'package:cpmoviemaker/movies/movies_viewmodel.dart';
import 'package:cpmoviemaker/preview/preview.dart';
import 'package:cpmoviemaker/preview/preview_viewmodel.dart';
import 'package:cpmoviemaker/usecase/creation_usecase.dart';
import 'package:cpmoviemaker/usecase/movies_usecase.dart';
import 'package:cpmoviemaker/welcome/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'models/movie.dart';

void navigateBack(BuildContext context) {
  if (Navigator.canPop(context)) {
    Navigator.pop(context);
  } else {
    SystemNavigator.pop();
  }
}

void navigateToWelcome(BuildContext context) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(
    builder: (context) => WelcomeScreen(),
  ));
}

void navigateToMovies(BuildContext context) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(
    builder: (context) => MoviesScreen(
      Provider.of<MoviesViewModel>(context, listen: false),
      'CPMovieMaker',
    ),
  ));
}

void navigateToCreation(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => CreationScreen(
      CreationViewModel(
        CreationUseCaseImpl(
          MoviesUseCaseImpl(),
        ),
        Provider.of<MoviesViewModel>(context, listen: false),
      ),
    ),
  ));
}

void navigateToPreview(BuildContext context, Movie movie) {
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => PreviewScreen(
          PreviewViewModel(
            movie,
          ),
        ),
      ),
      ModalRoute.withName('/'));
}
