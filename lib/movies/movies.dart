import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slidemix/movies/movies_bloc.dart';
import 'package:slidemix/movies/widget/movies_list.dart';
import 'package:slidemix/navigation.dart';
import 'package:slidemix/widget/toolbar.dart';

class MoviesScreen extends StatefulWidget {
  static Route<void> route() => ScreenRoute(const MoviesScreen());

  const MoviesScreen({super.key});

  @override
  MoviesScreenState createState() => MoviesScreenState();
}

class MoviesScreenState extends State<MoviesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar(
        rightIcon: Image.asset("assets/images/ic_create_movie_small.png"),
        onRightIconTapped: () {
          // TODO: navigate to movie creation flow
          BlocProvider.of<MoviesBloc>(context).createFakeMovie();
        },
      ),
      body: BlocBuilder<MoviesBloc, MoviesState>(
        builder: (context, state) {
          return MoviesList(
            state.movies,
            onMovieTap: (movie) {
              // TODO: navigate to preview
            },
            onToggleFavouriteTap: (movie) {
              BlocProvider.of<MoviesBloc>(context).toggleFavourite(movie);
            },
            onCreateMovieTap: () {
              // TODO: navigate to creation flow
              BlocProvider.of<MoviesBloc>(context).createFakeMovie();
            },
          );
        },
      ),
    );
  }
}
