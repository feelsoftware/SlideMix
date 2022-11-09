import 'package:floor/floor.dart';
import 'package:slidemix/creation/data/creation_entity.dart';

// TODO: do we actually need CreationDao?
@dao
abstract class CreationDao {
  @Query('SELECT * FROM ${CreationEntity.tableName}')
  Future<List<CreationEntity>> getAll();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insert(CreationEntity entity);
}
