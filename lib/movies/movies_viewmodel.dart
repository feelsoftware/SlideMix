import 'package:com_feelsoftware_slidemix/base/viewmodel.dart';
import 'package:com_feelsoftware_slidemix/models/movie.dart';
import 'package:com_feelsoftware_slidemix/usecase/movies_usecase.dart';

class MoviesViewModel extends ViewModel {
  final MoviesUseCase _useCase;
  List<Movie> _movies = List.empty(growable: true);

  List<Movie> get movies => List.unmodifiable(_movies);

  MoviesViewModel(this._useCase);

  @override
  void dispose() {
    super.dispose();
    _useCase.dispose();
  }

  Future<void> fetchMovies() async {
    _movies = await _useCase.fetchMovies();
    notifyListeners();
  }
}
