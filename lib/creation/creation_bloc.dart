// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:ffmpeg_kit_flutter/ffprobe_kit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:slidemix/creation/data/creation_dao.dart';
import 'package:slidemix/creation/data/creation_entity.dart';
import 'package:slidemix/creation/data/media.dart';
import 'package:slidemix/logger.dart';
import 'package:slidemix/movies/data/movie.dart';
import 'package:slidemix/movies/data/movie_dao.dart';
import 'package:slidemix/movies/data/movie_mapper.dart';

const int _minMediaCount = 3;

class CreationBloc extends Bloc<Object, CreationState> {
  final CreationDao _creationDao;
  final MovieDao _moviesDao;

  CreationBloc({
    required CreationDao creationDao,
    required MovieDao moviesDao,
  })  : _creationDao = creationDao,
        _moviesDao = moviesDao,
        super(const CreationState(<Media>[]));

  @override
  Future<void> close() async {
    await reset();
    return super.close();
  }

  FutureOr<void> pickMedia(List<Media> media) async {
    Logger.d('pickMedia $media');

    // imagePicker stores files in cacheDir, it has a specific TTL
    // Move files to filesDir to keep those files as long as we want to
    final appDocDir = (await getApplicationDocumentsDirectory()).path;
    List<Media> mediaWithUpdatedPath = [];
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
      File(item.path).delete().ignore();
    }
    FFmpegKit.cancel();

    emit(const CreationState(<Media>[]));
  }

  FutureOr<Movie> createMovie() async {
    Logger.d('createMovie ${state.media}');
    emit(state.copyWith(isLoading: true));

    // Move files to sceneDir to run FFmpeg command
    final appDocDir = (await getApplicationDocumentsDirectory()).path;
    final projectId = (await _creationDao.getAll()).length + 1;
    final sceneDir = Directory('$appDocDir/scenes/scene_$projectId')
      ..createSync(recursive: true);
    List<Media> mediaWithUpdatedPath = [];
    final format = NumberFormat('000');
    for (var index = 0; index < state.media.length; index++) {
      final item = state.media[index];
      try {
        final newPath = '${sceneDir.path}/image${format.format(index)}.jpg';
        await File(item.path).copy(newPath);
        mediaWithUpdatedPath.add(Media(newPath));
        Logger.d('Moved file to sceneDir, $newPath');
      } catch (ex, st) {
        Logger.e('Failed to move file to sceneDir, ${item.path}', ex, st);
      }
    }
    if (mediaWithUpdatedPath.isEmpty) {
      emit(state.copyWith(isLoading: false));
      throw Exception("Can't create movie, not enough media");
    }

    final movieDir = Directory('$appDocDir/movies')..createSync();
    final moviePath = '${movieDir.path}/movie_$projectId.mp4';
    const pixels = 720;
    final movieCommand = <String>[
      "-framerate",
      "1",
      "-i",
      "${sceneDir.path}/image%03d.jpg",
      "-r",
      "30",
      "-vf",
      "scale='if(gt(iw,ih),-2,min($pixels,iw))':'if(gt(iw,ih),min($pixels,iw),-2)'",
      "-pix_fmt",
      "yuv420p",
      "-y",
      moviePath,
    ];
    Logger.d('Create movie ${movieCommand.join(' ')}');
    await FFmpegKit.executeWithArguments(movieCommand);
    final movieSession = (await FFmpegKit.listSessions()).last;
    Duration movieDuration;
    if (ReturnCode.isCancel(await movieSession.getReturnCode())) {
      Logger.d('Canceled video creation $moviePath');
      throw Exception('Video creation cancelled');
    }
    if (ReturnCode.isSuccess(await movieSession.getReturnCode())) {
      Logger.d('Movie is created $moviePath');

      for (final media in state.media) {
        File(media.path).delete().ignore();
      }

      try {
        final mediaInformation =
            (await FFprobeKit.getMediaInformation(moviePath)).getMediaInformation();
        final duration = double.parse(mediaInformation?.getDuration() ?? '0.0').toInt();
        movieDuration = Duration(seconds: duration);
      } catch (ex, st) {
        Logger.e('Failed to get media information $moviePath', ex, st);
        movieDuration = Duration.zero;
      }
    } else {
      emit(state.copyWith(isLoading: false));
      Logger.e(
        'Failed to create movie',
        Exception(
          (await movieSession.getLogs()).reversed.map((log) => log.getMessage()),
        ),
      );
      throw Exception('Failed to create movie');
    }

    final thumbDir = Directory('$appDocDir/thumbnails')..createSync();
    final thumbPath = '${thumbDir.path}/thumb_$projectId.jpg';
    final thumbCommand = <String>[
      "-ss",
      // Use the first frame/image as thumb
      _formatDurationForThumbnail(Duration.zero),
      "-noaccurate_seek",
      "-i",
      moviePath,
      "-vframes",
      "1",
      "-y",
      thumbPath,
    ];
    Logger.d('Generate thumbnail ${thumbCommand.join(' ')}');
    await FFmpegKit.executeWithArguments(thumbCommand);
    final thumbSession = (await FFmpegKit.listSessions()).last;
    if (ReturnCode.isCancel(await movieSession.getReturnCode())) {
      Logger.d('Canceled thumbnail generation $thumbPath');
      throw Exception('Video creation cancelled');
    }
    if (ReturnCode.isSuccess(await thumbSession.getReturnCode())) {
      Logger.d('Thumbnail is created $thumbPath');
    } else {
      Logger.e(
        'Failed to create thumbnail',
        Exception(
          (await movieSession.getLogs()).reversed.map((log) => log.getMessage()),
        ),
      );
    }

    await reset();
    emit(state.copyWith(isLoading: false));
    // TODO: do we actually need CreationDao?
    await _creationDao.insert(const CreationEntity());
    final movie = Movie(
      title: 'project #$projectId',
      thumb: thumbPath,
      video: moviePath,
      duration: movieDuration,
      createdAt: DateTime.now(),
      isFavourite: false,
      isDraft: false,
    );
    await _moviesDao.insert(movie.toEntity());
    return movie;
  }

  String _formatDurationForThumbnail(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds.000";
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
