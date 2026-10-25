import 'package:dodgegame/presentation/widget/animated_background_widget.dart';
import 'package:dodgegame/presentation/widget/game_over_overlay.dart';
import 'package:dodgegame/presentation/widget/obstcale_widget.dart';
import 'package:dodgegame/presentation/widget/player_widget.dart';
import 'package:dodgegame/presentation/widget/score_borard_widget.dart';
import 'package:dodgegame/presentation/widget/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/game_bloc.dart';
import '../bloc/game_event.dart';
import '../bloc/game_state.dart';
import '../../domain/entities/game_status.dart';



class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => GameBloc(), child: const GameView());
  }
}

class GameView extends StatefulWidget {
  const GameView({super.key});

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  bool _isInitialized = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (!_isInitialized) {
      _isInitialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<GameBloc>().add(
          ScreenSizeSet(width: size.width, height: size.height),
        );
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: BlocBuilder<GameBloc, GameState>(
        builder: (context, state) {
          return Stack(
            children: [
              // Animated Background - hamesha dikhega
              AnimatedBackgroundWidget(width: size.width, height: size.height),

              // Game area - sirf jab playing ya gameOver ho
              if (state.status != GameStatus.initial)
                GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    context.read<GameBloc>().add(
                      PlayerMoved(delta: details.delta.dx),
                    );
                  },
                  child: Stack(
                    children: [
                      ScoreBoardWidget(score: state.score),
                      ...state.obstacles.map(
                        (obstacle) => ObstacleWidget(obstacle: obstacle),
                      ),
                      PlayerWidget(
                        playerX: state.playerX,
                        screenWidth: state.screenWidth,
                      ),
                    ],
                  ),
                ),

              // Smooth transition between screens
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: _buildOverlay(context, state),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOverlay(BuildContext context, GameState state) {
    switch (state.status) {
      case GameStatus.initial:
        return StartScreenWidget(
          key: const ValueKey('start'),
          onStart: () {
            context.read<GameBloc>().add(const GameStarted());
          },
        );
      case GameStatus.gameOver:
        return GameOverOverlay(
          key: const ValueKey('gameover'),
          score: state.score,
          onRestart: () {
            context.read<GameBloc>().add(const GameRestarted());
          },
        );
      case GameStatus.playing:
        return const SizedBox.shrink(key: ValueKey('playing'));
    }
  }
}
