// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slidemix/creation/data/media.dart';
import 'package:slidemix/creator/movie_creator.dart';
import 'package:slidemix/creator/movie_project.dart';
import 'package:slidemix/logger.dart';
import 'package:slidemix/movies/data/movie.dart';

const int _minMediaCount = 3;

class CreationBloc extends Bloc<dynamic, CreationState> {
  final MovieCreator _movieCreator;

  CreationBloc({
    required MovieCreator movieCreator,
  })  : _movieCreator = movieCreator,
        super(const CreationState(<Media>[]));

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
    await reset();
    return super.close();
  }

  FutureOr<void> pickMedia(List<Media> media) async {
    final project = await _project;
    emit(state.copyWith(
      media: await project.attachMedia(media),
    ));
  }

  FutureOr<void> deleteMedia(Media media) async {
    final project = await _project;
    emit(state.copyWith(
      media: await project.deleteMedia(media),
    ));
  }

  FutureOr<void> reset() async {
    (await _project).dispose();
    __project = null;

    emit(const CreationState(<Media>[]));
  }

  FutureOr<Movie> createMovie() async {
    Logger.d('createMovie ${state.media}');
    emit(state.copyWith(isLoading: true));

    Movie movie;
    try {
      movie = await (await _project).createMovie();
    } catch (_) {
      emit(state.copyWith(isLoading: false));
      throw Exception('Failed to create movie');
    }

    await reset();
    return movie;
  }
}

class CreationState extends Equatable {
  final List<Media> media;
  final bool isLoading;

  const CreationState(
    this.media, {
    this.isLoading = false,
  });

  int get minMediaCountToProceed => media.length - _minMediaCount;

  bool get isCreationAllowed => media.length >= _minMediaCount;

  CreationState copyWith({
    List<Media>? media,
    bool? isCreationAllowed,
    bool? isLoading,
  }) {
    return CreationState(
      List.unmodifiable(media ?? this.media),
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [media, isLoading];

  @override
  bool? get stringify => true;
}
