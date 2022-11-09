import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';
import 'package:flutter/foundation.dart';

@Entity(tableName: MovieEntity.tableName)
@immutable
class MovieEntity extends Equatable {
  static const tableName = 'movies';

  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String title;
  final String thumb;
  final String video;
  final int duration;
  final int createdAt;
  final bool isFavourite;
  final bool isDraft;

  const MovieEntity({
    this.id,
    required this.title,
    required this.thumb,
    required this.video,
    required this.duration,
    required this.createdAt,
    required this.isFavourite,
    required this.isDraft,
  });

  MovieEntity copyWith({
    bool? isFavourite,
  }) {
    return MovieEntity(
      id: id,
      title: title,
      thumb: thumb,
      video: video,
      duration: duration,
      createdAt: createdAt,
      isFavourite: isFavourite ?? this.isFavourite,
      isDraft: isDraft,
    );
  }

  @override
  List<Object?> get props => [id];

  @override
  String toString() {
    return 'MovieEntity{id: $id, title: $title, thumb: $thumb, video: $video, duration: $duration, createdAt: $createdAt, isFavourite: $isFavourite, isDraft: $isDraft}';
  }
}
