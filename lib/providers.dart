import 'package:cpmoviemaker/usecase/movies_usecase.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'entry_point/entry_point_viewmodel.dart';
import 'movies/movies_viewmodel.dart';

List<SingleChildWidget> getProviders() {
  return [
    ChangeNotifierProvider(
      create: (_) => MoviesViewModel(
        MoviesUseCaseImpl(),
      ),
    ),
    ChangeNotifierProvider(
      create: (_) => EntryPointViewModel(
        MoviesUseCaseImpl(),
      ),
    ),
  ];
}
