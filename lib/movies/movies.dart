import 'dart:async';

import 'package:cpmoviemaker/movies/movies_list.dart';
import 'package:cpmoviemaker/movies/movies_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:cpmoviemaker/models/movie.dart';

class MoviesScreen extends StatefulWidget {
  final MoviesViewModel _viewModel;
  final String _title;

  MoviesScreen(
      {Key key, @required MoviesViewModel viewModel, @required String title})
      : _viewModel = viewModel,
        _title = title,
        super(key: key);

  @override
  _MoviesScreenState createState() => _MoviesScreenState(_viewModel, _title);
}

class _MoviesScreenState extends State<MoviesScreen>
    implements MovieClickListener {
  final MoviesViewModel viewModel;
  final String title;

  List<Movie> movies = List<Movie>();
  StreamSubscription<List<Movie>> moviesSubscription;

  _MoviesScreenState(this.viewModel, this.title);

  @override
  void initState() {
    super.initState();
    moviesSubscription = viewModel.getMovies().asStream().listen((list) {
      setState(() {
        movies.addAll(list);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    moviesSubscription?.cancel();
  }

  @override
  void onMovieClicked(Movie movie) {
    // TODO: navigate to PreviewScreen
  }

  void _navigateToCreation() {
    // TODO: navigate to MovieCreationScreen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: MoviesList(
        clickListener: this,
        movies: movies,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreation,
        tooltip: "Create a new movie",
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
