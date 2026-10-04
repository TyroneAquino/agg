import 'package:agg/enums/enums.dart';
import 'package:agg/models/player_stats.dart';
import 'package:flutter/material.dart';
import 'package:agg/constants/app_themes.dart';
import 'package:agg/dialogs/dialog.dart';
import 'package:agg/states/game_state.dart';
import 'package:agg/models/soundtrack_class.dart';

class DialogBox extends StatelessWidget {
  final DialogType title;
  final PlayerStats? stats;
  final MinigameType? minigame;
  final GameState? gameState;
  final Soundtrack? soundtrack;
  final Future<void> Function()? playAgain;

  const DialogBox({
    super.key,
    required this.title,
    this.stats,
    this.minigame,
    this.gameState,
    this.soundtrack,
    this.playAgain
  }) : assert(
    title == DialogType.settings || 
    (title == DialogType.statistics && stats != null) || 
    (title == DialogType.help && minigame != null) ||
    ((title == DialogType.victory || title == DialogType.lose || title == DialogType.practice) && stats != null && minigame != null && gameState != null)
  );

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.subBackground,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppDialog(title: title, stats: stats, minigame: minigame, gameState: gameState, playAgain: playAgain, soundtrack: soundtrack),  
            ],
          ),
        ),
      ),
    );
  }
}
