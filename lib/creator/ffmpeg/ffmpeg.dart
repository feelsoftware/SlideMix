import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:slidemix/logger.dart';

class FFmpeg {
  FFmpeg._();

  static get _channel => MethodChannel('com.feelsoftware.slidemix.ffmpeg');

  static Future<void> dispose() async {
    await _channel.invokeMethod('dispose');
  }

  static Future<FFmpegReturnCode> execute(
    List<String> arguments, {
    required int duration,
    required void Function(double progress) onProgressChanged,
  }) async {
    final progressSubscription =
        EventChannel('com.feelsoftware.slidemix.ffmpeg.progress')
            .receiveBroadcastStream(duration)
            .listen((data) => onProgressChanged(data));

    try {
      Logger.d("Execute ffmpeg command $arguments");
      final result = await _channel.invokeMethod('execute', arguments);
      Logger.d("Executed ffmpeg command with result $result");
      return _returnCodeOf(result);
    } catch (ex) {
      return FFmpegReturnCodeError(Exception('Failed to execute ffmpeg command, $ex'));
    } finally {
      progressSubscription.cancel();
      dispose();
    }
  }

  static Future<Duration> duration(String path) async {
    final double duration = await _channel.invokeMethod('duration', path);
    return Duration(seconds: duration.toInt());
  }

  static FFmpegReturnCode _returnCodeOf(dynamic result) {
    final json = jsonDecode(result);

    if (json['isSuccess'] == true) {
      return FFmpegReturnCodeSuccess();
    }
    if (json['isCancel'] == true) {
      return FFmpegReturnCodeCancel();
    }
    return FFmpegReturnCodeError(Exception(json['logs'] ?? ''));
  }
}

sealed class FFmpegReturnCode {}

class FFmpegReturnCodeSuccess extends FFmpegReturnCode {}

class FFmpegReturnCodeCancel extends FFmpegReturnCode {}

class FFmpegReturnCodeError extends FFmpegReturnCode {
  final Exception error;

  FFmpegReturnCodeError(this.error);
}
