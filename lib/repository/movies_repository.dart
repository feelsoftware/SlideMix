import 'package:cpmoviemaker/models/movie.dart';

abstract class MoviesRepository {
  Future<List<Movie>> fetchMovies();
}

class MoviesRepositoryImpl implements MoviesRepository {
  @override
  Future<List<Movie>> fetchMovies() async {
    return List.generate(100, (index) {
      String thumb = "https://picsum.photos/id/$index/200/300";
      String title = "Movie $index";
      return Movie(index, title, thumb);
    });
  }
}
