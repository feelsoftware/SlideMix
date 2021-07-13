import 'package:com_feelsoftware_slidemix/models/movie.dart';
import 'package:com_feelsoftware_slidemix/movies/movie_card.dart';
import 'package:com_feelsoftware_slidemix/navigation.dart';
import 'package:flutter/material.dart';

abstract class MovieClickListener {
  void onMovieClicked(Movie movie);
}

class MoviesList extends StatelessWidget {
  final MovieClickListener _clickListener;
  final List<Movie> _movies;

  MoviesList(this._clickListener, this._movies);

  void _onCreateMovieClicked(BuildContext context) {
    navigateToCreation(context);
  }

  void _onMovieClicked(Movie movie) {
    _clickListener.onMovieClicked(movie);
  }

  @override
  Widget build(BuildContext context) {
    final padding = 16.0;
    final spanCount = 2;
    final itemRatio = 149.0 / 170.0;

    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: spanCount,
            mainAxisSpacing: padding,
            crossAxisSpacing: padding,
            childAspectRatio: itemRatio),
        itemCount: _movies.length + 1,
        padding: EdgeInsets.symmetric(
          horizontal: padding * 2,
          vertical: padding,
        ),
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return AddMovieCardWidget(() {
              _onCreateMovieClicked(context);
            });
          } else {
            Movie movie = _movies[index - 1];
            return GestureDetector(
              onTap: () {
                _onMovieClicked(movie);
              },
              child: MovieCardWidget(movie.thumb, movie.title),
            );
          }
        });
  }
}
