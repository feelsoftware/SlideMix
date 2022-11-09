// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:slidemix/creation/data/media.dart';
import 'package:slidemix/logger.dart';

const int _minMediaCount = 3;

class CreationBloc extends Bloc<Object, CreationState> {
  CreationBloc() : super(const CreationState(<Media>[]));

  FutureOr<void> pickMedia(List<Media> media) async {
    Logger.d('pickMedia $media');

    final appDocDir = (await getApplicationDocumentsDirectory()).path;
    List<Media> mediaWithUpdatedPath = [];

    // imagePicker stores files in cacheDir, it has a specific TTL
    // Move files to filesDir to keep those files as long as we want to
    for (final item in media) {
      String fileName = basename(item.path);
      try {
        final newPath = '$appDocDir/$fileName';
        await File(item.path).rename(newPath);
        mediaWithUpdatedPath.add(Media(newPath));
        Logger.d('Moved file to filesDir, $newPath');
      } catch (ex, st) {
        Logger.e('Failed to move file to filesDir, ${item.path}', ex, st);
        mediaWithUpdatedPath.add(item);
      }
    }

    emit(state.copyWith(
      media: state.media.toList(growable: true)..addAll(mediaWithUpdatedPath),
    ));
  }

  FutureOr<void> deleteMedia(Media media) async {
    Logger.d('deleteMedia $media');

    File(media.path).delete().catchError((ex, st) {
      Logger.e('Failed to delete file ${media.path}', ex, st);
    });

    emit(state.copyWith(
      media: state.media.toList(growable: true)..remove(media),
    ));
  }

  FutureOr<void> reset() async {
    for (final item in state.media) {
      File(item.path).delete().catchError((ex, st) {
        Logger.e('Failed to delete file ${item.path}', ex, st);
      });
    }

    emit(state.copyWith(
      media: [],
    ));
  }

  FutureOr<void> createMovie() async {
    Logger.d('createMovie ${state.media}');
    emit(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(seconds: 3));
    emit(state.copyWith(isLoading: false));
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
