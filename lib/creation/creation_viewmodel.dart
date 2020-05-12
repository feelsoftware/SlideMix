import 'dart:core';
import 'dart:io';
import 'package:cpmoviemaker/base/viewmodel.dart';
import 'package:cpmoviemaker/repository/creation_repository.dart';

class CreationViewModel extends ViewModel {
  final CreationRepository _repository;

  final List<File> _medias = List<File>();

  CreationViewModel(this._repository);

  List<File> getMedia() => List.unmodifiable(_medias);

  void addMedia(File file) {
    if (file != null) {
      _medias.add(file);
    }
  }

  void deleteMedia(int position) {
    _medias.removeAt(position);
  }

  void createMovie() {
    if (_medias.length == 0) return;
    listen(() {
      return _repository.createMovie(_medias);
    }, (data) {
      final CreationResult result = data;
      if (result is SuccessCreationResult) {
        final movies = result.movie;
        print("createMovie success $movies");
      } else if (result is ErrorCreationResult) {
        final error = result.error;
        print("createMovie error $error");
      }
    });
  }
}
