import 'package:equatable/equatable.dart';
import 'package:slidemix/creation/data/media.dart';
import 'package:slidemix/creator/slideshow_orientation.dart';
import 'package:slidemix/creator/slideshow_transition.dart';

class DraftMovie extends Equatable {
  final int projectId;
  final List<Media> media;
  final SlideShowTransition? transition;
  final SlideShowOrientation orientation;
  final DateTime createdAt;

  const DraftMovie({
    required this.projectId,
    required this.media,
    required this.transition,
    required this.orientation,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [projectId, transition, orientation, createdAt];

  @override
  String toString() {
    return 'DraftMovie{projectId: $projectId, media: $media, transition: $transition, orientation: $orientation, createdAt: $createdAt}';
  }
}
