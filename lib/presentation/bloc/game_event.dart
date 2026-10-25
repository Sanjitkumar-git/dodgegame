import 'package:equatable/equatable.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object?> get props => [];
}

/// Screen size set hote hi ye event fire hota hai
class ScreenSizeSet extends GameEvent {
  final double width;
  final double height;

  const ScreenSizeSet({required this.width, required this.height});

  @override
  List<Object?> get props => [width, height];
}

/// Game start/restart karne ke liye
class GameStarted extends GameEvent {
  const GameStarted();
}

/// Har game tick (frame update) par fire hota hai
class GameTicked extends GameEvent {
  const GameTicked();
}

/// Naya obstacle generate karne ke liye
class ObstacleSpawned extends GameEvent {
  const ObstacleSpawned();
}

/// Player ko move karne ke liye (swipe gesture se)
class PlayerMoved extends GameEvent {
  final double delta;

  const PlayerMoved({required this.delta});

  @override
  List<Object?> get props => [delta];
}

/// Game restart karne ke liye
class GameRestarted extends GameEvent {
  const GameRestarted();
}
