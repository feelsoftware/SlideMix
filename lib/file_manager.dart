import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:slidemix/creation/data/media.dart';
import 'package:slidemix/draft/data/draft_movie.dart';
import 'package:slidemix/logger.dart';
import 'package:slidemix/movies/data/movie.dart';

abstract interface class FileManager {
  static FileManager of(BuildContext context) => RepositoryProvider.of(context);

  Future<void> init();

  Directory draftDir(int projectId);

  Directory projectDir(int projectId);

  File getThumb(Movie movie);

  File getVideo(Movie movie);

  File getThumbFromDraft(DraftMovie draft);

  File getThumbFromDraftMedia(Media media);

  /// imagePicker stores files in cacheDir, it has a specific TTL
  /// Move files to dir with longer TTL to keep those files as long as we want to
  Future<Iterable<Media>> copyToDraftDir(int projectId, Iterable<Media> media);

  /// Normalize image names for FFmpeg
  Future<Iterable<Media>> normalizeForCreation(int projectId, Iterable<Media> media);

  Future<void> deleteProject(int projectId);

  Future<void> deleteDraft(int projectId);
}

class FileManagerImpl implements FileManager {
  late Directory _dir;

  @override
  Future<void> init() async {
    _dir = await getApplicationDocumentsDirectory();
  }

  @override
  Directory draftDir(int projectId) {
    return Directory(_buildPath(_dir, 'project${projectId}_temp'));
  }

  @override
  Directory projectDir(int projectId) {
    return Directory(_buildPath(_dir, 'project$projectId'));
  }

  @override
  File getThumb(Movie movie) {
    if (movie.isDraft) {
      return File(movie.thumb);
    }

    return File(_buildPath(projectDir(movie.id), movie.thumb));
  }

  @override
  File getVideo(Movie movie) {
    return File(_buildPath(projectDir(movie.id), movie.video));
  }

  @override
  File getThumbFromDraft(DraftMovie draft) {
    return getThumbFromDraftMedia(draft.media.first);
  }

  @override
  File getThumbFromDraftMedia(Media media) {
    return File(_buildPath(draftDir(media.projectId), media.path));
  }

  @override
  Future<Iterable<Media>> copyToDraftDir(int projectId, Iterable<Media> media) async {
    final result = <Media>[];

    final dir = draftDir(projectId);
    await dir.create();
    for (final source in media) {
      final newPath = await _moveFile(
        source: source.path,
        newPath: _buildPath(dir, source.path),
      );
      if (newPath == null) continue;
      result.add(Media(
        projectId: projectId,
        // We care here only about relative path
        path: basename(newPath),
      ));
    }

    return result;
  }

  @override
  Future<Iterable<Media>> normalizeForCreation(
    int projectId,
    Iterable<Media> media,
  ) async {
    final result = <Media>[];
    final format = NumberFormat('000');

    var index = 0;
    final dir = draftDir(projectId);
    for (final source in media) {
      final newPath = await _moveFile(
        source: _buildPath(dir, source.path),
        newPath: _buildPath(dir, 'image${format.format(index++)}.jpg'),
      );
      if (newPath == null) continue;
      result.add(Media(
        projectId: projectId,
        // We care here only about relative path
        path: basename(newPath),
      ));
    }

    return result;
  }

  @override
  Future<void> deleteProject(int projectId) async {
    await projectDir(projectId).delete(recursive: true);
  }

  @override
  Future<void> deleteDraft(int projectId) async {
    await draftDir(projectId).delete(recursive: true);
  }

  /// @return `null` when [source] can't be moved to the new path [newPath]
  Future<String?> _moveFile({
    required String source,
    required String newPath,
  }) async {
    if (source == newPath) return newPath;

    Logger.d('Move file from "$source" to "$newPath"');
    final file = File(source);
    try {
      await file.rename(newPath);
      Logger.d('Moved file to tempDir, $newPath');
      return newPath;
    } catch (ex, st) {
      Logger.e('Failed to move file to tempDir, ${file.path}', ex, st);
      try {
        // If rename fails, copy the source file and then delete it
        await file.copy(newPath);
        file.delete().ignore();
        Logger.d('Moved file to tempDir with fallback, $newPath');
        return newPath;
      } catch (ex, st) {
        Logger.e('Failed to moved file to tempDir with fallback, $source', ex, st);
        return source;
      }
    }
  }

  String _buildPath(Directory dir, String file) =>
      "${dir.path}${Platform.pathSeparator}${basename(file)}";
}