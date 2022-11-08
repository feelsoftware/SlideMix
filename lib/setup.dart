import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slidemix/database.dart';
import 'package:slidemix/movies/movies_bloc.dart';
import 'package:slidemix/welcome/welcome_bloc.dart';

class Setup extends StatelessWidget {
  final AppDatabase appDatabase;
  final Widget child;

  const Setup({
    Key? key,
    required this.appDatabase,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MoviesBloc>(
          create: (_) => MoviesBloc(
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
