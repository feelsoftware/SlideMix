import 'dart:async';
import 'dart:io';

import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/return_code.dart';
import 'package:slidemix/creator/video_capability.dart';
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

  SlideShow({
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
      images: images,
      destination: destination,
    );

    final thumbnail = await _createThumb(
      video: video,
      destination: destination,
    );

    return SlideShow(
      videoPath: video.file.path,
      thumbPath: thumbnail.file.path,
      mime: video.mime,
      videoDuration: video.duration,
    );
  }

  @override
  FutureOr<void> dispose() {
    FFmpegKit.cancel();
  }

  Future<_Video> _createVideo({
    required Directory images,
    required Directory destination,
  }) async {
    final videoCapability = await videoCapabilityProvider.getVideoCapability();
    Logger.d('videoCapability $videoCapability');
    final videoPath =
        '${destination.path}/video.${videoCapability.mediaFormat.fileExtension}';

    final videoCommand = <String>[
      "-framerate",
      "1",
      "-i",
      "${images.path}/image%03d.jpg",
      "-r",
      "30",
      ...videoCapability.mediaFormat.encodingParams,
      "-vf",
      "scale='if(gt(iw,ih),-2,min(${videoCapability.width},iw))':'if(gt(iw,ih),min(${videoCapability.height},iw),-2)'",
      "-y",
      videoPath,
    ];
    Logger.d('Create video ${videoCommand.join(' ')}');
    await FFmpegKit.executeWithArguments(videoCommand);
    final videoSession = (await FFmpegKit.listSessions()).last;
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

    return _Video(
      file: File(videoPath),
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
      video.file.path,
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
      return _Thumbnail(file: File(thumbPath));
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
  final File file;
  final String mime;
  final Duration duration;

  _Video({
    required this.file,
    required this.mime,
    required this.duration,
  });
}

class _Thumbnail {
  final File file;

  _Thumbnail({
    required this.file,
  });
}
