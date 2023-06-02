// ignore_for_file: camel_case_types

import 'dart:async';
import 'package:floor/floor.dart';
import 'package:path/path.dart';
import 'package:slidemix/draft/data/dao.dart';
import 'package:slidemix/draft/data/entity.dart';
import 'package:slidemix/logger.dart';
import 'package:slidemix/movies/data/movie_dao.dart';
import 'package:slidemix/movies/data/movie_entity.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart';

@Database(
  version: 3,
  entities: [
    DraftMovieEntity,
    DraftMovieMediaEntity,
    MovieEntity,
  ],
)
// dart run build_runner build
abstract class AppDatabase extends FloorDatabase {
  static Future<AppDatabase> build() async {
    return $FloorAppDatabase
        .databaseBuilder('slidemix.db')
        .addMigrations(
          [
            _MovieMimeMigration(startVersion: 1, endVersion: 2),
            _RelativeFilePathMigration(startVersion: 2, endVersion: 3),
          ],
        )
        .addCallback(Callback(
          onCreate: (_, version) {
            Logger.d('AppDatabase created $version');
          },
          onOpen: (_) {
            Logger.d('AppDatabase opened');
          },
          onUpgrade: (_, startVersion, endVersion) {
            Logger.d('AppDatabase upgraded $startVersion $endVersion');
          },
        ))
        .build();
  }

  DraftMovieDao get draftMovieDao;

  DraftMovieMediaDao get draftMovieMediaDao;

  MovieDao get movieDao;
}

class _BaseMigration extends Migration {
  _BaseMigration(
    Type type,
    int startVersion,
    int endVersion,
    Future<void> Function(sqflite.Database database) migrate,
  ) : super(startVersion, endVersion, (database) async {
          try {
            Logger.d('Start migration [$type] $startVersion $endVersion');
            await migrate(database);
            Logger.d('End migration [$type] $startVersion $endVersion');
          } catch (ex, st) {
            Logger.e(
                'Failed to run migration [$type] $startVersion $endVersion', ex, st);
            rethrow;
          }
        });
}

/// Add column mime to [MovieEntity]
class _MovieMimeMigration extends _BaseMigration {
  _MovieMimeMigration({
    required int startVersion,
    required int endVersion,
  }) : super(
          _MovieMimeMigration,
          startVersion,
          endVersion,
          (database) async {
            database.execute(
              "ALTER TABLE ${MovieEntity.tableName} ADD `mime` TEXT NOT NULL DEFAULT 'video/avc'",
            );
          },
        );
}

class _RelativeFilePathMigration extends _BaseMigration {
  _RelativeFilePathMigration({
    required int startVersion,
    required int endVersion,
  }) : super(
          _RelativeFilePathMigration,
          startVersion,
          endVersion,
          (database) async {
            final draftCursor =
                await database.queryCursor(DraftMovieMediaEntity.tableName);
            while (await draftCursor.moveNext()) {
              final draft = draftCursor.current;
              Logger.e('draft $draft');

              final id = draft['id'] as int?;
              final path = basename(draft['path'] as String);

              await database.rawUpdate(
                'UPDATE ${DraftMovieMediaEntity.tableName} SET path = ? WHERE id = ?',
                [path, id],
              );
            }

            final movieCursor = await database.queryCursor(MovieEntity.tableName);
            while (await movieCursor.moveNext()) {
              final movie = movieCursor.current;
              Logger.e('movie $movie');

              final id = movie['id'] as int?;
              final thumb = basename(movie['thumb'] as String);
              final video = basename(movie['video'] as String);

              await database.rawUpdate(
                'UPDATE ${MovieEntity.tableName} SET thumb = ?, video = ? WHERE id = ?',
                [thumb, video, id],
              );
            }
          },
        );
}
