import 'package:flutter/material.dart';

class ScoreBoardWidget extends StatefulWidget {
  final int score;

  const ScoreBoardWidget({super.key, required this.score});

  @override
  State<ScoreBoardWidget> createState() => _ScoreBoardWidgetState();
}

class _ScoreBoardWidgetState extends State<ScoreBoardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _bumpController;
  late Animation<double> _scaleAnimation;
  int _previousScore = 0;

  @override
  void initState() {
    super.initState();
    _previousScore = widget.score;

    _bumpController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _bumpController, curve: Curves.easeOut));
  }

  @override
  void didUpdateWidget(covariant ScoreBoardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.score != _previousScore) {
      _bumpController.forward(from: 0);
      _previousScore = widget.score;
    }
  }

  @override
  void dispose() {
    _bumpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      left: 20,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 20),
              const SizedBox(width: 6),
              Text(
                "${widget.score}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
