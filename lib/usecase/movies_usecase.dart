import 'dart:math';

import 'package:cpmoviemaker/base/usecase.dart';
import 'package:cpmoviemaker/models/movie.dart';

abstract class MoviesUseCase extends UseCase {
  Future<List<Movie>> fetchMovies();

  Future<Movie> create(String thumb, String video);
}

class MoviesUseCaseImpl extends MoviesUseCase {
  @override
  Future<List<Movie>> fetchMovies() async {
    return List.generate(100, (index) {
      final thumb = "https://picsum.photos/id/$index/200/300";
      final title = "Movie $index";
      return Movie(index, title, thumb, null);
    });
  }

  @override
  Future<Movie> create(String thumb, String video) async {
    final id = Random.secure().nextInt(100);
    return Movie(id, "Movie $id", thumb, video);
  }
}
