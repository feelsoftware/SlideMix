import 'package:com_feelsoftware_slidemix/base/viewmodel.dart';
import 'package:com_feelsoftware_slidemix/models/movie.dart';
import 'package:com_feelsoftware_slidemix/usecase/movies_usecase.dart';

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
