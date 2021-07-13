import 'dart:core';
import 'dart:io';
import 'package:com_feelsoftware_slidemix/base/viewmodel.dart';
import 'package:com_feelsoftware_slidemix/models/movie.dart';
import 'package:com_feelsoftware_slidemix/movies/movies_viewmodel.dart';
import 'package:com_feelsoftware_slidemix/usecase/creation_usecase.dart';

const _MIN_MEDIAS_COUNT = 3;

class CreationViewModel extends ViewModel {
  final CreationUseCase _useCase;
  final MoviesViewModel _moviesViewModel;

  final List<File> _media = List.empty(growable: true);

  List<File> get media => List.unmodifiable(_media);

  bool get isCreationAllowed => _media.length >= _MIN_MEDIAS_COUNT;

  int get minMediaCount => _MIN_MEDIAS_COUNT;

  CreationViewModel(this._useCase, this._moviesViewModel);

  @override
  void dispose() {
    super.dispose();
    _useCase.dispose();
  }

  void addMedia(File? file) {
    if (file != null) {
      _media.add(file);
      notifyListeners();
    }
  }

  void deleteMedia(int position) {
    _media.removeAt(position);
    notifyListeners();
  }

  Future<Movie> createMovie() async {
    if (!isCreationAllowed)
      return Future.error("Choose at least $_MIN_MEDIAS_COUNT media.");

    isLoading = true;
    final CreationResult result = await _useCase.createMovie(_media);
    isLoading = false;

    if (result is SuccessCreationResult) {
      _moviesViewModel.fetchMovies();
      return Future.value(result.movie);
    } else if (result is ErrorCreationResult) {
      return Future.error(result.error!);
    }

    return Future.value(null);
  }
}
