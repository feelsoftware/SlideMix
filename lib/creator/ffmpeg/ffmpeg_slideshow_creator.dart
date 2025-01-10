import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:slidemix/creator/ffmpeg/ffmpeg.dart';
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
    FFmpeg.dispose();
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
    Logger.d(
      'Create video ${videoCommand.join(' ').replaceAll(imagesDir.path, 'imagesDir'
          '').replaceAll(destinationDir.path, '{destinationDir}')}',
    );

    final images = imagesDir.listSync().whereType<File>().toList(growable: false)
      ..sort((a, b) => basename(a.path).compareTo(b.path));
    final totalDuration = images.length * slideDuration.inMilliseconds;

    final FFmpegReturnCode returnCode;
    try {
      returnCode = await FFmpeg.execute(
        videoCommand,
        duration: totalDuration,
        onProgressChanged: onProgress,
      );
    } catch (ex, st) {
      Logger.e('Failed to execute FFmpeg', ex, st);
      rethrow;
    }

    if (returnCode is FFmpegReturnCodeCancel) {
      Logger.d('Canceled video creation $videoPath');
      throw CancellationException('Video creation cancelled');
    }

    if (returnCode is FFmpegReturnCodeError) {
      Logger.e('Failed to create video', returnCode.error);
      throw Exception('Failed to create video');
    }

    Logger.d('Video is created $videoPath');

    Duration videoDuration;
    try {
      videoDuration = await FFmpeg.duration(videoPath);
    } catch (ex, st) {
      Logger.e('Failed to get duration $videoPath', ex, st);
      videoDuration = Duration(milliseconds: totalDuration.round());
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

    final FFmpegReturnCode returnCode;
    try {
      returnCode = await FFmpeg.execute(
        thumbCommand,
        duration: video.duration.inMilliseconds,
        onProgressChanged: (_) {},
      );
    } catch (ex, st) {
      Logger.e('Failed to generate thumbnail', ex, st);
      rethrow;
    }

    if (returnCode is FFmpegReturnCodeCancel) {
      Logger.d('Canceled thumbnail generation $thumbPath');
      throw Exception('Thumbnail generation cancelled');
    }

    if (returnCode is FFmpegReturnCodeError) {
      Logger.e('Failed to create thumbnail', returnCode.error);
      throw Exception('Failed to create thumbnail');
    }

    Logger.d('Thumbnail is created $thumbPath');
    return _Thumbnail(path: thumbPath);
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
