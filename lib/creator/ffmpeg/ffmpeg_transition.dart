import 'dart:io';

import 'package:path/path.dart';
import 'package:slidemix/creator/slideshow_orientation.dart';
import 'package:slidemix/creator/slideshow_resize.dart';
import 'package:slidemix/creator/slideshow_transition.dart';
import 'package:slidemix/creator/video_capability.dart';
import 'package:slidemix/extensions/number.dart';
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
    required SlideShowResize resize,
  }) async {
    final videoCommand = <String>[];

    if (transition == null) {
      return <String>[
        "-r",
        (1 / (slideDuration.inMilliseconds / 1000)).toPrecision(digits: 2).toString(),
        "-i",
        "${imagesDir.path}/image%03d.jpg",
        "-vf",
        _applyOrientationNoneTransition(
          videoCapability: videoCapability,
          orientation: orientation,
          resize: resize,
        ),
      ];
    }

    // FIXME: allow cases when slideDuration < transitionDuration
    if (transitionDuration > slideDuration) {
      transitionDuration = slideDuration;
    }

    final images = imagesDir.listSync().whereType<File>().toList(growable: false)
      ..sort((a, b) => basename(a.path).compareTo(b.path));

    for (var i = 0; i < images.length; i++) {
      // Input each image using the arguments
      // `-loop 1 -t [slideDuration] -i image.jpg`
      // ensuring that each image is displayed for [slideDuration]
      Duration duration = slideDuration;
      if (i < images.length - 1) {
        // add [transitionDuration] to display each image (except of last image)
        // while transitioning
        duration += transitionDuration;
      }
      videoCommand.addAll([
        "-loop",
        "1",
        "-t",
        (duration.inMilliseconds / 1000).toString(),
        "-i",
        buildPath(imagesDir, images[i].path),
      ]);
    }

    String transitionCommand = '';

    transitionCommand += _applyOrientationForTransition(
      imagesDir: imagesDir,
      images: images,
      videoCapability: videoCapability,
      orientation: orientation,
      resize: resize,
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
      transitionCommand += ':duration=${transitionDuration.inMilliseconds / 1000}';

      // Set offset
      // Offset(N) = SlideDuration + SlideDuration * N - TransitionDuration / 2
      final transitionOffset = slideDuration.inMilliseconds / 1000 +
          slideDuration.inMilliseconds / 1000 * (i - 1) -
          transitionDuration.inMilliseconds / 1000 / 2;
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
      "-r",
      videoCapability.fps.toString(),
    ]);
    return videoCommand;
  }

  String _applyOrientationNoneTransition({
    required VideoCapability videoCapability,
    required SlideShowOrientation orientation,
    required SlideShowResize resize,
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

    return _scaleResizeCommand(resize: resize, width: width, height: height);
  }

  String _applyOrientationForTransition({
    required Directory imagesDir,
    required List<File> images,
    required VideoCapability videoCapability,
    required SlideShowOrientation orientation,
    required SlideShowResize resize,
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

    String transitionCommand = '';
    for (var i = 0; i < images.length; i++) {
      final resizeCommand =
          _scaleResizeCommand(resize: resize, width: width, height: height);

      transitionCommand += '[$i]$resizeCommand[s$i];';
    }
    return transitionCommand;
  }

  // Resize to contain or cover
  // https://creatomate.com/blog/how-to-change-the-resolution-of-a-video-using-ffmpeg
  String _scaleResizeCommand({
    required SlideShowResize resize,
    required int width,
    required int height,
  }) {
    final scaleCommand = 'scale=$width:$height:force_original_aspect_ratio=';
    final resizeCommand = switch (resize) {
      SlideShowResize.contain => 'decrease,pad=$width:$height:-1:-1:color=black',
      SlideShowResize.cover => 'increase,crop=$width:$height',
    };
    return scaleCommand + resizeCommand;
  }
}
