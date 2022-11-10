import 'package:floor/floor.dart';
import 'package:floor/floor.dart' as floor;
import 'package:slidemix/movies/data/movie_entity.dart';

@dao
abstract class MovieDao {
  @Query('SELECT * FROM ${MovieEntity.tableName} ORDER BY createdAt DESC')
  Stream<List<MovieEntity>> getAll();

  @Query('SELECT * FROM ${MovieEntity.tableName} WHERE id = :id')
  Future<MovieEntity?> getById(int id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insert(MovieEntity movie);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> update(MovieEntity movie);

  @floor.delete
  Future<void> delete(MovieEntity movie);
}
