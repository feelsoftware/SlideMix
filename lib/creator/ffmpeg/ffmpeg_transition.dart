// https://trac.ffmpeg.org/wiki/Xfade
import 'dart:io';

import 'package:path/path.dart';
import 'package:slidemix/creator/slideshow_creator.dart';
import 'package:slidemix/creator/video_capability.dart';
import 'package:slidemix/file_manager.dart';

/// https://trac.ffmpeg.org/wiki/Xfade
class FFMpegTransitionProvider {
  List<String> transitionCommand({
    required Directory imagesDir,
    required Directory destinationDir,
    required VideoCapability videoCapability,
    required Duration slideDuration,
    required SlideShowTransition? transition,
    required Duration transitionDuration,
  }) {
    final videoCommand = <String>[];

    if (transition == null) {
      return <String>[
        "-framerate",
        (1 / slideDuration.inSeconds).toString(),
        "-i",
        "${imagesDir.path}/image%03d.jpg",
        "-r",
        "30",
        "-vf",
        "scale='if(gt(iw,ih),-2,min(${videoCapability.width},iw))':'if(gt(iw,ih),min(${videoCapability.height},iw),-2)'",
      ];
    }

    // Transitioning between images
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
    // Using images with different resolutions
    String transitionCommand = '';
    for (var i = 0; i < images.length; i++) {
      // TODO: find min size based on input images
      // "-vf",
      // "scale='if(gt(iw,ih),-2,min(${videoCapability.width},iw))':'if(gt(iw,ih),min(${videoCapability.height},iw),-2)'",
      final width = videoCapability.width;
      final height = videoCapability.height;

      // Resize and contain
      // https://creatomate.com/blog/how-to-change-the-resolution-of-a-video-using-ffmpeg
      transitionCommand +=
          '[$i]scale=$width:$height:force_original_aspect_ratio=decrease,pad=$width:$height:-1:-1:color=black[s$i];';
    }
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
}
