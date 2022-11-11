import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slidemix/creator/movie_creator.dart';
import 'package:slidemix/logger.dart';
import 'package:slidemix/movies/data/movie.dart';
import 'package:slidemix/movies/data/movie_dao.dart';
import 'package:slidemix/movies/movies.dart';
import 'package:slidemix/welcome/welcome.dart';

class PreviewBloc extends Bloc<dynamic, dynamic> {
  final MovieCreator _movieCreator;
  final MovieDao _movieDao;

  PreviewBloc({
    required MovieCreator movieCreator,
    required MovieDao movieDao,
  })  : _movieCreator = movieCreator,
        _movieDao = movieDao,
        super(null);

  FutureOr<Route<void>> delete(Movie movie) async {
    Logger.d('Delete movie $movie');
    await _movieCreator.deleteProject(movie);

    if ((await _movieDao.getAll().first).isEmpty) {
      return WelcomeScreen.route();
    } else {
      return MoviesScreen.route();
    }
  }
}
