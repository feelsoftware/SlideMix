import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final int id;
  final String title;
  final String thumb;
  final String video;
  final DateTime createdAt;
  final bool isFavourite;
  final bool isDraft;

  const Movie({
    required this.id,
    required this.title,
    required this.thumb,
    required this.video,
    required this.createdAt,
    required this.isFavourite,
    required this.isDraft,
  });

  @override
  List<Object?> get props => [id, createdAt];

  @override
  String toString() {
    return 'Movie{id: $id, title: $title, thumb: $thumb, video: $video, createdAt: $createdAt, isFavourite: $isFavourite, isDraft: $isDraft}';
  }
}
