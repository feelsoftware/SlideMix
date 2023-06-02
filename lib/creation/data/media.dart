import 'package:equatable/equatable.dart';

class Media extends Equatable {
  final int projectId;
  final String path;

  const Media({
    required this.projectId,
    required this.path,
  });

  @override
  List<Object?> get props => [projectId, path];

  @override
  bool? get stringify => true;
}
