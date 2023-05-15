import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final int id;
  final String title;
  final String thumb;
  final String video;
  final String mime;
  final Duration duration;
  final DateTime createdAt;
  final bool isFavourite;
  final bool isDraft;

  const Movie({
    required this.id,
    required this.title,
    required this.thumb,
    required this.video,
    required this.mime,
    required this.duration,
    required this.createdAt,
    this.isFavourite = false,
    this.isDraft = false,
  });

  @override
  List<Object?> get props => [id, createdAt, isFavourite, isDraft];

  @override
  String toString() {
    return 'Movie{id: $id, title: $title, thumb: $thumb, video: $video, mime: $mime, duration: $duration, createdAt: $createdAt, isFavourite: $isFavourite, isDraft: $isDraft}';
  }
}
