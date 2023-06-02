import 'dart:async';

import 'package:path/path.dart';
import 'package:slidemix/creation/data/media.dart';
import 'package:slidemix/draft/data/dao.dart';
import 'package:slidemix/draft/data/draft_movie.dart';
import 'package:slidemix/draft/data/entity.dart';
import 'package:slidemix/logger.dart';

abstract class DraftMovieManager {
  Stream<List<DraftMovie>> getAll();

  Future<DraftMovie?> getByProjectId(int projectId);

  Future<void> createDraft(int projectId);

  Future<void> replaceMedia(int projectId, List<Media> media);

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
            createdAt: DateTime.fromMillisecondsSinceEpoch(draft.createdAt),
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
      createdAt: DateTime.fromMillisecondsSinceEpoch(entity.createdAt),
    );
  }

  @override
  Future<void> createDraft(int projectId) async {
    Logger.d('createDraft $projectId');
    await draftMovieDao.insert(DraftMovieEntity(
      projectId: projectId,
      createdAt: DateTime.now().millisecondsSinceEpoch,
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
  }

  @override
  Future<void> deleteDraft(int projectId) async {
    Logger.d('deleteDraft $projectId');

    await draftMovieDao.deleteById(projectId);
    await draftMovieMediaDao.deleteAll(
      await draftMovieMediaDao.getAllByProject(projectId).first,
    );
  }
}
