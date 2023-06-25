import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:slidemix/creation/data/media.dart';
import 'package:slidemix/creator/slideshow_creator.dart';
import 'package:slidemix/creator/slideshow_orientation.dart';
import 'package:slidemix/creator/slideshow_resize.dart';
import 'package:slidemix/creator/slideshow_transition.dart';
import 'package:slidemix/draft/draft_movie_manager.dart';
import 'package:slidemix/file_manager.dart';
import 'package:slidemix/localizations.dart';
import 'package:slidemix/logger.dart';
import 'package:slidemix/movies/data/movie.dart';
import 'package:slidemix/movies/data/movie_dao.dart';
import 'package:slidemix/movies/data/movie_mapper.dart';

abstract class MovieProject {
  int get id;

  List<Media> get media;

  Future<List<Media>> attachMedia(Iterable<Media> media);

  Future<List<Media>> deleteMedia(Media media);

  Duration get slideDuration;

  Future<Duration> changeSlideDuration(Duration duration);

  SlideShowTransition? get transition;

  Future<SlideShowTransition?> changeTransition(SlideShowTransition? transition);

  Duration get transitionDuration;

  Future<Duration> changeTransitionDuration(Duration duration);

  SlideShowOrientation get orientation;

  Future<SlideShowOrientation> changeOrientation(SlideShowOrientation orientation);

  SlideShowResize get resize;

  Future<SlideShowResize> changeResize(SlideShowResize resize);

  Future<Movie> createMovie({
    required Function(double progress) onProgress,
  });

  Future<void> deleteProject();

  Future<void> dispose({required bool deleteDraft});
}

class MovieProjectImpl extends MovieProject {
  final int projectId;
  final DraftMovieManager draftMovieManager;
  final FileManager fileManager;
  final MovieDao movieDao;
  final SlideShowCreator slideShowCreator;

  MovieProjectImpl({
    required this.projectId,
    required this.draftMovieManager,
    required this.fileManager,
    required this.movieDao,
    required this.slideShowCreator,
  });

  @override
  int get id => projectId;

  Future<void> init({Movie? draftMovie}) async {
    if (draftMovie == null) {
      await draftMovieManager.createDraft(projectId);
    } else {
      final draft = await draftMovieManager.getByProjectId(projectId);
      if (draft == null) {
        await draftMovieManager.createDraft(projectId);
      } else {
        _media.addAll(draft.media);
        slideDuration = draft.slideDuration;
        transition = draft.transition;
        transitionDuration = draft.transitionDuration;
        orientation = draft.orientation;
      }
    }
  }

  final List<Media> _media = <Media>[];

  @override
  List<Media> get media => List.unmodifiable(_media);

  @override
  Future<List<Media>> attachMedia(Iterable<Media> media) async {
    Logger.d('attachMedia $projectId $media');

    // imagePicker stores files in cacheDir, it has a specific TTL
    // Move files to dir with longer TTL to keep those files as long as we want to
    _media.addAll(await fileManager.copyToDraftDir(projectId, media));

    draftMovieManager.replaceMedia(projectId, _media);
    return this.media;
  }

  @override
  Future<List<Media>> deleteMedia(Media media) async {
    Logger.d('deleteMedia $projectId $media');
    _media.remove(media);
    File(media.path).delete().ignore();
    draftMovieManager.replaceMedia(projectId, _media).ignore();
    return this.media;
  }

  @override
  Duration slideDuration = const Duration(seconds: 1);

  @override
  Future<Duration> changeSlideDuration(Duration duration) async {
    slideDuration = duration;
    draftMovieManager.changeSlideDuration(projectId, duration).ignore();
    return duration;
  }

  @override
  SlideShowTransition? transition;

  @override
  Future<SlideShowTransition?> changeTransition(SlideShowTransition? transition) async {
    this.transition = transition;
    draftMovieManager.changeTransition(projectId, transition).ignore();
    return transition;
  }

  @override
  Duration transitionDuration = const Duration(seconds: 1);

  @override
  Future<Duration> changeTransitionDuration(Duration duration) async {
    transitionDuration = duration;
    draftMovieManager.changeTransitionDuration(projectId, duration).ignore();
    return duration;
  }

  @override
  SlideShowOrientation orientation = SlideShowOrientation.landscape;

  @override
  Future<SlideShowOrientation> changeOrientation(
    SlideShowOrientation orientation,
  ) async {
    this.orientation = orientation;
    draftMovieManager.changeOrientation(projectId, orientation).ignore();
    return orientation;
  }

  @override
  SlideShowResize resize = SlideShowResize.contain;

  @override
  Future<SlideShowResize> changeResize(SlideShowResize resize) async {
    this.resize = resize;
    draftMovieManager.changeResize(projectId, resize).ignore();
    return resize;
  }

  @override
  Future<Movie> createMovie({
    required Function(double progress) onProgress,
  }) async {
    Logger.d('createMovie $projectId');

    final mediaWithUpdatedPath =
        await fileManager.normalizeForCreation(projectId, media);

    _media.clear();
    _media.addAll(mediaWithUpdatedPath);
    draftMovieManager.replaceMedia(projectId, _media);

    final slideShow = await slideShowCreator.create(
      images: fileManager.draftDir(projectId),
      destination: fileManager.projectDir(projectId),
      slideDuration: slideDuration,
      transition: transition,
      transitionDuration: transitionDuration,
      orientation: orientation,
      resize: resize,
      onProgress: onProgress,
    );

    final movie = Movie(
      id: projectId,
      title: AppLocalizations.app()?.projectTitle(projectId) ?? 'project #$projectId',
      thumb: basename(slideShow.thumbPath),
      video: basename(slideShow.videoPath),
      mime: slideShow.mime,
      duration: slideShow.videoDuration,
      createdAt: DateTime.now(),
    );
    await movieDao.insert(movie.toEntity());
    dispose(deleteDraft: true);
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

    dispose(deleteDraft: true);
    fileManager.deleteProject(projectId).ignore();
  }

  @override
  Future<void> dispose({required bool deleteDraft}) async {
    slideShowCreator.dispose();
    if (!deleteDraft) return;
    _media.clear();
    fileManager.deleteDraft(projectId).ignore();
    await draftMovieManager.deleteDraft(projectId);
  }
}
