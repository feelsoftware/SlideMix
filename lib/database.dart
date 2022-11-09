import 'dart:async';
import 'package:floor/floor.dart';
import 'package:slidemix/creation/data/creation_dao.dart';
import 'package:slidemix/creation/data/creation_entity.dart';
import 'package:slidemix/movies/data/movie_dao.dart';
import 'package:slidemix/movies/data/movie_entity.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart';

@Database(
  version: 1,
  entities: [
    CreationEntity,
    MovieEntity,
  ],
)
abstract class AppDatabase extends FloorDatabase {
  CreationDao get creationDao;

  MovieDao get movieDao;
}
