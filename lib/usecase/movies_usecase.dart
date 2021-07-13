import 'dart:convert';
import 'dart:io';

import 'package:com_feelsoftware_slidemix/base/usecase.dart';
import 'package:com_feelsoftware_slidemix/models/movie.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

const _CHANNEL = "com.feelsoftware.slidemix.MoviesRepositoryChannel";

const _METHOD_GET_ALL = "getAll";
const _METHOD_GET = "get"; // ignore: unused_element
const _METHOD_INSERT = "insert";
const _METHOD_DELETE = "delete"; // ignore: unused_element
const _METHOD_COUNT = "count";

const _KEY_ID = "id"; // ignore: unused_element
const _KEY_TITLE = "title";
const _KEY_THUMB = "thumb";
const _KEY_VIDEO = "video";

abstract class MoviesUseCase extends UseCase {
  Future<List<Movie>> fetchMovies();

  Future<Movie> create(String? thumb, String? video);

  Future<Directory> moviesDir();
}

class MoviesUseCaseImpl extends MoviesUseCase {
  final _channel = MethodChannel(_CHANNEL);

  @override
  Future<List<Movie>> fetchMovies() async {
    final moviesDir = (await this.moviesDir()).path;

    final response = await _channel.invokeMethod(_METHOD_GET_ALL);
    final Iterable json = jsonDecode(response);

    final List<Movie> movies = json
        .map((movie) => Movie.fromJson(movie).normalizePath(moviesDir))
        .toList();
    return Future.value(movies);
  }

  @override
  Future<Movie> create(String? thumb, String? video) async {
    final moviesDir = (await this.moviesDir()).path;

    final arguments = {
      _KEY_TITLE: await _provideTitle(),
      _KEY_THUMB: thumb!.normalizePath(moviesDir),
      _KEY_VIDEO: video!.normalizePath(moviesDir)
    };
    final response = await _channel.invokeMethod(_METHOD_INSERT, arguments);
    final json = jsonDecode(response);

    final Movie movie = Movie.fromJson(json).normalizePath(moviesDir);
    return Future.value(movie);
  }

  @override
  Future<Directory> moviesDir() async {
    final filesDir = await getApplicationDocumentsDirectory();
    return Directory(join(filesDir.path, "movies"));
  }

  Future<String> _provideTitle() async {
    final moviesCount = await _channel.invokeMethod(_METHOD_COUNT);
    return "Movie #$moviesCount";
  }
}

extension _MovieStringPathNormalizer on String {
  ///
  /// Store in DB path without this prefix [moviesDir].
  ///
  String normalizePath(String moviesDir) {
    return replaceFirst(moviesDir, "").substring(1);
  }
}

extension _MoviePathNormalizer on Movie {
  ///
  /// Append this prefix [moviesDir] to thumbnail and video.
  ///
  Movie normalizePath(String moviesDir) {
    return Movie(id, title, join(moviesDir, thumb), join(moviesDir, video));
  }
}
