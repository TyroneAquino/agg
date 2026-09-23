import 'package:agg/enums/minigame_type.dart';
import 'package:flutter/material.dart';
import 'package:agg/constants/app_themes.dart';

class ClueIndicator extends StatelessWidget{
  final MinigameType minigame;

  const ClueIndicator({
    super.key,
    required this.minigame,
  });

  @override
  Widget build(BuildContext context){
    return Container(
      height: 140,
      decoration: BoxDecoration(color: AppColors.subBackground, border: Border.all(color: AppColors.border, width: 8)),
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Clue Indicators',  style: AppTextTheme.headingSmall),
          SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
                Column(
                  children: [
                    Container(height: 32, width: 32, color: AppColors.correct),
                    SizedBox(height: AppSpacing.sm),
                    Text('Correct', style: AppTextTheme.captionText)
                  ],
                ),
                
                SizedBox(width: AppSpacing.md),
                Column(
                  children: [
                    Container(height: 32, width: 32, color: AppColors.partial),
                    SizedBox(height: AppSpacing.sm),
                    Text('Partial', style: AppTextTheme.captionText)
                  ],
                ),

                SizedBox(width: AppSpacing.md),
                Column(
                  children: [
                    Container(height: 32, width: 32, color: AppColors.incorrect),
                    SizedBox(height: AppSpacing.sm),
                    Text('Incorrect', style: AppTextTheme.captionText)
                  ],
                ),

              if (minigame != MinigameType.character) ...[

                SizedBox(width: AppSpacing.md),
                Column(
                  children: [
                    Container(height: 32, width: 32, color: AppColors.comparison, child: Icon(appIcons['lower']!, size:35, color: AppColors.border)),
                    SizedBox(height: AppSpacing.sm),
                    Text('Lower', style: AppTextTheme.captionText)
                  ],
                ),

                SizedBox(width: AppSpacing.md),
                Column(
                  children: [
                    Container(height: 32, width: 32, color: AppColors.comparison, child: Icon(appIcons['higher']!, size:35, color: AppColors.border)),
                    SizedBox(height: AppSpacing.sm),
                    Text('Higher', style: AppTextTheme.captionText)
                  ],
                ),
              ]
            ],
          ),
        ]
      ),
    );
  }
}