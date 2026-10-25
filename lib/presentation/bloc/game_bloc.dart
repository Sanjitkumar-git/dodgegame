import 'dart:async';
import 'dart:math';
import 'package:dodgegame/core/constants/game_consents.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/obstacle_entity.dart';
import '../../domain/entities/game_status.dart';
import 'game_event.dart';
import 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  Timer? _gameTimer;
  Timer? _obstacleTimer;
  final Random _random = Random();
  int _obstacleIdCounter = 0;

  GameBloc() : super(const GameState()) {
    on<ScreenSizeSet>(_onScreenSizeSet);
    on<GameStarted>(_onGameStarted);
    on<GameTicked>(_onGameTicked);
    on<ObstacleSpawned>(_onObstacleSpawned);
    on<PlayerMoved>(_onPlayerMoved);
    on<GameRestarted>(_onGameRestarted);
  }

  void _onScreenSizeSet(ScreenSizeSet event, Emitter<GameState> emit) {
    emit(state.copyWith(screenWidth: event.width, screenHeight: event.height));
  }

  void _onGameStarted(GameStarted event, Emitter<GameState> emit) {
    _startTimers();
    emit(
      state.copyWith(
        status: GameStatus.playing,
        playerX: 0.0,
        obstacles: [],
        score: 0,
      ),
    );
  }

  void _onGameRestarted(GameRestarted event, Emitter<GameState> emit) {
    add(const GameStarted());
  }

  void _startTimers() {
    _cancelTimers();

    // Game loop - position updates
    _gameTimer = Timer.periodic(
      const Duration(milliseconds: GameConstants.gameTickMs),
      (timer) => add(const GameTicked()),
    );

    // Obstacle spawner
    _obstacleTimer = Timer.periodic(
      const Duration(milliseconds: GameConstants.obstacleSpawnMs),
      (timer) => add(const ObstacleSpawned()),
    );
  }

  void _cancelTimers() {
    _gameTimer?.cancel();
    _obstacleTimer?.cancel();
  }

  void _onObstacleSpawned(ObstacleSpawned event, Emitter<GameState> emit) {
    if (state.status != GameStatus.playing) return;
    if (state.screenWidth == 0) return;

    final newObstacle = ObstacleEntity(
      id: 'obstacle_${_obstacleIdCounter++}',
      x:
          _random.nextDouble() *
          (state.screenWidth - GameConstants.obstacleSize),
      y: 0,
    );

    emit(state.copyWith(obstacles: [...state.obstacles, newObstacle]));
  }

  void _onGameTicked(GameTicked event, Emitter<GameState> emit) {
    if (state.status != GameStatus.playing) return;

    int scoreIncrement = 0;

    // Move obstacles down
    final updatedObstacles = state.obstacles.map((obstacle) {
      return obstacle.copyWith(y: obstacle.y + GameConstants.obstacleSpeed);
    }).toList();

    // Remove off-screen obstacles & increase score
    final remainingObstacles = <ObstacleEntity>[];
    for (var obstacle in updatedObstacles) {
      if (obstacle.y > state.screenHeight) {
        scoreIncrement++;
      } else {
        remainingObstacles.add(obstacle);
      }
    }

    // Collision check
    final isCollided = _checkCollision(remainingObstacles);

    if (isCollided) {
      _cancelTimers();
      emit(
        state.copyWith(
          status: GameStatus.gameOver,
          obstacles: remainingObstacles,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        obstacles: remainingObstacles,
        score: state.score + scoreIncrement,
      ),
    );
  }

  bool _checkCollision(List<ObstacleEntity> obstacles) {
    final playerBottom = state.screenHeight - GameConstants.playerBottomOffset;
    final playerCenterX = state.screenWidth / 2 + state.playerX;

    for (var obstacle in obstacles) {
      final obstacleCenterX = obstacle.x + GameConstants.obstacleSize / 2;

      final bool verticalOverlap =
          obstacle.y + GameConstants.obstacleSize > playerBottom &&
          obstacle.y < playerBottom + GameConstants.playerSize;

      final bool horizontalOverlap =
          (playerCenterX - obstacleCenterX).abs() <
          (GameConstants.playerSize / 2 + GameConstants.obstacleSize / 2);

      if (verticalOverlap && horizontalOverlap) {
        return true;
      }
    }
    return false;
  }

  void _onPlayerMoved(PlayerMoved event, Emitter<GameState> emit) {
    if (state.status != GameStatus.playing) return;

    double newPlayerX = state.playerX + event.delta;

    // Boundary clamp
    final halfPlayer = GameConstants.playerSize / 2;
    final maxX = state.screenWidth / 2 - halfPlayer;
    final minX = -state.screenWidth / 2 + halfPlayer;

    if (newPlayerX > maxX) newPlayerX = maxX;
    if (newPlayerX < minX) newPlayerX = minX;

    emit(state.copyWith(playerX: newPlayerX));
  }

  @override
  Future<void> close() {
    _cancelTimers();
    return super.close();
  }
}
