import 'package:slidemix/movies/data/movie_entity.dart';
import 'package:slidemix/movies/data/movie.dart';

extension MovieMapper on Movie {
  MovieEntity toEntity() => MovieEntity(
        id: id,
        title: title,
        thumb: thumb,
        video: video,
        mime: mime,
        duration: duration.inMicroseconds,
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
        mime: mime,
        duration: Duration(microseconds: duration),
        createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
        isFavourite: isFavourite,
        isDraft: isDraft,
      );
}
