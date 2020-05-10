import 'package:cpmoviemaker/models/movie.dart';
import 'package:cpmoviemaker/movies/movie_card.dart';
import 'package:flutter/material.dart';

abstract class MovieClickListener {
  void onMovieClicked(Movie movie);
}

class MoviesList extends StatelessWidget {
  final MovieClickListener _clickListener;
  final List<Movie> _movies;

  MoviesList(
      {@required MovieClickListener clickListener,
      @required List<Movie> movies})
      : _clickListener = clickListener,
        _movies = movies,
        super();

  void _onMovieClicked(Movie movie) {
    _clickListener.onMovieClicked(movie);
  }

  @override
  Widget build(BuildContext context) {
    final padding = 16.0;
    final spanCount = 2;
    final itemRatio = 156.0 / 188.0;

    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: spanCount,
            mainAxisSpacing: padding,
            crossAxisSpacing: padding,
            childAspectRatio: itemRatio),
        itemCount: _movies.length,
        padding: EdgeInsets.all(padding),
        itemBuilder: (BuildContext context, int index) {
          Movie movie = _movies[index];
          return GestureDetector(
            onTap: () {
              _onMovieClicked(movie);
            },
            child: MovieCardWidget(thumb: movie.thumb, title: movie.title),
          );
        });
  }
}
