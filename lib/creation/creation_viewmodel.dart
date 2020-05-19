import 'dart:core';
import 'dart:io';
import 'package:cpmoviemaker/base/viewmodel.dart';
import 'package:cpmoviemaker/models/movie.dart';
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

  Future<Movie> createMovie() async {
    isLoading = true;
    final CreationResult result = await _useCase.createMovie(_medias);
    isLoading = false;

    if (result is SuccessCreationResult) {
      return Future.value(result.movie);
    } else if (result is ErrorCreationResult) {
      return Future.error(result.error);
    }

    return Future.value(null);
  }
}
