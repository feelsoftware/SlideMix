import 'package:equatable/equatable.dart';
import 'package:slidemix/creation/data/media.dart';

class DraftMovie extends Equatable {
  final int projectId;
  final List<Media> media;
  final DateTime createdAt;

  const DraftMovie({
    required this.projectId,
    required this.media,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [projectId];

  @override
  String toString() {
    return 'DraftMovie{projectId: $projectId, media: $media, createdAt: $createdAt}';
  }
}
