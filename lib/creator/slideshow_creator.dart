import 'dart:async';
import 'dart:io';

import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/return_code.dart';
import 'package:path/path.dart';
import 'package:slidemix/creator/video_capability.dart';
import 'package:slidemix/file_manager.dart';
import 'package:slidemix/logger.dart';

abstract class SlideShowCreator {
  Future<SlideShow> create({
    required Directory images,
    required Directory destination,
  });

  FutureOr<void> dispose();
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

class FFmpegSlideShowCreator extends SlideShowCreator {
  final VideoCapabilityProvider videoCapabilityProvider;

  FFmpegSlideShowCreator({
    required this.videoCapabilityProvider,
  });

  @override
  Future<SlideShow> create({
    required Directory images,
    required Directory destination,
  }) async {
    await destination.create();

    final video = await _createVideo(
      imagesDir: images,
      destinationDir: destination,
    );

    final thumbnail = await _createThumb(
      video: video,
      destination: destination,
    );

    return SlideShow(
      videoPath: video.path,
      thumbPath: thumbnail.path,
      mime: video.mime,
      videoDuration: video.duration,
    );
  }

  @override
  FutureOr<void> dispose() {
    FFmpegKitConfig.enableStatisticsCallback();
    FFmpegKit.cancel();
  }

  Future<_Video> _createVideo({
    required Directory imagesDir,
    required Directory destinationDir,
  }) async {
    // TODO: get FPS from VideoCapabilityProvider
    const fps = 60;
    const slideDuration = Duration(seconds: 3);
    const transitionDuration = Duration(seconds: 1);

    final videoCapability = await videoCapabilityProvider.getVideoCapability();
    Logger.d('videoCapability $videoCapability');
    final videoPath =
        '${destinationDir.path}/video.${videoCapability.mediaFormat.fileExtension}';

    final videoCommand = <String>[];

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
        fps.toString(),
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
          '[$i]scale=$width:$height:force_original_aspect_ratio=decrease,pad=$width:$height:-1:-1:color=red[s$i];';
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
      transitionCommand += 'xfade=transition=distance';

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

      ...videoCapability.mediaFormat.encodingParams,

      // Override file in case it exists (we got error in past for the project)
      '-y',
      videoPath,
    ]);

    Logger.d('Create video ${videoCommand.join(' ')}');
    final totalDuration = images.length * slideDuration.inMilliseconds -
        ((images.length - 1) * transitionDuration.inMilliseconds / 2);
    final videoSession = await FFmpegSession.create(
      videoCommand,
      null,
      null,
      (statistic) {
        // TODO: emit callback into Stream to show on UI
        Logger.d('Progress ${statistic.getTime() / totalDuration}');
      },
    );
    try {
      await FFmpegKitConfig.ffmpegExecute(videoSession);
    } catch (ex, st) {
      Logger.e('Failed to execute FFmpeg', ex, st);
      rethrow;
    } finally {
      // Reset callback
      FFmpegKitConfig.enableStatisticsCallback();
    }

    Duration videoDuration;
    if (ReturnCode.isCancel(await videoSession.getReturnCode())) {
      Logger.d('Canceled video creation $videoPath');
      throw Exception('Video creation cancelled');
    }
    if (ReturnCode.isSuccess(await videoSession.getReturnCode())) {
      Logger.d('Video is created $videoPath');

      try {
        final mediaInformation =
            (await FFprobeKit.getMediaInformation(videoPath)).getMediaInformation();
        final duration = double.parse(mediaInformation?.getDuration() ?? '0.0').toInt();
        videoDuration = Duration(seconds: duration);
      } catch (ex, st) {
        Logger.e('Failed to get media information $videoPath', ex, st);
        videoDuration = Duration(milliseconds: totalDuration.round());
      }
    } else {
      Logger.e(
        'Failed to create video',
        Exception(
          (await videoSession.getLogs()).reversed.map((log) => log.getMessage()),
        ),
      );
      throw Exception('Failed to create video');
    }

    return _Video(
      path: videoPath,
      mime: videoCapability.mediaFormat.mime,
      duration: videoDuration,
    );
  }

  Future<_Thumbnail> _createThumb({
    required _Video video,
    required Directory destination,
  }) async {
    final thumbPath = '${destination.path}/thumbnail.jpg';
    final thumbCommand = <String>[
      "-ss",
      // Use the first frame/image as thumb
      _formatDurationForThumbnail(Duration.zero),
      "-noaccurate_seek",
      "-i",
      video.path,
      "-vframes",
      "1",
      "-y",
      thumbPath,
    ];
    Logger.d('Generate thumbnail ${thumbCommand.join(' ')}');
    await FFmpegKit.executeWithArguments(thumbCommand);
    final thumbSession = (await FFmpegKit.listSessions()).last;
    if (ReturnCode.isCancel(await thumbSession.getReturnCode())) {
      Logger.d('Canceled thumbnail generation $thumbPath');
      throw Exception('Video creation cancelled');
    }
    if (ReturnCode.isSuccess(await thumbSession.getReturnCode())) {
      Logger.d('Thumbnail is created $thumbPath');
      return _Thumbnail(path: thumbPath);
    } else {
      Logger.e(
        'Failed to create thumbnail',
        Exception(
          (await thumbSession.getLogs()).reversed.map((log) => log.getMessage()),
        ),
      );
      throw Exception('Failed to create thumbnail');
    }
  }

  String _formatDurationForThumbnail(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds.000";
  }
}

class _Video {
  final String path;
  final String mime;
  final Duration duration;

  const _Video({
    required this.path,
    required this.mime,
    required this.duration,
  });
}

class _Thumbnail {
  final String path;

  const _Thumbnail({
    required this.path,
  });
}
