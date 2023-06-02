// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slidemix/draft/draft_movie_manager.dart';
import 'package:slidemix/file_manager.dart';
import 'package:slidemix/localizations.dart';
import 'package:slidemix/movies/data/movie_dao.dart';
import 'package:slidemix/movies/data/movie_mapper.dart';
import 'package:slidemix/movies/data/movie.dart';

class MoviesBloc extends Bloc<dynamic, MoviesState> {
  final DraftMovieManager _draftMovieManager;
  final FileManager _fileManager;
  final MovieDao _movieDao;

  StreamSubscription<dynamic>? _draftSubscription;
  StreamSubscription<dynamic>? _moviesSubscription;

  MoviesBloc({
    required DraftMovieManager draftMovieManager,
    required FileManager fileManager,
    required MovieDao movieDao,
  })  : _draftMovieManager = draftMovieManager,
        _fileManager = fileManager,
        _movieDao = movieDao,
        super(const MoviesState(<Movie>[])) {
    _subscribeToDBUpdates();
  }

  FutureOr<void> toggleFavourite(Movie movie) async {
    final movieEntity = await _movieDao.getById(movie.id);
    if (movieEntity == null) {
      throw Exception("Can't find movie by id ${movie.id}");
    }

    _movieDao.update(movieEntity.copyWith(
      isFavourite: !movieEntity.isFavourite,
    ));
  }

  void _subscribeToDBUpdates() {
    refresh(dynamic _) async {
      final drafts = await _draftMovieManager.getAll().first;
      final movies = (await _movieDao.getAll().first)
          .map((e) => e.toMovie())
          .toList(growable: false);

      emit(MoviesState(
        <Movie>[
          ...drafts.map(
            (draft) => Movie(
              id: draft.projectId,
              title: AppLocalizations.app()?.projectTitle(draft.projectId) ??
                  'project #${draft.projectId}',
              thumb: _fileManager.getThumbFromDraft(draft).path,
              video: '',
              mime: '',
              duration: Duration.zero,
              createdAt: draft.createdAt,
              isDraft: true,
            ),
          ),
          ...movies,
        ],
      ));
    }

    _draftSubscription = _draftMovieManager.getAll().listen(refresh);
    _moviesSubscription = _movieDao.getAll().listen(refresh);
  }

  @override
  Future<void> close() {
    _draftSubscription?.cancel();
    _moviesSubscription?.cancel();
    return super.close();
  }
}

class MoviesState extends Equatable {
  final List<Movie> movies;

  const MoviesState(this.movies);

  @override
  List<Object?> get props => [movies];

  @override
  bool? get stringify => true;
}
