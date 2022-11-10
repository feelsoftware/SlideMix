import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final int? id;
  final String title;
  final String thumb;
  final String video;
  final Duration duration;
  final DateTime createdAt;
  final bool isFavourite;
  final bool isDraft;

  const Movie({
    this.id,
    required this.title,
    required this.thumb,
    required this.video,
    required this.duration,
    required this.createdAt,
    this.isFavourite = false,
    this.isDraft = false,
  });

  Movie copyWith({
    int? id,
  }) {
    return Movie(
      id: id,
      title: title,
      thumb: thumb,
      video: video,
      duration: duration,
      createdAt: createdAt,
      isFavourite: isFavourite,
      isDraft: isDraft,
    );
  }

  @override
  List<Object?> get props => [id, createdAt, isFavourite, isDraft];

  @override
  String toString() {
    return 'Movie{id: $id, title: $title, thumb: $thumb, video: $video, duration: $duration, createdAt: $createdAt, isFavourite: $isFavourite, isDraft: $isDraft}';
  }
}
