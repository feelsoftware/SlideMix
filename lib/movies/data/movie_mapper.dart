import 'package:slidemix/movies/data/movie_entity.dart';
import 'package:slidemix/movies/data/movie.dart';

extension MovieMapper on Movie {
  MovieEntity toEntity() => MovieEntity(
        id: id,
        title: title,
        thumb: thumb,
        video: video,
        createdAt: createdAt.millisecondsSinceEpoch,
        isFavourite: isFavourite,
        isDraft: isDraft,
      );
}

extension MovieEntityMapper on MovieEntity {
  Movie toMovie() => Movie(
        id: id,
        title: title,
        thumb: thumb,
        video: video,
        createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
        isFavourite: isFavourite,
        isDraft: isDraft,
      );
}
