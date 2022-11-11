import 'dart:async';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:slidemix/creation/data/media.dart';
import 'package:slidemix/creator/slideshow_creator.dart';
import 'package:slidemix/logger.dart';
import 'package:slidemix/movies/data/movie.dart';
import 'package:slidemix/movies/data/movie_dao.dart';
import 'package:slidemix/movies/data/movie_mapper.dart';

abstract class MovieProject {
  Future<List<Media>> attachMedia(List<Media> media);

  Future<List<Media>> deleteMedia(Media media);

  Future<Movie> createMovie();

  Future<void> deleteProject();

  Future<void> dispose();
}

class MovieProjectImpl extends MovieProject {
  final int projectId;
  final MovieDao movieDao;
  final SlideShowCreator slideShowCreator;

  MovieProjectImpl({
    required this.projectId,
    required this.movieDao,
    required this.slideShowCreator,
  });

  final List<Media> _media = <Media>[];

  Future<Directory> get _tempDir async {
    final appDir = (await getApplicationDocumentsDirectory()).path;
    final dir = Directory('$appDir/project${projectId}_temp');
    await dir.create();
    return dir;
  }

  Future<Directory> get _projectDir async {
    final appDir = (await getApplicationDocumentsDirectory()).path;
    final dir = Directory('$appDir/project$projectId');
    await dir.create();
    return dir;
  }

  @override
  Future<List<Media>> attachMedia(List<Media> media) async {
    Logger.d('attachMedia $projectId $media');

    // imagePicker stores files in cacheDir, it has a specific TTL
    // Move files to filesDir to keep those files as long as we want to
    List<Media> mediaWithUpdatedPath = [];
    final destinationDir = await _tempDir;
    for (final item in media) {
      String fileName = basename(item.path);
      try {
        final newPath = '${destinationDir.path}/$fileName';
        await File(item.path).rename(newPath);
        mediaWithUpdatedPath.add(Media(newPath));
        Logger.d('Moved file to tempDir, $newPath');
      } catch (ex, st) {
        Logger.e('Failed to move file to tempDir, ${item.path}', ex, st);
      }
    }

    _media.addAll(mediaWithUpdatedPath);
    return List.unmodifiable(_media);
  }

  @override
  Future<List<Media>> deleteMedia(Media media) async {
    Logger.d('deleteMedia $projectId $media');
    _media.remove(media);
    File(media.path).delete().ignore();
    return List.unmodifiable(_media);
  }

  @override
  Future<Movie> createMovie() async {
    Logger.d('createMovie $projectId');

    final format = NumberFormat('000');
    final destinationDir = await _tempDir;
    for (var index = 0; index < _media.length; index++) {
      final item = _media[index];
      try {
        final newPath = '${destinationDir.path}/image${format.format(index)}.jpg';
        await File(item.path).rename(newPath);
        _media[index] = Media(newPath);
      } catch (ex, st) {
        Logger.e('Failed to rename image, ${item.path}', ex, st);
      }
    }

    final slideShow = await slideShowCreator.create(
      images: await _tempDir,
      destination: await _projectDir,
    );

    // TODO: use localized string for "project"
    final movie = Movie(
      id: projectId,
      title: 'project #$projectId',
      thumb: slideShow.thumbPath,
      video: slideShow.videoPath,
      duration: slideShow.videoDuration,
      createdAt: DateTime.now(),
    );
    await movieDao.insert(movie.toEntity());
    dispose();
    return movie;
  }

  @override
  Future<void> deleteProject() async {
    Logger.d('deleteProject $projectId');
    slideShowCreator.dispose();

    final movieEntity = await movieDao.getById(projectId);
    if (movieEntity != null) {
      await movieDao.delete(movieEntity);
    }

    dispose();
    (await _projectDir).delete(recursive: true).ignore();
  }

  @override
  Future<void> dispose() async {
    for (final media in _media) {
      File(media.path).delete().ignore();
    }
    _media.clear();
    (await _tempDir).delete(recursive: true).ignore();
  }
}
