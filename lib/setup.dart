import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slidemix/creation/creation_bloc.dart';
import 'package:slidemix/creator/movie_creator.dart';
import 'package:slidemix/creator/project_id_provider.dart';
import 'package:slidemix/creator/slideshow_creator.dart';
import 'package:slidemix/database.dart';
import 'package:slidemix/movies/movies_bloc.dart';
import 'package:slidemix/preview/preview_bloc.dart';
import 'package:slidemix/welcome/welcome_bloc.dart';

class Setup extends StatelessWidget {
  final AppDatabase appDatabase;
  final SharedPreferences sharedPreferences;
  final Widget child;

  const Setup({
    Key? key,
    required this.appDatabase,
    required this.sharedPreferences,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<MovieCreator>(
          create: (_) => MovieCreatorImpl(
            movieDao: appDatabase.movieDao,
            projectIdProvider: ProjectIdProviderImpl(
              sharedPreferences: sharedPreferences,
            ),
            slideShowCreator: FFmpegSlideShowCreator(),
          ),
        ),
      ],
      child: _BlocSetup(
        appDatabase: appDatabase,
        child: child,
      ),
    );
  }
}

class _BlocSetup extends StatelessWidget {
  final AppDatabase appDatabase;
  final Widget child;

  const _BlocSetup({
    Key? key,
    required this.appDatabase,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CreationBloc>(
          create: (_) => CreationBloc(
            movieCreator: RepositoryProvider.of<MovieCreator>(context),
          ),
        ),
        BlocProvider<MoviesBloc>(
          create: (_) => MoviesBloc(
            movieDao: appDatabase.movieDao,
          ),
        ),
        BlocProvider<PreviewBloc>(
          create: (_) => PreviewBloc(
            movieCreator: RepositoryProvider.of<MovieCreator>(context),
            movieDao: appDatabase.movieDao,
          ),
        ),
        BlocProvider<WelcomeBloc>(
          create: (_) => WelcomeBloc(
            movieDao: appDatabase.movieDao,
          ),
        )
      ],
      child: child,
    );
  }
}
