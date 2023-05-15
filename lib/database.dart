// ignore_for_file: camel_case_types

import 'dart:async';
import 'package:floor/floor.dart';
import 'package:slidemix/draft/data/dao.dart';
import 'package:slidemix/draft/data/entity.dart';
import 'package:slidemix/movies/data/movie_dao.dart';
import 'package:slidemix/movies/data/movie_entity.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart';

@Database(
  version: 2,
  entities: [
    DraftMovieEntity,
    DraftMovieMediaEntity,
    MovieEntity,
  ],
)
// flutter packages pub run build_runner build
abstract class AppDatabase extends FloorDatabase {
  static Future<AppDatabase> build() async {
    return $FloorAppDatabase.databaseBuilder('slidemix.db').addMigrations(
      [
        _MovieMimeMigration(startVersion: 1, endVersion: 2),
      ],
    ).build();
  }

  DraftMovieDao get draftMovieDao;

  DraftMovieMediaDao get draftMovieMediaDao;

  MovieDao get movieDao;
}

/// Add column mime to [MovieEntity]
class _MovieMimeMigration extends Migration {
  _MovieMimeMigration({
    required int startVersion,
    required int endVersion,
  }) : super(startVersion, endVersion, (sqflite.Database database) async {
          database.execute(
            "ALTER TABLE ${MovieEntity.tableName} ADD `mime` TEXT NOT NULL DEFAULT 'video/avc'",
          );
        });
}
