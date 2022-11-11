import 'dart:async';
import 'dart:io';

import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
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
  final Duration videoDuration;

  SlideShow({
    required this.videoPath,
    required this.thumbPath,
    required this.videoDuration,
  });
}

class FFmpegSlideShowCreator extends SlideShowCreator {
  @override
  Future<SlideShow> create({
    required Directory images,
    required Directory destination,
  }) async {
    await destination.create();
    final videoPath = '${destination.path}/video.mp4';
    Duration videoDuration = await _createVideo(
      images: images,
      video: File(videoPath),
    );

    final thumbPath = '${destination.path}/thumbnail.jpg';
    await _createThumb(
      video: File(videoPath),
      thumb: File(thumbPath),
    );

    return SlideShow(
      videoPath: videoPath,
      thumbPath: thumbPath,
      videoDuration: videoDuration,
    );
  }

  @override
  FutureOr<void> dispose() {
    FFmpegKit.cancel();
  }

  Future<Duration> _createVideo({
    required Directory images,
    required File video,
  }) async {
    const pixels = 720;
    final videoCommand = <String>[
      "-framerate",
      "1",
      "-i",
      "${images.path}/image%03d.jpg",
      "-r",
      "30",
      "-vf",
      "scale='if(gt(iw,ih),-2,min($pixels,iw))':'if(gt(iw,ih),min($pixels,iw),-2)'",
      "-pix_fmt",
      "yuv420p",
      "-y",
      video.path,
    ];
    Logger.d('Create video ${videoCommand.join(' ')}');
    await FFmpegKit.executeWithArguments(videoCommand);
    final videoSession = (await FFmpegKit.listSessions()).last;
    Duration videoDuration;
    if (ReturnCode.isCancel(await videoSession.getReturnCode())) {
      Logger.d('Canceled video creation ${video.path}');
      throw Exception('Video creation cancelled');
    }
    if (ReturnCode.isSuccess(await videoSession.getReturnCode())) {
      Logger.d('Video is created ${video.path}');

      try {
        final mediaInformation =
            (await FFprobeKit.getMediaInformation(video.path)).getMediaInformation();
        final duration = double.parse(mediaInformation?.getDuration() ?? '0.0').toInt();
        videoDuration = Duration(seconds: duration);
      } catch (ex, st) {
        Logger.e('Failed to get media information ${video.path}', ex, st);
        videoDuration = Duration.zero;
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

    return videoDuration;
  }

  Future<void> _createThumb({
    required File video,
    required File thumb,
  }) async {
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
      thumb.path,
    ];
    Logger.d('Generate thumbnail ${thumbCommand.join(' ')}');
    await FFmpegKit.executeWithArguments(thumbCommand);
    final thumbSession = (await FFmpegKit.listSessions()).last;
    if (ReturnCode.isCancel(await thumbSession.getReturnCode())) {
      Logger.d('Canceled thumbnail generation ${thumb.path}');
      throw Exception('Video creation cancelled');
    }
    if (ReturnCode.isSuccess(await thumbSession.getReturnCode())) {
      Logger.d('Thumbnail is created ${thumb.path}');
    } else {
      Logger.e(
        'Failed to create thumbnail',
        Exception(
          (await thumbSession.getLogs()).reversed.map((log) => log.getMessage()),
        ),
      );
    }
  }

  String _formatDurationForThumbnail(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds.000";
  }
}
