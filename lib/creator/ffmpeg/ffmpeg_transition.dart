import 'dart:io';

import 'package:path/path.dart';
import 'package:slidemix/creator/slideshow_orientation.dart';
import 'package:slidemix/creator/slideshow_transition.dart';
import 'package:slidemix/creator/video_capability.dart';
import 'package:slidemix/file_manager.dart';

/// https://trac.ffmpeg.org/wiki/Xfade
class FFMpegTransitionProvider {
  Future<List<String>> transitionCommand({
    required Directory imagesDir,
    required Directory destinationDir,
    required VideoCapability videoCapability,
    required Duration slideDuration,
    required SlideShowTransition? transition,
    required Duration transitionDuration,
    required SlideShowOrientation orientation,
  }) async {
    final videoCommand = <String>[];

    if (transition == null) {
      return <String>[
        "-framerate",
        (1 / slideDuration.inSeconds).toString(),
        "-i",
        "${imagesDir.path}/image%03d.jpg",
        "-vf",
        _applyOrientationNoneTransition(
          videoCapability: videoCapability,
          orientation: orientation,
        ),
      ];
    }

    final images = imagesDir.listSync().whereType<File>().toList(growable: false)
      ..sort((a, b) => basename(a.path).compareTo(b.path));

    for (final image in images) {
      // Input each image using the arguments
      // `-loop 1 -t [slideDuration.inSeconds] -framerate [fps] -i image.jpg`
      // ensuring that each image is displayed for [slideDuration] at a [fps] frame rate
      // for smooth transitions.
      videoCommand.addAll([
        "-loop",
        "1",
        "-t",
        slideDuration.inSeconds.toString(),
        "-framerate",
        videoCapability.fps.toString(),
        "-i",
        buildPath(imagesDir, image.path),
      ]);
    }

    String transitionCommand = '';

    transitionCommand += _applyOrientationForTransition(
      imagesDir: imagesDir,
      images: images,
      videoCapability: videoCapability,
      orientation: orientation,
    );

    // https://trac.ffmpeg.org/wiki/Xfade
    // Multiple xfade filters are cascaded together. A crossfade is applied to the
    // first and second images using the circleopen transition starting at the
    // 2-second mark for one second, resulting in the stream f0.
    // Next, stream f0 is crossfaded with the third image at 4 seconds.
    String transitionCommandStream = 's0';
    for (var i = 1; i < images.length; i++) {
      transitionCommand += '[$transitionCommandStream][s$i]';

      // Set transition
      transitionCommand += 'xfade=transition=${transition.name}';

      // Set duration
      transitionCommand += ':duration=${transitionDuration.inSeconds}';

      // Set offset
      final transitionOffset =
          (slideDuration.inSeconds - transitionDuration.inSeconds / 2) * i;
      transitionCommand += ':offset=$transitionOffset';

      if (i < images.length - 1) {
        transitionCommandStream = 'f$i';
        transitionCommand += '[$transitionCommandStream];';
      } else {
        transitionCommand += ',format=yuv420p';
      }
    }

    videoCommand.addAll([
      "-filter_complex",
      transitionCommand,
    ]);
    return videoCommand;
  }

  String _applyOrientationNoneTransition({
    required VideoCapability videoCapability,
    required SlideShowOrientation orientation,
  }) {
    // Using images with different resolutions
    int width;
    int height;
    switch (orientation) {
      case SlideShowOrientation.landscape:
        width = videoCapability.width;
        height = videoCapability.height;
        break;

      case SlideShowOrientation.portrait:
        width = videoCapability.height;
        height = videoCapability.width;
        break;

      case SlideShowOrientation.square:
        width = videoCapability.height;
        height = videoCapability.height;
        break;
    }

    // Resize and contain
    // https://creatomate.com/blog/how-to-change-the-resolution-of-a-video-using-ffmpeg
    return 'scale=$width:$height:force_original_aspect_ratio=decrease,pad=$width:$height:-1:-1:color=black';
  }

  String _applyOrientationForTransition({
    required Directory imagesDir,
    required List<File> images,
    required VideoCapability videoCapability,
    required SlideShowOrientation orientation,
  }) {
    // Using images with different resolutions
    int width;
    int height;
    switch (orientation) {
      case SlideShowOrientation.landscape:
        width = videoCapability.width;
        height = videoCapability.height;
        break;

      case SlideShowOrientation.portrait:
        width = videoCapability.height;
        height = videoCapability.width;
        break;

      case SlideShowOrientation.square:
        width = videoCapability.height;
        height = videoCapability.height;
        break;
    }

    // Resize and contain
    // https://creatomate.com/blog/how-to-change-the-resolution-of-a-video-using-ffmpeg
    String transitionCommand = '';
    for (var i = 0; i < images.length; i++) {
      transitionCommand +=
          '[$i]scale=$width:$height:force_original_aspect_ratio=decrease,pad=$width:$height:-1:-1:color=black[s$i];';
    }
    return transitionCommand;
  }
}
