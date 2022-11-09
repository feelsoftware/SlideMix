import 'package:equatable/equatable.dart';

class Media extends Equatable {
  final String path;

  const Media(this.path);

  @override
  List<Object?> get props => [path];

  @override
  bool? get stringify => true;
}
