import 'package:flutter/material.dart';

class StartScreenWidget extends StatefulWidget {
  final VoidCallback onStart;

  const StartScreenWidget({super.key, required this.onStart});

  @override
  State<StartScreenWidget> createState() => _StartScreenWidgetState();
}

class _StartScreenWidgetState extends State<StartScreenWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Colors.lightBlueAccent, Colors.purpleAccent],
              ).createShader(bounds),
              child: const Text(
                "BLOCK DODGE",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: 50),
            ScaleTransition(
              scale: _pulseAnimation,
              child: GestureDetector(
                onTap: widget.onStart,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.blueAccent, Colors.purpleAccent],
                    ),
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent.withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.play_arrow, color: Colors.white, size: 28),
                      SizedBox(width: 8),
                      Text(
                        "START GAME",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Swipe left/right to move",
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
