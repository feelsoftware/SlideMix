import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cpmoviemaker/base/usecase.dart';
import 'package:cpmoviemaker/models/movie.dart';
import 'package:cpmoviemaker/usecase/movies_usecase.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

const _CREATION_CHANNEL = "com.vitoksmile.cpmoviemaker.CREATION_CHANNEL";
const _CREATION_METHOD_CREATE = "CREATION_METHOD_CREATE";
const _CREATION_METHOD_CANCEL = "CREATION_METHOD_CANCEL";

abstract class CreationUseCase extends UseCase {
  Stream<T> createMovie<T extends CreationResult>(List<File> files);
}

class CreationUseCaseImpl extends CreationUseCase {
  final MoviesUseCase _moviesUseCase;

  CreationUseCaseImpl(this._moviesUseCase);

  @override
  Stream<T> createMovie<T extends CreationResult>(List<File> files) async* {
    final controller = StreamController<CreationResult>();

    final filesDir = await getApplicationSupportDirectory();
    final moviesDir = Directory(join(filesDir.path, "movies"));
    await moviesDir.create(recursive: true);
    final scenesDir = Directory(join(filesDir.path, "scenes"));
    await scenesDir.create(recursive: true);

    var index = 0;
    await Future.forEach(files, (file) async {
      final path = file.path;
      final newPath = join(scenesDir.path, "image00${index++}.jpg");
      await file.copy(newPath);
      print("file copied from $path to $newPath");
    });

    final _channel = MethodChannel(_CREATION_CHANNEL);
    await _channel.invokeMethod(_CREATION_METHOD_CREATE,
        [moviesDir.path, scenesDir.path]).then((moviePath) async {
      print("movie created, path: $moviePath");

      final thumb =
          "https://picsum.photos/id/${Random.secure().nextInt(100)}/200/300";
      final movie = await _moviesUseCase.create(thumb, moviePath);

      controller.add(SuccessCreationResult(movie));
    }).catchError((error) {
      print("creation error: $error");
      controller.add(ErrorCreationResult("Failed."));
    });

    await scenesDir.delete(recursive: true);

    yield* controller.stream;
    controller.close();
  }

  @override
  void dispose() {
    super.dispose();
    _moviesUseCase.dispose();

    final _channel = MethodChannel(_CREATION_CHANNEL);
    _channel.invokeMethod(_CREATION_METHOD_CANCEL);
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
