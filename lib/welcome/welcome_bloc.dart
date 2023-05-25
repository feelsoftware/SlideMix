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
    on<_OnShowLoadingEvent>((event, emit) {
      emit(WelcomeLoadingState());
    });
    on<_OnShowWelcomeEvent>((event, emit) {
      emit(ShowWelcomeState());
    });
    on<_OnShowMoviesEvent>((event, emit) {
      emit(ShowMoviesState());
    });
  }

  Future<void> refresh() async {
    _calculateNextState().catchError((ex, st) {
      Logger.e('Failed to get all movies', ex, st);
      add(_OnShowLoadingEvent());
    });
  }

  Future<void> reset() async {
    add(_OnShowLoadingEvent());
  }

  Future<void> _calculateNextState() async {
    final drafts = await _draftMovieManager.getAll().first;
    final movies = await _movieDao.getAll().first;

    if (drafts.isNotEmpty || movies.isNotEmpty) {
      add(_OnShowMoviesEvent());
    } else {
      add(_OnShowWelcomeEvent());
    }
  }
}

class _OnShowLoadingEvent {}

class _OnShowWelcomeEvent {}

class _OnShowMoviesEvent {}

sealed class WelcomeState {}

class WelcomeLoadingState extends WelcomeState {}

class ShowWelcomeState extends WelcomeState {}

class ShowMoviesState extends WelcomeState {}
