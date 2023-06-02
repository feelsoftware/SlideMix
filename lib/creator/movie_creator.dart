import 'dart:async';

import 'package:slidemix/creator/movie_project.dart';
import 'package:slidemix/creator/project_id_provider.dart';
import 'package:slidemix/creator/slideshow_creator.dart';
import 'package:slidemix/draft/draft_movie_manager.dart';
import 'package:slidemix/file_manager.dart';
import 'package:slidemix/logger.dart';
import 'package:slidemix/movies/data/movie.dart';
import 'package:slidemix/movies/data/movie_dao.dart';

abstract class MovieCreator {
  Future<MovieProject> newProject();

  Future<MovieProject?> openDraft(Movie draftMovie);

  Future<void> deleteProject(Movie movie);
}

class MovieCreatorImpl extends MovieCreator {
  final DraftMovieManager draftMovieManager;
  final FileManager fileManager;
  final MovieDao movieDao;
  final ProjectIdProvider projectIdProvider;
  final SlideShowCreator slideShowCreator;

  MovieCreatorImpl({
    required this.draftMovieManager,
    required this.fileManager,
    required this.movieDao,
    required this.projectIdProvider,
    required this.slideShowCreator,
  });

  @override
  Future<MovieProject> newProject() async {
    final projectId = await projectIdProvider.provideProjectId();
    final project = MovieProjectImpl(
      projectId: projectId,
      draftMovieManager: draftMovieManager,
      fileManager: fileManager,
      movieDao: movieDao,
      slideShowCreator: slideShowCreator,
    );
    await project.init();
    return project;
  }

  @override
  Future<MovieProject> openDraft(Movie draftMovie) async {
    final project = MovieProjectImpl(
      projectId: draftMovie.id,
      draftMovieManager: draftMovieManager,
      fileManager: fileManager,
      movieDao: movieDao,
      slideShowCreator: slideShowCreator,
    );
    await project.init(draftMovie: draftMovie);
    return project;
  }

  @override
  Future<void> deleteProject(Movie movie) async {
    Logger.d('deleteProject ${movie.id}');
    await MovieProjectImpl(
      projectId: movie.id,
      draftMovieManager: draftMovieManager,
      fileManager: fileManager,
      movieDao: movieDao,
      slideShowCreator: slideShowCreator,
    ).deleteProject();
  }
}
