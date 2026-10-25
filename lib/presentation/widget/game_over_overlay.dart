import 'package:flutter/material.dart';

class GameOverOverlay extends StatefulWidget {
  final int score;
  final VoidCallback onRestart;

  const GameOverOverlay({
    super.key,
    required this.score,
    required this.onRestart,
  });

  @override
  State<GameOverOverlay> createState() => _GameOverOverlayState();
}

class _GameOverOverlayState extends State<GameOverOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _shakeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    // Shake effect - card thoda left-right hilega entrance ke time
    _shakeAnimation =
        TweenSequence<Offset>([
          TweenSequenceItem(
            tween: Tween(
              begin: const Offset(-0.03, 0),
              end: const Offset(0.03, 0),
            ),
            weight: 25,
          ),
          TweenSequenceItem(
            tween: Tween(
              begin: const Offset(0.03, 0),
              end: const Offset(-0.02, 0),
            ),
            weight: 25,
          ),
          TweenSequenceItem(
            tween: Tween(begin: const Offset(-0.02, 0), end: Offset.zero),
            weight: 50,
          ),
        ]).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
          ),
        );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Container(
            color: Colors.black.withOpacity(0.7 * _fadeAnimation.value),
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: FractionalTranslation(
                translation: _shakeAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: _buildCard(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E1E2C), Color(0xFF2A2A3D)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.redAccent.withOpacity(0.3),
            blurRadius: 30,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.dangerous_rounded,
            color: Colors.redAccent,
            size: 50,
          ),
          const SizedBox(height: 12),
          const Text(
            "Game Over!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Score: ${widget.score}",
            style: const TextStyle(color: Colors.white70, fontSize: 20),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: widget.onRestart,
            icon: const Icon(Icons.refresh),
            label: const Text("Restart", style: TextStyle(fontSize: 16)),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
