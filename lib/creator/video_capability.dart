import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:slidemix/creator/media_format.dart';
import 'package:slidemix/extensions/iterable.dart';
import 'package:slidemix/logger.dart';

class VideoCapabilityProvider {
  Future<VideoCapability> getVideoCapability() async {
    final deviceSupportedCapabilities = await _getVideoCapabilities();
    final supportedFormats = [
      MediaFormat.AVC,
      MediaFormat.H264,
      MediaFormat.HEVC,
      MediaFormat.VP8,
      MediaFormat.VP9,
      MediaFormat.MPEG4,
    ];
    final supportedCapabilities = supportedFormats
        .map(
          (mediaFormat) => deviceSupportedCapabilities
              .firstOrNull((capability) => capability.mime == mediaFormat.mime),
        )
        .filterNotNull()
        .toList(growable: false);
    supportedCapabilities
        .sort((b, a) => a.sizes.last.width.compareTo(b.sizes.last.width));

    final videoCapability = supportedCapabilities.firstOrNull((_) => true);
    if (videoCapability == null) {
      throw Exception("Device doesn't support any video format");
    }
    final size = videoCapability.sizes.last;

    return VideoCapability(
      mediaFormat:
          supportedFormats.firstWhere((format) => videoCapability.mime == format.mime),
      width: size.width,
      height: size.height,
    );
  }

  Future<List<_VideoCapability>> _getVideoCapabilities() async {
    if (Platform.isIOS) {
      return [
        _VideoCapability(
          mime: MediaFormat.AVC.mime,
          sizes: const [
            _VideoSize(width: 640, height: 480),
            _VideoSize(width: 1280, height: 720),
            _VideoSize(width: 1920, height: 1080),
            // Disabled due to high memory usage
            // _VideoSize(width: 2560, height: 1440),
          ],
        ),
      ];
    }
    if (!Platform.isAndroid) {
      throw Exception('Unsupported platform, support only Android and iOS');
    }

    const channel =
        MethodChannel('com.feelsoftware.slidemix.capability.VideoCapability');
    try {
      List<dynamic> json = jsonDecode(await channel.invokeMethod('get'));
      return json
          .map((e) => _VideoCapability.fromJson(e as Map<String, dynamic>))
          .toList(growable: false);
    } catch (ex, st) {
      Logger.e('Failed to get video capability', ex, st);
      return [];
    }
  }
}

class VideoCapability extends Equatable {
  final MediaFormat mediaFormat;
  final int width;
  final int height;
  // TODO: get FPS from device
  final int fps = 60;

  const VideoCapability({
    required this.mediaFormat,
    required this.width,
    required this.height,
  });

  @override
  List<Object?> get props => [mediaFormat, width, height];

  @override
  bool? get stringify => true;
}

class _VideoCapability extends Equatable {
  final String mime;
  final List<_VideoSize> sizes;

  const _VideoCapability({
    required this.mime,
    required this.sizes,
  });

  _VideoCapability.fromJson(Map<String, dynamic> json)
      : mime = json['mime'],
        sizes = (json['sizes'] as List<dynamic>)
            .map((e) => _VideoSize.fromJson(e as Map<String, dynamic>))
            .toList(growable: false);

  @override
  List<Object?> get props => [mime, sizes];

  @override
  bool? get stringify => true;
}

class _VideoSize extends Equatable {
  final int width;
  final int height;

  const _VideoSize({
    required this.width,
    required this.height,
  });

  _VideoSize.fromJson(Map<String, dynamic> json)
      : width = json['width'],
        height = json['height'];

  @override
  List<Object?> get props => [width, height];

  @override
  bool? get stringify => true;
}
