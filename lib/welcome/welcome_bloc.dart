// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slidemix/logger.dart';
import 'package:slidemix/movies/data/movie_dao.dart';

class WelcomeBloc extends Bloc<_WelcomeEvent, WelcomeState> {
  final MovieDao _movieDao;

  WelcomeBloc({
    required MovieDao movieDao,
  })  : _movieDao = movieDao,
        super(WelcomeLoadingState()) {
    _movieDao.getAll().first.then(
      (movies) {
        if (movies.isEmpty) {
          emit(ShowWelcomeState());
        } else {
          emit(ShowMoviesState());
        }
      },
      onError: (e, st) {
        Logger.e('Failed to get all movies', error: e, stackTrace: st);
        emit(ShowWelcomeState());
      },
    );
  }
}

class _WelcomeEvent {}

abstract class WelcomeState {}

class WelcomeLoadingState extends WelcomeState {}

class ShowWelcomeState extends WelcomeState {}

class ShowMoviesState extends WelcomeState {}
