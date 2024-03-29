import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slidemix/creation/creation_bloc.dart';
import 'package:slidemix/creator/ffmpeg/ffmpeg_slideshow_creator.dart';
import 'package:slidemix/creator/movie_creator.dart';
import 'package:slidemix/creator/project_id_provider.dart';
import 'package:slidemix/creator/video_capability.dart';
import 'package:slidemix/database.dart';
import 'package:slidemix/draft/draft_movie_manager.dart';
import 'package:slidemix/file_manager.dart';
import 'package:slidemix/movies/movies_bloc.dart';
import 'package:slidemix/preview/preview_bloc.dart';
import 'package:slidemix/welcome/welcome_bloc.dart';

class Setup extends StatelessWidget {
  final AppDatabase appDatabase;
  final FileManager fileManager;
  final SharedPreferences sharedPreferences;
  final Widget child;

  const Setup({
    Key? key,
    required this.appDatabase,
    required this.fileManager,
    required this.sharedPreferences,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<DraftMovieManager>(
          create: (_) => DraftMovieManagerImpl(
            draftMovieDao: appDatabase.draftMovieDao,
            draftMovieMediaDao: appDatabase.draftMovieMediaDao,
          ),
        ),
        RepositoryProvider<FileManager>(
          create: (_) => fileManager,
        ),
        RepositoryProvider<MovieCreator>(
          create: (_) => MovieCreatorImpl(
            draftMovieManager: DraftMovieManagerImpl(
              draftMovieDao: appDatabase.draftMovieDao,
              draftMovieMediaDao: appDatabase.draftMovieMediaDao,
            ),
            fileManager: fileManager,
            movieDao: appDatabase.movieDao,
            projectIdProvider: ProjectIdProviderImpl(
              sharedPreferences: sharedPreferences,
            ),
            slideShowCreator: FFmpegSlideShowCreator(
              videoCapabilityProvider: VideoCapabilityProvider(),
            ),
          ),
        ),
      ],
      child: _BlocSetup(
        appDatabase: appDatabase,
        fileManager: fileManager,
        child: child,
      ),
    );
  }
}

class _BlocSetup extends StatelessWidget {
  final AppDatabase appDatabase;
  final FileManager fileManager;
  final Widget child;

  const _BlocSetup({
    Key? key,
    required this.appDatabase,
    required this.fileManager,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CreationBloc>(
          create: (_) => CreationBloc(
            draftMovieManager: RepositoryProvider.of<DraftMovieManager>(context),
            movieCreator: RepositoryProvider.of<MovieCreator>(context),
            movieDao: appDatabase.movieDao,
          ),
        ),
        BlocProvider<MoviesBloc>(
          create: (_) => MoviesBloc(
            draftMovieManager: RepositoryProvider.of<DraftMovieManager>(context),
            fileManager: fileManager,
            movieDao: appDatabase.movieDao,
          ),
        ),
        BlocProvider<PreviewBloc>(
          create: (_) => PreviewBloc(
            draftMovieManager: RepositoryProvider.of<DraftMovieManager>(context),
            movieCreator: RepositoryProvider.of<MovieCreator>(context),
            movieDao: appDatabase.movieDao,
          ),
        ),
        BlocProvider<WelcomeBloc>(
          create: (_) => WelcomeBloc(
            draftMovieManager: RepositoryProvider.of<DraftMovieManager>(context),
            movieDao: appDatabase.movieDao,
          ),
        )
      ],
      child: child,
    );
  }
}
