import 'package:agg/enums/enums.dart';
import 'package:flutter/material.dart';
import 'package:agg/constants/app_themes.dart';
import 'package:agg/models/minigame.dart';

class TopInterface extends StatelessWidget {
  final MinigameType minigame;
  
  const TopInterface({
    super.key,
    required this.minigame,
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
                      Icon(
                        appIcons['statistics']!, 
                        size: 48, 
                        color: currentMode == GameMode.daily ? minigame.color : AppColors.border
                      ),
                      SizedBox(width: AppSpacing.md),
                      Icon(
                        appIcons['flame']!, 
                        size: 48, 
                        color: currentMode == GameMode.daily ? AppColors.flame : AppColors.border
                      ),
                      if (currentMode != GameMode.practice) ... [
                        Text('1', style: AppTextTheme.streakText),
                      ],
                      SizedBox(width: AppSpacing.md),
                      Icon(
                        appIcons['question']!, 
                        size: 48, 
                        color: minigame.color
                      ),
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