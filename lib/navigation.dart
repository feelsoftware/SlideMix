import 'package:cpmoviemaker/creation/creation.dart';
import 'package:cpmoviemaker/creation/creation_viewmodel.dart';
import 'package:cpmoviemaker/usecase/creation_usecase.dart';
import 'package:cpmoviemaker/usecase/movies_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/movie.dart';

void navigateBack(BuildContext context) {
  if (Navigator.canPop(context)) {
    Navigator.pop(context);
  } else {
    SystemNavigator.pop();
  }
}

void navigateToCreation(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => CreationScreen(
      CreationViewModel(
        CreationUseCaseImpl(
          MoviesUseCaseImpl(),
        ),
      ),
    ),
  ));
}

void navigateToPreview(BuildContext context, Movie movie) {}
