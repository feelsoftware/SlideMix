import 'package:cpmoviemaker/base/viewmodel.dart';
import 'package:cpmoviemaker/models/movie.dart';
import 'package:cpmoviemaker/usecase/movies_usecase.dart';

class EntryPointViewModel extends ViewModel {
  final MoviesUseCase _useCase;
  List<Movie> _movies = List.empty(growable: true);

  bool get showWelcomeScreen => _movies.isEmpty;

  EntryPointViewModel(this._useCase);

  @override
  void dispose() {
    super.dispose();
    _useCase.dispose();
  }

  Future<void> init() async {
    _movies = await _useCase.fetchMovies();
    notifyListeners();
  }
}
