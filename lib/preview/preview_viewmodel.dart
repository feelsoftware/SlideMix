import 'dart:io';
import 'package:cpmoviemaker/base/viewmodel.dart';
import 'package:cpmoviemaker/models/movie.dart';
import 'package:video_player/video_player.dart';

class PreviewViewModel extends ViewModel {
  final Movie movie;
  VideoPlayerController controller;

  PreviewViewModel(this.movie);

  bool get isPlayerReady => controller.value.initialized;

  void init() {
    controller = VideoPlayerController.file(File(movie.video))
      ..initialize().then((_) {
        notifyListeners();
      })
      ..addListener(() {
        notifyListeners();
      });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
