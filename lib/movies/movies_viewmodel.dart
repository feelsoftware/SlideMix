import 'package:cpmoviemaker/models/movie.dart';
import 'package:cpmoviemaker/repository/movies_repository.dart';

class MoviesViewModel {
  final MoviesRepository _repository;

  MoviesViewModel(this._repository);

  Future<List<Movie>> getMovies() async {
    return await _repository.fetchMovies();
  }
}
