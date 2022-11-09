import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

@Entity(tableName: CreationEntity.tableName)
class CreationEntity extends Equatable {
  static const tableName = 'creation';

  @PrimaryKey(autoGenerate: true)
  final int? id;

  const CreationEntity({
    this.id,
  });

  @override
  List<Object?> get props => [id];
}
