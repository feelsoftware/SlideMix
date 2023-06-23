import 'dart:io';

import 'package:slidemix/creator/slideshow_orientation.dart';
import 'package:slidemix/creator/slideshow_resize.dart';
import 'package:slidemix/creator/slideshow_transition.dart';

abstract class SlideShowCreator {
  Future<SlideShow> create({
    required Directory images,
    required Directory destination,
    required Duration slideDuration,
    required SlideShowTransition? transition,
    required Duration transitionDuration,
    required SlideShowOrientation orientation,
    required SlideShowResize resize,
    required Function(double progress) onProgress,
  });

  Future<void> dispose();
}

class SlideShow {
  final String videoPath;
  final String thumbPath;
  final String mime;
  final Duration videoDuration;

  const SlideShow({
    required this.videoPath,
    required this.thumbPath,
    required this.mime,
    required this.videoDuration,
  });
}
