import 'dart:async';
import 'dart:io';

import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/return_code.dart';
import 'package:path/path.dart';
import 'package:slidemix/creator/ffmpeg/ffmpeg_transition.dart';
import 'package:slidemix/creator/slideshow_creator.dart';
import 'package:slidemix/creator/slideshow_orientation.dart';
import 'package:slidemix/creator/slideshow_resize.dart';
import 'package:slidemix/creator/slideshow_transition.dart';
import 'package:slidemix/creator/video_capability.dart';
import 'package:slidemix/logger.dart';

class FFmpegSlideShowCreator extends SlideShowCreator {
  final VideoCapabilityProvider videoCapabilityProvider;
  final FFMpegTransitionProvider transitionProvider;

  FFmpegSlideShowCreator({
    required this.videoCapabilityProvider,
  }) : transitionProvider = FFMpegTransitionProvider();

  @override
  Future<SlideShow> create({
    required Directory images,
    required Directory destination,
    required Duration slideDuration,
    required SlideShowTransition? transition,
    required Duration transitionDuration,
    required SlideShowOrientation orientation,
    required SlideShowResize resize,
    required Function(double progress) onProgress,
  }) async {
    await destination.create();

    final video = await _createVideo(
      imagesDir: images,
      destinationDir: destination,
      slideDuration: slideDuration,
      transition: transition,
      transitionDuration: transitionDuration,
      orientation: orientation,
      resize: resize,
      onProgress: onProgress,
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
  Future<void> dispose() async {
    // Reset callback
    FFmpegKitConfig.enableStatisticsCallback();
    FFmpegKit.cancel();
  }

  Future<_Video> _createVideo({
    required Directory imagesDir,
    required Directory destinationDir,
    required Duration slideDuration,
    required SlideShowTransition? transition,
    required Duration transitionDuration,
    required SlideShowOrientation orientation,
    required SlideShowResize resize,
    required Function(double progress) onProgress,
  }) async {
    final videoCapability = await videoCapabilityProvider.getVideoCapability();
    Logger.d('videoCapability $videoCapability');

    final videoPath =
        '${destinationDir.path}/video.${videoCapability.mediaFormat.fileExtension}';
    final videoCommand = <String>[
      // Transitioning between images
      ...await transitionProvider.transitionCommand(
        imagesDir: imagesDir,
        destinationDir: destinationDir,
        videoCapability: videoCapability,
        slideDuration: slideDuration,
        transition: transition,
        transitionDuration: transitionDuration,
        orientation: orientation,
        resize: resize,
      ),

      // Encoding params based on device
      ...videoCapability.mediaFormat.encodingParams,

      // Override file in case it exists (we got error in past for the project)
      '-y',
      videoPath,
    ];
    Logger.d('Create video ${videoCommand.join(' ')}');

    final images = imagesDir.listSync().whereType<File>().toList(growable: false)
      ..sort((a, b) => basename(a.path).compareTo(b.path));
    final totalDuration = images.length * slideDuration.inMilliseconds -
        ((images.length - 1) * transitionDuration.inMilliseconds / 2);

    final videoSession = await FFmpegSession.create(
      videoCommand,
      null,
      null,
      (statistic) {
        var progress = statistic.getTime() / totalDuration;
        if(progress < 0) progress = 0;
        if(progress > 1) progress = 1;
        onProgress(progress);
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

      return _Video(
        path: videoPath,
        mime: videoCapability.mediaFormat.mime,
        duration: videoDuration,
      );
    } else {
      Logger.e(
        'Failed to create video',
        Exception(
          (await videoSession.getLogs()).reversed.map((log) => log.getMessage()),
        ),
      );
      throw Exception('Failed to create video');
    }
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
