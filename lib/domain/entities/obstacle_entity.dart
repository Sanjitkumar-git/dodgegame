import 'package:equatable/equatable.dart';

class ObstacleEntity extends Equatable {
  final String id;
  final double x;
  final double y;

  const ObstacleEntity({required this.id, required this.x, required this.y});

  ObstacleEntity copyWith({String? id, double? x, double? y}) {
    return ObstacleEntity(id: id ?? this.id, x: x ?? this.x, y: y ?? this.y);
  }

  @override
  List<Object?> get props => [id, x, y];
}
