import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';
import 'package:slidemix/creator/slideshow_orientation.dart';
import 'package:slidemix/creator/slideshow_transition.dart';

@Entity(tableName: DraftMovieEntity.tableName)
class DraftMovieEntity extends Equatable {
  static const tableName = 'draft_movies';

  @primaryKey
  final int projectId;
  final Duration slideDuration;
  final SlideShowTransition? transition;
  final Duration transitionDuration;
  final SlideShowOrientation orientation;
  final DateTime createdAt;

  const DraftMovieEntity({
    required this.projectId,
    required this.slideDuration,
    required this.transition,
    required this.transitionDuration,
    required this.orientation,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        projectId,
        slideDuration,
        transition,
        transitionDuration,
        orientation,
        createdAt
      ];
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
