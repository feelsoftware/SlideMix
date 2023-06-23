import 'dart:async';

import 'package:path/path.dart';
import 'package:slidemix/creation/data/media.dart';
import 'package:slidemix/creator/slideshow_orientation.dart';
import 'package:slidemix/creator/slideshow_transition.dart';
import 'package:slidemix/draft/data/dao.dart';
import 'package:slidemix/draft/data/draft_movie.dart';
import 'package:slidemix/draft/data/entity.dart';
import 'package:slidemix/logger.dart';

abstract class DraftMovieManager {
  Stream<List<DraftMovie>> getAll();

  Future<DraftMovie?> getByProjectId(int projectId);

  Future<void> createDraft(int projectId);

  Future<void> replaceMedia(int projectId, List<Media> media);

  Future<void> changeSlideDuration(int projectId, Duration duration);

  Future<void> changeTransition(int projectId, SlideShowTransition? transition);

  Future<void> changeTransitionDuration(int projectId, Duration duration);

  Future<void> changeOrientation(int projectId, SlideShowOrientation? orientation);

  Future<void> deleteDraft(int projectId);
}

class DraftMovieManagerImpl extends DraftMovieManager {
  final DraftMovieDao draftMovieDao;
  final DraftMovieMediaDao draftMovieMediaDao;

  DraftMovieManagerImpl({
    required this.draftMovieDao,
    required this.draftMovieMediaDao,
  });

  @override
  Stream<List<DraftMovie>> getAll() {
    final streamController = StreamController<List<DraftMovie>>();

    emit(dynamic _) async {
      final result = <DraftMovie>[];
      final drafts = await draftMovieDao.getAll().first;
      for (final draft in drafts) {
        final media = (await draftMovieMediaDao.getAllByProject(draft.projectId).first)
            .map((e) => Media(projectId: draft.projectId, path: e.path))
            .toList(growable: false);
        if (media.isEmpty) continue;
        result.add(
          DraftMovie(
            projectId: draft.projectId,
            media: media,
            slideDuration: draft.slideDuration,
            transition: draft.transition,
            transitionDuration: draft.transitionDuration,
            orientation: draft.orientation,
            createdAt: draft.createdAt,
          ),
        );
      }
      streamController.add(result);
    }

    final draftsSubscription = draftMovieDao.getAll().listen(emit);
    final moviesSubscription = draftMovieMediaDao.getAll().listen(emit);

    streamController.onCancel = () {
      draftsSubscription.cancel();
      moviesSubscription.cancel();
    };

    return streamController.stream;
  }

  @override
  Future<DraftMovie?> getByProjectId(int projectId) async {
    final entity = await draftMovieDao.getById(projectId);
    if (entity == null) return null;

    final media = (await draftMovieMediaDao.getAllByProject(projectId).first)
        .map((e) => Media(projectId: projectId, path: e.path))
        .toList(growable: false);
    return DraftMovie(
      projectId: projectId,
      media: media,
      slideDuration: entity.slideDuration,
      transition: entity.transition,
      transitionDuration: entity.transitionDuration,
      orientation: entity.orientation,
      createdAt: entity.createdAt,
    );
  }

  @override
  Future<void> createDraft(int projectId) async {
    Logger.d('createDraft $projectId');
    await draftMovieDao.insert(DraftMovieEntity(
      projectId: projectId,
      slideDuration: const Duration(seconds: 1),
      transition: null,
      transitionDuration: const Duration(seconds: 1),
      orientation: SlideShowOrientation.landscape,
      createdAt: DateTime.now(),
    ));
  }

  @override
  Future<void> replaceMedia(int projectId, List<Media> media) async {
    Logger.d('replaceMedia $projectId $media');

    // Remove all media
    await draftMovieMediaDao.deleteAll(
      await draftMovieMediaDao.getAllByProject(projectId).first,
    );

    // Add all media
    await draftMovieMediaDao.insertAll(
      media
          .map((e) => DraftMovieMediaEntity(
                projectId: projectId,
                path: basename(e.path),
              ))
          .toList(growable: false),
    );

    await _update(projectId, updateTransition: false);
  }

  @override
  Future<void> changeSlideDuration(int projectId, Duration duration) async {
    Logger.d('changeSlideDuration $projectId $duration');
    await _update(projectId, slideDuration: duration, updateTransition: true);
  }

  @override
  Future<void> changeTransition(int projectId, SlideShowTransition? transition) async {
    Logger.d('changeTransition $projectId $transition');
    await _update(projectId, transition: transition, updateTransition: true);
  }

  @override
  Future<void> changeTransitionDuration(int projectId, Duration duration) async {
    Logger.d('changeTransitionDuration $projectId $duration');
    await _update(projectId, transitionDuration: duration, updateTransition: true);
  }

  @override
  Future<void> changeOrientation(
    int projectId,
    SlideShowOrientation? orientation,
  ) async {
    Logger.d('changeOrientation $projectId $orientation');
    await _update(projectId, updateTransition: false, orientation: orientation);
  }

  @override
  Future<void> deleteDraft(int projectId) async {
    Logger.d('deleteDraft $projectId');

    await draftMovieDao.deleteById(projectId);
    await draftMovieMediaDao.deleteAll(
      await draftMovieMediaDao.getAllByProject(projectId).first,
    );
  }

  Future<void> _update(
    int projectId, {
    Duration? slideDuration,
    SlideShowTransition? transition,
    Duration? transitionDuration,
    required bool updateTransition,
    SlideShowOrientation? orientation,
  }) async {
    final entity = await draftMovieDao.getById(projectId);
    if (entity == null) return;

    await draftMovieDao.update(DraftMovieEntity(
      projectId: projectId,
      slideDuration: slideDuration ?? entity.slideDuration,
      transition: updateTransition ? transition : entity.transition,
      transitionDuration: transitionDuration ?? entity.transitionDuration,
      orientation: orientation ?? entity.orientation,
      createdAt: DateTime.now(),
    ));
  }
}
