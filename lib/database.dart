import 'dart:async';
import 'package:floor/floor.dart';
import 'package:slidemix/movies/data/movie_dao.dart';
import 'package:slidemix/movies/data/movie_entity.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart';

@Database(
  version: 1,
  entities: [
    MovieEntity,
  ],
)
abstract class AppDatabase extends FloorDatabase {
  MovieDao get movieDao;
}
