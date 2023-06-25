// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slidemix/creation/data/media.dart';
import 'package:slidemix/creator/movie_creator.dart';
import 'package:slidemix/creator/movie_project.dart';
import 'package:slidemix/creator/slideshow_creator.dart';
import 'package:slidemix/creator/slideshow_orientation.dart';
import 'package:slidemix/creator/slideshow_resize.dart';
import 'package:slidemix/creator/slideshow_transition.dart';
import 'package:slidemix/draft/draft_movie_manager.dart';
import 'package:slidemix/logger.dart';
import 'package:slidemix/movies/data/movie.dart';
import 'package:slidemix/movies/data/movie_dao.dart';
import 'package:slidemix/movies/movies.dart';
import 'package:slidemix/welcome/welcome.dart';

const int _minMediaCount = 2;

class CreationBloc extends Bloc<dynamic, CreationState> {
  final DraftMovieManager _draftMovieManager;
  final MovieCreator _movieCreator;
  final MovieDao _movieDao;

  CreationBloc({
    required DraftMovieManager draftMovieManager,
    required MovieCreator movieCreator,
    required MovieDao movieDao,
  })  : _draftMovieManager = draftMovieManager,
        _movieCreator = movieCreator,
        _movieDao = movieDao,
        super(CreationState._empty());

  MovieProject? __project;

  Future<MovieProject> get _project async {
    if (__project != null) {
      return __project!;
    }
    __project = await _movieCreator.newProject();
    return __project!;
  }

  @override
  Future<void> close() async {
    await reset(deleteDraft: false);
    return super.close();
  }

  Future<void> openDraft(Movie draftMovie) async {
    __project = await _movieCreator.openDraft(draftMovie);
    final project = await _project;
    emit(CreationState(
      media: project.media,
      settings: CreationSettings(
        slideDuration: project.slideDuration,
        transition: project.transition,
        transitionDuration: project.transitionDuration,
        orientation: project.orientation,
        resize: project.resize,
      ),
    ));
  }

  Future<void> pickFiles(Iterable<File> files) async {
    emit(state._copyWith(
      loadingProgress: _loadingProgressInfinite,
    ));
    final project = await _project;
    final media = files.map((file) => Media(projectId: project.id, path: file.path));
    emit(state._copyWith(
      media: await project.attachMedia(media),
      loadingProgress: _loadingProgressHide,
    ));
  }

  Future<void> deleteMedia(Media media) async {
    final project = await _project;
    emit(state._copyWith(
      media: await project.deleteMedia(media),
    ));
  }

  Future<void> cancelCreation() async {
    await (await _project).dispose(deleteDraft: false);
  }

  Future<Route<void>> reset({required bool deleteDraft}) async {
    await (await _project).dispose(deleteDraft: deleteDraft);
    __project = null;

    emit(CreationState._empty());

    final movies = await _movieDao.getAll().first;
    final drafts = await _draftMovieManager.getAll().first;

    if (drafts.isNotEmpty || movies.isNotEmpty) {
      return MoviesScreen.route();
    } else {
      return WelcomeScreen.route();
    }
  }

  Future<void> changeSlideDuration(Duration duration) async {
    final project = await _project;
    emit(state._copyWith(
      settings: state.settings._copyWith(
        transition: state.settings.transition,
        slideDuration: await project.changeSlideDuration(duration),
      ),
    ));
  }

  Future<void> changeTransition(SlideShowTransition? transition) async {
    final project = await _project;
    emit(state._copyWith(
      settings: state.settings._copyWith(
        transition: await project.changeTransition(transition),
      ),
    ));
  }

  Future<void> changeTransitionDuration(Duration duration) async {
    final project = await _project;
    emit(state._copyWith(
      settings: state.settings._copyWith(
        transition: state.settings.transition,
        transitionDuration: await project.changeTransitionDuration(duration),
      ),
    ));
  }

  Future<void> changeOrientation(SlideShowOrientation orientation) async {
    final project = await _project;

    emit(state._copyWith(
      settings: state.settings._copyWith(
        transition: state.settings.transition,
        orientation: await project.changeOrientation(orientation),
      ),
    ));
  }

  Future<void> changeResize(SlideShowResize resize) async {
    final project = await _project;

    emit(state._copyWith(
      settings: state.settings._copyWith(
        transition: state.settings.transition,
        resize: await project.changeResize(resize),
      ),
    ));
  }

  Future<Movie> createMovie() async {
    Logger.d('createMovie ${state.media}');
    emit(state._copyWith(
      loadingProgress: _loadingProgressInfinite,
    ));

    Movie movie;
    try {
      movie = await (await _project).createMovie(
        onProgress: (progress) {
          emit(state._copyWith(
            loadingProgress: (progress * 100).round(),
          ));
        },
      );
    } on CancellationException {
      Logger.d('Cancelled movie creation');
      emit(state._copyWith(
        loadingProgress: _loadingProgressHide,
      ));
      rethrow;
    } catch (ex, st) {
      Logger.e('Failed to create movie', ex, st);
      emit(state._copyWith(
        loadingProgress: _loadingProgressHide,
      ));
      throw Exception('Failed to create movie');
    }

    await reset(deleteDraft: true);
    return movie;
  }
}

const _loadingProgressHide = -1;
const _loadingProgressInfinite = 100;

class CreationState extends Equatable {
  final List<Media> media;
  final CreationSettings settings;
  final int loadingProgress;

  const CreationState({
    required this.media,
    required this.settings,
    this.loadingProgress = _loadingProgressHide,
  });

  int get minMediaCountToProceed => _minMediaCount - media.length;

  bool get isCreationAllowed => media.length >= _minMediaCount;

  bool get isLoading => loadingProgress != _loadingProgressHide;

  bool get isInfiniteLoading => loadingProgress == _loadingProgressInfinite;

  factory CreationState._empty() => CreationState(
        settings: CreationSettings._empty(),
        media: const [],
      );

  CreationState _copyWith({
    List<Media>? media,
    CreationSettings? settings,
    int? loadingProgress,
  }) {
    return CreationState(
      media: List.unmodifiable(media ?? this.media),
      settings: settings ?? this.settings,
      loadingProgress: loadingProgress ?? this.loadingProgress,
    );
  }

  @override
  List<Object?> get props => [media, settings, loadingProgress];

  @override
  bool? get stringify => true;
}

class CreationSettings extends Equatable {
  final Duration slideDuration;
  final SlideShowTransition? transition;
  final Duration transitionDuration;
  final SlideShowOrientation orientation;
  final SlideShowResize resize;

  const CreationSettings({
    required this.slideDuration,
    required this.transition,
    required this.transitionDuration,
    required this.orientation,
    required this.resize,
  });

  factory CreationSettings._empty() => const CreationSettings(
        slideDuration: Duration(seconds: 1),
        transition: null,
        transitionDuration: Duration(seconds: 1),
        orientation: SlideShowOrientation.landscape,
        resize: SlideShowResize.contain,
      );

  CreationSettings _copyWith({
    Duration? slideDuration,
    required SlideShowTransition? transition,
    Duration? transitionDuration,
    SlideShowOrientation? orientation,
    SlideShowResize? resize,
  }) {
    return CreationSettings(
      slideDuration: slideDuration ?? this.slideDuration,
      transition: transition,
      transitionDuration: transitionDuration ?? this.transitionDuration,
      orientation: orientation ?? this.orientation,
      resize: resize ?? this.resize,
    );
  }

  @override
  List<Object?> get props => [
        slideDuration,
        transition,
        transitionDuration,
        orientation,
        resize,
      ];

  @override
  bool? get stringify => true;
}
