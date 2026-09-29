import 'package:agg/enums/enums.dart';
import 'package:agg/widgets/dialog_box.dart';
import 'package:agg/models/player_stats.dart';
import 'package:flutter/material.dart';
import 'package:agg/constants/app_themes.dart';
import 'package:agg/models/minigame.dart';

class TopInterface extends StatelessWidget {
  final MinigameType minigame;
  final PlayerStats stats;
  
  const TopInterface({
    super.key,
    required this.minigame,
    required this.stats
  });

  @override
  Widget build(BuildContext context){
  final Minigame minigame = getMinigame(this.minigame);
    return ValueListenableBuilder<GameMode>(
      valueListenable: currentGameMode,
      builder: (context, currentMode, child){
        return Column(
        mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(minigame.name.toUpperCase(), style: AppTextTheme.headingLarge),
            Container(
                decoration: BoxDecoration(color: AppColors.subBackground, border: Border.all(color: AppColors.border, width: 8)),
                height: 80,
                width: 256,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      if(currentMode != GameMode.practice)
                        IconButton(
                          iconSize: 48,
                          icon: Icon(
                            appIcons['statistics']!, 
                            color: minigame.color
                          ),
                          onPressed: () {
                            showDialog<void>(
                              context: context, 
                              builder: (context) => DialogBox(title: DialogType.statistics, stats: stats, minigame: this.minigame)
                            );
                          },
                        ),
                        if(currentMode != GameMode.daily)
                          Icon(
                            appIcons['statistics']!,
                            size: 48,
                            color: AppColors.border
                          ),
                      SizedBox(width: AppSpacing.md),
                      Icon(
                        appIcons['flame']!, 
                        size: 48, 
                        color: currentMode == GameMode.daily ? (stats.currentStreak == 0 ? AppColors.subBorder: AppColors.flame) : AppColors.border
                      ),
                      if (currentMode != GameMode.practice) ... [
                        stats.currentStreak == 0 
                        ? Text('0', style: AppTextTheme.noStreakText)
                        : Text(stats.currentStreak.toString(), style: AppTextTheme.streakText)
                      ],
                      SizedBox(width: AppSpacing.md),
                      IconButton(
                        iconSize: 48,
                        icon: Icon(
                          appIcons['question']!, 
                          size: 48, 
                          color: minigame.color
                        ),
                        onPressed: (){
                          showDialog<void>(
                            context: context, 
                            builder: (context) => DialogBox(title: DialogType.help, minigame: this.minigame)
                          );
                        },
                      )
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.md),
            if (currentMode != GameMode.practice) ...[
              Text(minigame.prompt, style: AppTextTheme.bodyText)
            ],
          ],
        );
      }
    );
      
   }
}