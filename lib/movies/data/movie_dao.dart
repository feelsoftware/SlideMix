import 'package:floor/floor.dart';
import 'package:slidemix/movies/data/movie_entity.dart';

@dao
abstract class MovieDao {
  @Query('SELECT * FROM MovieEntity ORDER BY createdAt DESC')
  Stream<List<MovieEntity>> getAll();

  @Query('SELECT * FROM MovieEntity WHERE id = :id')
  Future<MovieEntity?> getMovieById(int id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertMovie(MovieEntity movie);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateMovie(MovieEntity movie);

  @delete
  Future<void> deleteMovie(MovieEntity movie);
}
