import 'dart:convert';
import 'dart:math';

import 'package:cpmoviemaker/base/usecase.dart';
import 'package:cpmoviemaker/models/movie.dart';
import 'package:flutter/services.dart';

const _CHANNEL = "com.vitoksmile.cpmoviemaker.MoviesRepositoryChannel";

const _METHOD_GET_ALL = "getAll";
const _METHOD_GET = "get";
const _METHOD_INSERT = "insert";
const _METHOD_DELETE = "delete";

const _KEY_ID = "id";
const _KEY_TITLE = "title";
const _KEY_THUMB = "thumb";
const _KEY_VIDEO = "video";

abstract class MoviesUseCase extends UseCase {
  Future<List<Movie>> fetchMovies();

  Future<Movie> create(String thumb, String video);
}

class MoviesUseCaseImpl extends MoviesUseCase {
  final _channel = MethodChannel(_CHANNEL);

  @override
  Future<List<Movie>> fetchMovies() async {
    final response = await _channel.invokeMethod(_METHOD_GET_ALL);
    final Iterable json = jsonDecode(response);

    final List<Movie> movies =
        json.map((item) => Movie.fromJson(item)).toList();
    return Future.value(movies);
  }

  @override
  Future<Movie> create(String thumb, String video) async {
    final arguments = {
      _KEY_TITLE: "title ${Random.secure().nextInt(100)}",
      _KEY_THUMB: thumb,
      _KEY_VIDEO: video
    };
    final response = await _channel.invokeMethod(_METHOD_INSERT, arguments);
    final json = jsonDecode(response);

    final Movie movie = Movie.fromJson(json);
    return Future.value(movie);
  }
}
