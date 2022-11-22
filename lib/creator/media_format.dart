// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:equatable/equatable.dart';

class MediaFormat extends Equatable {
  final String mime;
  final String fileExtension;
  final List<String> encodingParams;

  const MediaFormat({
    required this.mime,
    required this.fileExtension,
    required this.encodingParams,
  });

  @override
  List<Object?> get props => [mime, fileExtension, encodingParams];

  @override
  bool? get stringify => true;

  static const AVC = MediaFormat(
    mime: 'video/avc',
    fileExtension: 'mp4',
    encodingParams: ['-c:v', 'libx264'],
  );
  static const H264 = MediaFormat(
    mime: 'video/h264',
    fileExtension: 'mp4',
    encodingParams: ['-c:v', 'libx264'],
  );
  static const HEVC = MediaFormat(
    mime: 'video/hevc',
    fileExtension: 'mp4',
    encodingParams: ['-c:v', 'libx265'],
  );
  static const MPEG4 = MediaFormat(
    mime: 'video/mp4v-es',
    fileExtension: 'mp4',
    encodingParams: ['-c:v', 'libxvid'],
  );
  static const MediaFormat VP8 = MediaFormat(
    mime: 'video/x-vnd.on2.vp8',
    fileExtension: 'webm',
    encodingParams: ['-c:v', 'libvpx', '-b:v', '1M', '-c:a', 'libvorbis'],
  );
  static const VP9 = MediaFormat(
    mime: 'video/x-vnd.on2.vp9',
    fileExtension: 'webm',
    encodingParams: ['-c:v', 'libvpx-vp9'],
  );
}
