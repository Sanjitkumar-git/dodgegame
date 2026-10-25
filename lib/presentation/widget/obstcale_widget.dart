import 'package:dodgegame/core/constants/game_consents.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/obstacle_entity.dart';

class ObstacleWidget extends StatefulWidget {
  final ObstacleEntity obstacle;

  const ObstacleWidget({super.key, required this.obstacle});

  @override
  State<ObstacleWidget> createState() => _ObstacleWidgetState();
}

class _ObstacleWidgetState extends State<ObstacleWidget>
    with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late AnimationController _rotationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  static const List<Color> _colors = [
    Colors.redAccent,
    Colors.orangeAccent,
    Colors.purpleAccent,
    Colors.pinkAccent,
  ];

  late final Color _color;

  @override
  void initState() {
    super.initState();

    // Obstacle ID se consistent color pick karte hain
    final colorIndex = widget.obstacle.id.hashCode % _colors.length;
    _color = _colors[colorIndex.abs()];

    // Entrance animation - naya obstacle scale+fade in hoga
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeIn,
    );

    _entranceController.forward();

    // Continuous rotation animation
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.obstacle.x,
      top: widget.obstacle.y,
      child: AnimatedBuilder(
        animation: Listenable.merge([_entranceController, _rotationController]),
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Transform.rotate(
                angle: _rotationController.value * 2 * 3.14159,
                child: Container(
                  width: GameConstants.obstacleSize,
                  height: GameConstants.obstacleSize,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [_color, _color.withOpacity(0.6)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: _color.withOpacity(0.6),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.warning_rounded,
                    color: Colors.white70,
                    size: 20,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
