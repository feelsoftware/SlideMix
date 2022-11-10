import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slidemix/logger.dart';
import 'package:slidemix/movies/data/movie.dart';
import 'package:slidemix/movies/data/movie_dao.dart';
import 'package:slidemix/movies/data/movie_mapper.dart';
import 'package:slidemix/movies/movies.dart';
import 'package:slidemix/welcome/welcome.dart';

class PreviewBloc extends Bloc<dynamic, dynamic> {
  final MovieDao _movieDao;

  PreviewBloc({
    required MovieDao movieDao,
  })  : _movieDao = movieDao,
        super(null);

  FutureOr<Route<void>> delete(Movie movie) async {
    Logger.d('Delete movie $movie');
    _movieDao.delete(movie.toEntity()).ignore();
    File(movie.video).delete().ignore();
    File(movie.thumb).delete().ignore();

    if ((await _movieDao.getAll().first).isEmpty) {
      return WelcomeScreen.route();
    } else {
      return MoviesScreen.route();
    }
  }
}
