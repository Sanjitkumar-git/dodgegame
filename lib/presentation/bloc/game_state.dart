import 'package:equatable/equatable.dart';
import '../../domain/entities/obstacle_entity.dart';
import '../../domain/entities/game_status.dart';

class GameState extends Equatable {
  final GameStatus status;
  final double playerX;
  final List<ObstacleEntity> obstacles;
  final int score;
  final double screenWidth;
  final double screenHeight;

  const GameState({
    this.status = GameStatus.initial,
    this.playerX = 0.0,
    this.obstacles = const [],
    this.score = 0,
    this.screenWidth = 0.0,
    this.screenHeight = 0.0,
  });

  GameState copyWith({
    GameStatus? status,
    double? playerX,
    List<ObstacleEntity>? obstacles,
    int? score,
    double? screenWidth,
    double? screenHeight,
  }) {
    return GameState(
      status: status ?? this.status,
      playerX: playerX ?? this.playerX,
      obstacles: obstacles ?? this.obstacles,
      score: score ?? this.score,
      screenWidth: screenWidth ?? this.screenWidth,
      screenHeight: screenHeight ?? this.screenHeight,
    );
  }

  @override
  List<Object?> get props => [
    status,
    playerX,
    obstacles,
    score,
    screenWidth,
    screenHeight,
  ];
}
