import 'package:flutter/material.dart';
import 'package:slidemix/movies/data/movie.dart';
import 'package:slidemix/movies/widget/movie_card.dart';

class MoviesList extends StatelessWidget {
  final List<Movie> movies;
  final Function(Movie) onMovieTap;
  final Function(Movie) onToggleFavouriteTap;
  final VoidCallback onCreateMovieTap;

  const MoviesList(
    this.movies, {
    required this.onMovieTap,
    required this.onToggleFavouriteTap,
    required this.onCreateMovieTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const padding = 16.0;
    const spanCount = 2;
    const itemRatio = 150.0 / 175.0;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: spanCount,
        mainAxisSpacing: padding,
        crossAxisSpacing: padding,
        childAspectRatio: itemRatio,
      ),
      itemCount: movies.length + 1,
      padding: const EdgeInsets.symmetric(
        horizontal: padding * 2,
        vertical: padding,
      ),
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return AddMovieCard(
            onTap: onCreateMovieTap,
          );
        } else {
          final Movie movie = movies[index - 1];
          return MovieCard(
            movie,
            onTap: onMovieTap,
            onToggleFavouriteTap: onToggleFavouriteTap,
          );
        }
      },
    );
  }
}
