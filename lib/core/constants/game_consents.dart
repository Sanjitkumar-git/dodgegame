class GameConstants {
  // Player settings
  static const double playerSize = 50.0;
  static const double playerBottomOffset = 100.0;

  // Obstacle settings
  static const double obstacleSize = 50.0;
  static const double obstacleSpeed = 5.0;

  // Timers
  static const int gameTickMs = 16; // ~60 FPS
  static const int obstacleSpawnMs = 1000;

  // Prevent instantiation
  GameConstants._();
}
