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
        transition: project.transition,
        orientation: project.orientation,
      ),
    ));
  }

  Future<void> pickFiles(Iterable<File> files) async {
    emit(state._copyWith(
      isLoading: true,
    ));
    final project = await _project;
    final media = files.map((file) => Media(projectId: project.id, path: file.path));
    emit(state._copyWith(
      media: await project.attachMedia(media),
      isLoading: false,
    ));
  }

  Future<void> deleteMedia(Media media) async {
    final project = await _project;
    emit(state._copyWith(
      media: await project.deleteMedia(media),
    ));
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

  Future<void> changeTransition(SlideShowTransition? transition) async {
    final project = await _project;
    emit(state._copyWith(
      settings: state.settings._copyWith(
        transition: await project.changeTransition(transition),
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

  Future<Movie> createMovie() async {
    Logger.d('createMovie ${state.media}');
    emit(state._copyWith(
      isLoading: true,
    ));

    Movie movie;
    try {
      movie = await (await _project).createMovie(
        slideDuration: const Duration(seconds: 3),
        transitionDuration: const Duration(seconds: 1),
      );
    } catch (ex, st) {
      Logger.e('Failed to create movie', ex, st);
      emit(state._copyWith(
        isLoading: false,
      ));
      throw Exception('Failed to create movie');
    }

    await reset(deleteDraft: true);
    return movie;
  }
}

class CreationState extends Equatable {
  final List<Media> media;
  final CreationSettings settings;
  final bool isLoading;

  const CreationState({
    required this.media,
    required this.settings,
    this.isLoading = false,
  });

  int get minMediaCountToProceed => _minMediaCount - media.length;

  bool get isCreationAllowed => media.length >= _minMediaCount;

  factory CreationState._empty() => const CreationState(
      settings: CreationSettings(
        transition: null,
        orientation: SlideShowOrientation.landscape,
      ),
      media: []);

  CreationState _copyWith({
    List<Media>? media,
    CreationSettings? settings,
    bool? isLoading,
  }) {
    return CreationState(
      media: List.unmodifiable(media ?? this.media),
      settings: settings ?? this.settings,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [media, settings, isLoading];

  @override
  bool? get stringify => true;
}

class CreationSettings extends Equatable {
  final SlideShowTransition? transition;
  final SlideShowOrientation orientation;

  const CreationSettings({
    required this.transition,
    required this.orientation,
  });

  CreationSettings _copyWith({
    required SlideShowTransition? transition,
    SlideShowOrientation? orientation,
  }) {
    return CreationSettings(
      transition: transition,
      orientation: orientation ?? this.orientation,
    );
  }

  @override
  List<Object?> get props => [transition, orientation];

  @override
  bool? get stringify => true;
}
