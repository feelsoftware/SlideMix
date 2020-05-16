import 'dart:core';
import 'dart:io';
import 'package:cpmoviemaker/base/viewmodel.dart';
import 'package:cpmoviemaker/usecase/creation_usecase.dart';

class CreationViewModel extends ViewModel {
  final CreationUseCase _useCase;

  final List<File> _medias = List<File>();

  CreationViewModel(this._useCase);

  @override
  void dispose() {
    super.dispose();
    _useCase.dispose();
  }

  List<File> getMedia() => List.unmodifiable(_medias);

  void addMedia(File file) {
    if (file != null) {
      _medias.add(file);
      notifyListeners();
    }
  }

  void deleteMedia(int position) {
    _medias.removeAt(position);
    notifyListeners();
  }

  void createMovie() {
    if (_medias.length == 0) return;
    listen(() {
      return _useCase.createMovie(_medias);
    }, (data) {
      final CreationResult result = data;
      if (result is SuccessCreationResult) {
        final movie = result.movie;
        print("createMovie success $movie");
      } else if (result is ErrorCreationResult) {
        final error = result.error;
        print("createMovie error $error");
      }
    });
  }
}
