import 'package:cpmoviemaker/models/movie.dart';
import 'package:cpmoviemaker/repository/movies_repository.dart';
import 'package:flutter/cupertino.dart';

class MoviesViewModel {
  final MoviesRepository _repository;

  MoviesViewModel({@required MoviesRepository repository})
      : _repository = repository;

  Future<List<Movie>> getMovies() async {
    return await _repository.fetchMovies();
  }
}
