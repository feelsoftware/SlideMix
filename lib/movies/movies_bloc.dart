import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slidemix/movies/data/movie_dao.dart';
import 'package:slidemix/movies/data/movie_entity.dart';
import 'package:slidemix/movies/data/movie_mapper.dart';
import 'package:slidemix/movies/data/movie.dart';

class MoviesBloc extends Bloc<_MoviesEvent, MoviesState> {
  final MovieDao _movieDao;

  StreamSubscription<List<MovieEntity>>? _allMoviesSubscription;

  MoviesBloc({
    required MovieDao movieDao,
  })  : _movieDao = movieDao,
        super(const MoviesState(<Movie>[])) {
    _subscribeToDBUpdates();

    on<_OnMoviesChangedEvent>(_onMoviesChanges);
  }

  FutureOr<void> toggleFavourite(Movie movie) async {
    final movieEntity = await _movieDao.getById(movie.id!);
    if (movieEntity == null) {
      throw Exception("Can't find movie by id ${movie.id}");
    }

    _movieDao.update(movieEntity.copyWith(
      isFavourite: !movieEntity.isFavourite,
    ));
  }

  @override
  Future<void> close() async {
    await _allMoviesSubscription?.cancel();
    return super.close();
  }

  void _subscribeToDBUpdates() {
    _allMoviesSubscription = _movieDao.getAll().listen((movies) {
      add(_OnMoviesChangedEvent(movies));
    });
  }

  Future<void> _onMoviesChanges(
    _OnMoviesChangedEvent event,
    Emitter<MoviesState> emit,
  ) async {
    emit(MoviesState(
      event.movies.map((e) => e.toMovie()).toList(growable: false),
    ));
  }
}

abstract class _MoviesEvent {
  const _MoviesEvent();
}

class _OnMoviesChangedEvent extends _MoviesEvent {
  final List<MovieEntity> movies;

  const _OnMoviesChangedEvent(this.movies);
}

class MoviesState extends Equatable {
  final List<Movie> movies;

  const MoviesState(this.movies);

  @override
  List<Object?> get props => [movies];

  @override
  bool? get stringify => true;
}
