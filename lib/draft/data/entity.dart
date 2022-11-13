import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

@Entity(tableName: DraftMovieEntity.tableName)
class DraftMovieEntity extends Equatable {
  static const tableName = 'draft_movies';

  @primaryKey
  final int projectId;
  final int createdAt;

  const DraftMovieEntity({
    required this.projectId,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [projectId, createdAt];
}

@Entity(tableName: DraftMovieMediaEntity.tableName)
class DraftMovieMediaEntity extends Equatable {
  static const tableName = 'draft_movies_media';

  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int projectId;
  final String path;

  const DraftMovieMediaEntity({
    this.id,
    required this.projectId,
    required this.path,
  });

  @override
  List<Object?> get props => [id, projectId, path];
}
