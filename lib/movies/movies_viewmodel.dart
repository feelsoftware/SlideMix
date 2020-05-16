import 'package:cpmoviemaker/models/movie.dart';
import 'package:cpmoviemaker/usecase/movies_usecase.dart';

class MoviesViewModel {
  final MoviesUseCase _useCase;

  MoviesViewModel(this._useCase);

  Future<List<Movie>> getMovies() async {
    return await _useCase.fetchMovies();
  }
}
