import 'dart:async';

import 'package:slidemix/creator/movie_project.dart';
import 'package:slidemix/creator/project_id_provider.dart';
import 'package:slidemix/creator/slideshow_creator.dart';
import 'package:slidemix/logger.dart';
import 'package:slidemix/movies/data/movie.dart';
import 'package:slidemix/movies/data/movie_dao.dart';

abstract class MovieCreator {
  Future<MovieProject> newProject();

  Future<void> deleteProject(Movie movie);
}

class MovieCreatorImpl extends MovieCreator {
  final MovieDao movieDao;
  final ProjectIdProvider projectIdProvider;
  final SlideShowCreator slideShowCreator;

  MovieCreatorImpl({
    required this.movieDao,
    required this.projectIdProvider,
    required this.slideShowCreator,
  });

  @override
  Future<MovieProject> newProject() async {
    final projectId = await projectIdProvider.provideProjectId();
    return MovieProjectImpl(
      projectId: projectId,
      movieDao: movieDao,
      slideShowCreator: slideShowCreator,
    );
  }

  @override
  Future<void> deleteProject(Movie movie) async {
    Logger.d('deleteProject ${movie.id}');
    await MovieProjectImpl(
      projectId: movie.id,
      movieDao: movieDao,
      slideShowCreator: slideShowCreator,
    ).deleteProject();
  }
}
