import 'package:dodgegame/core/constants/game_consents.dart';
import 'package:flutter/material.dart';


class PlayerWidget extends StatefulWidget {
  final double playerX;
  final double screenWidth;

  const PlayerWidget({
    super.key,
    required this.playerX,
    required this.screenWidth,
  });

  @override
  State<PlayerWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _tiltController;
  double _tiltAngle = 0.0;
  double _previousX = 0.0;

  @override
  void initState() {
    super.initState();
    _previousX = widget.playerX;

    // Glow pulse animation - continuously chalta rahega
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    // Tilt animation - jab player move karega to tilt hoga, phir seedha
    _tiltController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void didUpdateWidget(covariant PlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    final delta = widget.playerX - _previousX;

    if (delta.abs() > 0.5) {
      // Movement direction ke hisaab se tilt angle set karein
      setState(() {
        _tiltAngle = (delta.clamp(-15, 15)) * 0.03;
      });

      _tiltController.forward(from: 0).then((_) {
        if (mounted) {
          setState(() => _tiltAngle = 0.0);
        }
      });
    }

    _previousX = widget.playerX;
  }

  @override
  void dispose() {
    _glowController.dispose();
    _tiltController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 80),
      curve: Curves.easeOut,
      bottom: GameConstants.playerBottomOffset,
      left:
          widget.screenWidth / 2 +
          widget.playerX -
          GameConstants.playerSize / 2,
      child: AnimatedBuilder(
        animation: _glowController,
        builder: (context, child) {
          final glowValue = 0.3 + (_glowController.value * 0.4);

          return AnimatedRotation(
            turns: _tiltAngle / (2 * 3.14159),
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            child: Container(
              width: GameConstants.playerSize,
              height: GameConstants.playerSize,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.lightBlueAccent, Colors.blueAccent],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(glowValue),
                    blurRadius: 20,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: const Icon(
                Icons.rocket_launch,
                color: Colors.white,
                size: 26,
              ),
            ),
          );
        },
      ),
    );
  }
}
