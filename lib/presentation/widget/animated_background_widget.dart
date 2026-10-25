import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedBackgroundWidget extends StatefulWidget {
  final double width;
  final double height;

  const AnimatedBackgroundWidget({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  State<AnimatedBackgroundWidget> createState() =>
      _AnimatedBackgroundWidgetState();
}

class _AnimatedBackgroundWidgetState extends State<AnimatedBackgroundWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Star> _stars = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    // 40 stars generate karte hain random position/speed ke saath
    for (int i = 0; i < 40; i++) {
      _stars.add(
        _Star(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          speed: 0.2 + _random.nextDouble() * 0.8,
          size: 1.5 + _random.nextDouble() * 2.5,
        ),
      );
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0D1117), Color(0xFF161B22), Color(0xFF0D1117)],
        ),
      ),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            size: Size(widget.width, widget.height),
            painter: _StarPainter(stars: _stars, progress: _controller.value),
          );
        },
      ),
    );
  }
}

class _Star {
  double x;
  double y;
  final double speed;
  final double size;

  _Star({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
  });
}

class _StarPainter extends CustomPainter {
  final List<_Star> stars;
  final double progress;

  _StarPainter({required this.stars, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.7);

    for (var star in stars) {
      // Star ko neeche move karte hain, loop karke upar se phir se
      final dy = (star.y + progress * star.speed) % 1.0;
      final dx = star.x;

      final offset = Offset(dx * size.width, dy * size.height);

      canvas.drawCircle(offset, star.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _StarPainter oldDelegate) => true;
}
