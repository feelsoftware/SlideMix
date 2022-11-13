// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slidemix/creation/creation.dart';
import 'package:slidemix/movies/movies_bloc.dart';
import 'package:slidemix/movies/widget/movies_list.dart';
import 'package:slidemix/navigation.dart';
import 'package:slidemix/preview/preview.dart';
import 'package:slidemix/widget/toolbar.dart';

class MoviesScreen extends StatefulWidget {
  static Route<void> route() => ScreenRoute(const MoviesScreen._());

  const MoviesScreen._({Key? key}) : super(key: key);

  @override
  _MoviesScreenState createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar(
        rightIcon: Image.asset("assets/images/ic_create_movie_small.png"),
        onRightIconTapped: () => Navigator.of(context).push(CreationScreen.route()),
      ),
      body: BlocBuilder<MoviesBloc, MoviesState>(
        builder: (context, state) {
          return MoviesList(
            state.movies,
            onMovieTap: (movie) {
              if (movie.isDraft) {
                Navigator.of(context).push(CreationScreen.route(draftMovie: movie));
              } else {
                Navigator.of(context).push(PreviewScreen.route(movie));
              }
            },
            onToggleFavouriteTap: (movie) {
              BlocProvider.of<MoviesBloc>(context).toggleFavourite(movie);
            },
            onCreateMovieTap: () {
              Navigator.of(context).push(CreationScreen.route());
            },
          );
        },
      ),
    );
  }
}
