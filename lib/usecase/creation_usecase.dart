import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cpmoviemaker/base/usecase.dart';
import 'package:cpmoviemaker/models/movie.dart';
import 'package:cpmoviemaker/usecase/movies_usecase.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart';

const _CHANNEL = "com.vitoksmile.cpmoviemaker.MovieCreatorChannel";
const _METHOD_CREATE = "METHOD_CREATE";
const _METHOD_CANCEL = "METHOD_CANCEL";

const _KEY_OUTPUT_DIR = "KEY_OUTPUT_DIR";
const _KEY_SCENES_DIR = "KEY_SCENES_DIR";

const _KEY_TYPE = "type";
const _TYPE_SUCCESS =
    "com.vitoksmile.cpmoviemaker.model.MovieCreatorResult.Success";
const _KEY_THUMB = "thumb";
const _KEY_MOVIE = "movie";
const _KEY_ERROR_MESSAGE = "message";

abstract class CreationUseCase extends UseCase {
  Future<T> createMovie<T extends CreationResult>(List<File> files);
}

class CreationUseCaseImpl extends CreationUseCase {
  final _channel = MethodChannel(_CHANNEL);
  final MoviesUseCase _moviesUseCase;

  CreationUseCaseImpl(this._moviesUseCase);

  @override
  Future<T> createMovie<T extends CreationResult>(List<File> files) async {
    final moviesDir = await _moviesUseCase.moviesDir();
    await moviesDir.create(recursive: true);
    final scenesDir = Directory(join(moviesDir.path, "scenes"));
    await scenesDir.create(recursive: true);

    var index = 0;
    await Future.forEach(files, (file) async {
      final path = file.path;
      final newPath = join(scenesDir.path, "image00${index++}.jpg");
      await FlutterImageCompress.compressAndGetFile(path, newPath,
          quality: 100, keepExif: true);
      print("file copied from $path to $newPath");
    });

    final arguments = {
      _KEY_OUTPUT_DIR: moviesDir.path,
      _KEY_SCENES_DIR: scenesDir.path
    };
    final response = await _channel.invokeMethod(_METHOD_CREATE, arguments);
    final Map<String, dynamic> map = jsonDecode(response);

    CreationResult result;
    final String type = map[_KEY_TYPE];

    if (type == _TYPE_SUCCESS) {
      final thumbPath = map[_KEY_THUMB];
      final moviePath = map[_KEY_MOVIE];

      final movie = await _moviesUseCase.create(thumbPath, moviePath);
      result = SuccessCreationResult(movie);
    } else {
      final error = map[_KEY_ERROR_MESSAGE];
      result = ErrorCreationResult(error);
    }

    await scenesDir.delete(recursive: true);
    return result;
  }

  @override
  void dispose() {
    super.dispose();
    _channel.invokeMethod(_METHOD_CANCEL);
    _moviesUseCase.dispose();
  }
}

abstract class CreationResult {}

class SuccessCreationResult extends CreationResult {
  final Movie movie;

  SuccessCreationResult(this.movie);
}

class ErrorCreationResult extends CreationResult {
  final String error;

  ErrorCreationResult(this.error);
}
