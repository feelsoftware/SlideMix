import 'dart:async';
import 'dart:io';

import 'package:cpmoviemaker/models/movie.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

const _CREATION_CHANNEL = "com.vitoksmile.cpmoviemaker.CREATION_CHANNEL";
const _CREATION_METHOD_CREATE = "CREATION_METHOD_CREATE";
const _CREATION_METHOD_CANCEL = "CREATION_METHOD_CANCEL";

abstract class CreationRepository {
  Stream<T> createMovie<T extends CreationResult>(List<File> files);
}

class CreationRepositoryImpl implements CreationRepository {
  @override
  Stream<T> createMovie<T extends CreationResult>(List<File> files) async* {
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
        [moviesDir.path, scenesDir.path]).then((moviePath) {
      print("Creation success $moviePath");
    }).catchError((error) {
      print("Creation error $error");
    });

    await scenesDir.delete(recursive: true);
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
