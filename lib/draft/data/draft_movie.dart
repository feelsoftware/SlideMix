import 'package:equatable/equatable.dart';
import 'package:slidemix/creation/data/media.dart';
import 'package:slidemix/creator/slideshow_orientation.dart';
import 'package:slidemix/creator/slideshow_transition.dart';

class DraftMovie extends Equatable {
  final int projectId;
  final List<Media> media;
  final Duration slideDuration;
  final SlideShowTransition? transition;
  final Duration transitionDuration;
  final SlideShowOrientation orientation;
  final DateTime createdAt;

  const DraftMovie({
    required this.projectId,
    required this.media,
    required this.slideDuration,
    required this.transition,
    required this.transitionDuration,
    required this.orientation,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        projectId,
        slideDuration,
        transition,
        transitionDuration,
        orientation,
        createdAt
      ];

  @override
  String toString() {
    return 'DraftMovie{projectId: $projectId, media: $media, slideDuration: $slideDuration, transition: $transition, transitionDuration: $transitionDuration, orientation: $orientation, createdAt: $createdAt}';
  }
}
