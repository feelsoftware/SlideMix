import 'dart:io';

abstract class SlideShowCreator {
  Future<SlideShow> create({
    required Directory images,
    required Directory destination,
    required Duration slideDuration,
    required SlideShowTransition? transition,
    required Duration transitionDuration,
  });

  Future<void> dispose();
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

enum SlideShowTransition {
  fade,
  fadeblack,
  fadewhite,
  distance,
  wipeleft,
  wiperight,
  wipeup,
  wipedown,
  slideleft,
  slideright,
  slideup,
  slidedown,
  smoothleft,
  smoothright,
  smoothup,
  smoothdown,
  circlecrop,
  rectcrop,
  circleclose,
  circleopen,
  horzclose,
  horzopen,
  vertclose,
  vertopen,
  diagbl,
  diagbr,
  diagtl,
  diagtr,
  hlslice,
  hrslice,
  vuslice,
  vdslice,
  dissolve,
  pixelize,
  radial,
  hblur,
  wipetl,
  wipetr,
  wipebl,
  wipebr,
  fadegrays,
  squeezev,
  squeezeh,
  zoomin,
}
