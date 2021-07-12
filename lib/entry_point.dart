import 'package:cpmoviemaker/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'movies/movies_viewmodel.dart';

class EntryPointScreen extends StatefulWidget {
  final MoviesViewModel _viewModel;

  EntryPointScreen(this._viewModel);

  @override
  State<StatefulWidget> createState() => _EntryPointStateScreen(_viewModel);
}

class _EntryPointStateScreen extends State<EntryPointScreen> {
  final MoviesViewModel viewModel;

  _EntryPointStateScreen(this.viewModel);

  @override
  void initState() {
    super.initState();
    viewModel.fetchMovies();
    viewModel.addListener(() {
      if (viewModel.movies.isNotEmpty) {
        navigateToMovies(context);
      } else {
        navigateToWelcome(context);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    viewModel.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
        color: Colors.white,
      );
}
