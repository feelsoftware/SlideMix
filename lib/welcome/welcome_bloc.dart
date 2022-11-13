// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slidemix/draft/draft_movie_manager.dart';
import 'package:slidemix/logger.dart';
import 'package:slidemix/movies/data/movie_dao.dart';

class WelcomeBloc extends Bloc<dynamic, WelcomeState> {
  final DraftMovieManager _draftMovieManager;
  final MovieDao _movieDao;

  WelcomeBloc({
    required DraftMovieManager draftMovieManager,
    required MovieDao movieDao,
  })  : _draftMovieManager = draftMovieManager,
        _movieDao = movieDao,
        super(WelcomeLoadingState()) {
    _calculateNextState().catchError((ex, st) {
      Logger.e('Failed to get all movies', ex, st);
      emit(ShowWelcomeState());
    });
  }

  FutureOr<void> reset() {
    emit(WelcomeLoadingState());
  }

  Future<void> _calculateNextState() async {
    final drafts = await _draftMovieManager.getAll().first;
    final movies = await _movieDao.getAll().first;

    if (drafts.isNotEmpty || movies.isNotEmpty) {
      emit(ShowMoviesState());
    } else {
      emit(ShowWelcomeState());
    }
  }
}

abstract class WelcomeState {}

class WelcomeLoadingState extends WelcomeState {}

class ShowWelcomeState extends WelcomeState {}

class ShowMoviesState extends WelcomeState {}
