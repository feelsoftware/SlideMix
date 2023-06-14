import 'package:floor/floor.dart';
import 'package:floor/floor.dart' as floor;
import 'package:slidemix/draft/data/entity.dart';

@dao
abstract class DraftMovieDao {
  @Query("SELECT * FROM ${DraftMovieEntity.tableName} ORDER BY createdAt DESC")
  Stream<List<DraftMovieEntity>> getAll();

  @Query("SELECT * FROM ${DraftMovieEntity.tableName} WHERE projectId = :projectId")
  Future<DraftMovieEntity?> getById(int projectId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insert(DraftMovieEntity draft);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> update(DraftMovieEntity draft);

  @Query("DELETE FROM ${DraftMovieEntity.tableName} WHERE projectId = :projectId")
  Future<void> deleteById(int projectId);
}

@dao
abstract class DraftMovieMediaDao {
  @Query('SELECT * FROM ${DraftMovieMediaEntity.tableName}')
  Stream<List<DraftMovieMediaEntity>> getAll();

  @Query(
    'SELECT * FROM ${DraftMovieMediaEntity.tableName} WHERE projectId = :projectId',
  )
  Stream<List<DraftMovieMediaEntity>> getAllByProject(int projectId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAll(List<DraftMovieMediaEntity> media);

  @floor.delete
  Future<void> deleteAll(List<DraftMovieMediaEntity> media);
}
