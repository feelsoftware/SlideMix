import 'package:com_feelsoftware_slidemix/movies/movies_list.dart';
import 'package:com_feelsoftware_slidemix/movies/movies_viewmodel.dart';
import 'package:com_feelsoftware_slidemix/navigation.dart';
import 'package:com_feelsoftware_slidemix/widget/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:com_feelsoftware_slidemix/models/movie.dart';
import 'package:provider/provider.dart';

class MoviesScreen extends StatefulWidget {
  final MoviesViewModel _viewModel;

  MoviesScreen(this._viewModel);

  @override
  _MoviesScreenState createState() => _MoviesScreenState(_viewModel);
}

class _MoviesScreenState extends State<MoviesScreen>
    implements MovieClickListener {
  final MoviesViewModel viewModel;

  _MoviesScreenState(this.viewModel);

  @override
  void initState() {
    super.initState();
    viewModel.fetchMovies();
  }

  @override
  void dispose() {
    super.dispose();
    viewModel.dispose();
  }

  @override
  void onMovieClicked(Movie movie) {
    navigateToPreview(context, movie);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar(
        rightIcon: Image.asset("assets/images/ic_create_movie_small.png"),
        onRightIconTapped: () => navigateToCreation(context),
      ),
      body: Consumer<MoviesViewModel>(
        builder: (_, __, ___) => Container(
          child: MoviesList(this, viewModel.movies),
        ),
      ),
    );
  }
}
