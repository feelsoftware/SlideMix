import 'package:com_feelsoftware_slidemix/creation/creation.dart';
import 'package:com_feelsoftware_slidemix/creation/creation_viewmodel.dart';
import 'package:com_feelsoftware_slidemix/entry_point/entry_point.dart';
import 'package:com_feelsoftware_slidemix/entry_point/entry_point_viewmodel.dart';
import 'package:com_feelsoftware_slidemix/movies/movies.dart';
import 'package:com_feelsoftware_slidemix/movies/movies_viewmodel.dart';
import 'package:com_feelsoftware_slidemix/preview/preview.dart';
import 'package:com_feelsoftware_slidemix/preview/preview_viewmodel.dart';
import 'package:com_feelsoftware_slidemix/usecase/creation_usecase.dart';
import 'package:com_feelsoftware_slidemix/usecase/movies_usecase.dart';
import 'package:com_feelsoftware_slidemix/welcome/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'models/movie.dart';

const String routeInit = "/";
const String routeWelcome = "/welcome";
const String routeMovies = "/movies";
const String routeCreation = "/creation";

String getInitialRoute() => routeInit;

Map<String, WidgetBuilder> getRoutes() {
  return {
    routeInit: (context) => EntryPointScreen(
          Provider.of<EntryPointViewModel>(context, listen: false),
        ),
    routeWelcome: (context) => WelcomeScreen(),
    routeMovies: (context) => MoviesScreen(
          Provider.of<MoviesViewModel>(context, listen: false),
        ),
    routeCreation: (context) => CreationScreen(
          CreationViewModel(
            CreationUseCaseImpl(
              MoviesUseCaseImpl(),
            ),
            Provider.of<MoviesViewModel>(context, listen: false),
          ),
        ),
  };
}

void navigateBack(BuildContext context) {
  if (Navigator.canPop(context)) {
    Navigator.pop(context);
  } else {
    SystemNavigator.pop();
  }
}

void navigateToWelcome(BuildContext context) {
  Navigator.of(context).pushReplacementNamed(routeWelcome);
}

void navigateToMovies(BuildContext context) {
  Navigator.of(context).pushReplacementNamed(routeMovies);
}

void navigateToCreation(BuildContext context) {
  Navigator.of(context).pushNamed(routeCreation);
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
      ModalRoute.withName(routeMovies));
}
