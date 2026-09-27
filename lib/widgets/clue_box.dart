import 'package:agg/enums/enums.dart';
import 'package:flutter/material.dart';
import 'package:agg/constants/app_themes.dart';

class ClueBox extends StatelessWidget{
  final MinigameType minigame;
  final String firstClue;
  final String secondClue;
  final int attempt; 

  const ClueBox({
    super.key,
    required this.minigame,
    required this.firstClue,
    required this.secondClue,
    required this.attempt
  });

  @override
  Widget build(BuildContext context){
    return Container(
      //height: 140,
      width: 360,
      decoration: BoxDecoration(color: AppColors.subBackground, border: Border.all(color: AppColors.border, width: 8)),
      padding: EdgeInsets.all(AppSpacing.md),
      child: ValueListenableBuilder<GameMode>(
        valueListenable: currentGameMode,
        builder: (context, currentMode, child){
          return Column(
            children: [
              if (currentMode != GameMode.daily) ...[ //
                Text('Practice Mode', style: AppTextTheme.bodyText),
                SizedBox(height: AppSpacing.md),
                if(minigame != MinigameType.soundtrack) ...[
                  GameClue(minigame: minigame, firstClue:firstClue, secondClue:secondClue, attempt: attempt),
                ],
              ],
              if (minigame == MinigameType.soundtrack) ... [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(appIcons['play']?? Icons.abc_outlined, size: 32, color: AppColors.subBorder),
                    SizedBox(width:AppSpacing.bs),
                    Text('Play Audio', style: AppTextTheme.bodyText),
                  ],
                ),
                SizedBox(height: AppSpacing.md),
                LinearProgressIndicator(value: .6, color: Color(0xFF475569), backgroundColor: Color(0xFFF8FAFC)),
                SizedBox(height: AppSpacing.md),

                if(currentMode != GameMode.daily)...[
                  GameClue(minigame: minigame, firstClue:firstClue, secondClue:secondClue, attempt: attempt)
                ]
              ],
            ],
          );
        } 
      ),
    );
  }
}

class GameClue extends StatelessWidget{
  final MinigameType minigame;
  final String firstClue;
  final String secondClue;
  final int attempt;

  const GameClue({
    super.key,
    required this.minigame,
    required this.firstClue,
    required this.secondClue,
    required this.attempt,
  });

  String getGameClueIndex(MinigameType minigame, int clueIndex){
    switch(minigame){
      case MinigameType.anime:
        return clueIndex == 1 ? 'Status' : 'Sypnosis';
      case MinigameType.character:
        return clueIndex == 1 ? 'Signature' : 'Quote';
      case MinigameType.soundtrack:
        return clueIndex == 1 ? 'Artist' : 'Type';
    }
  }

  String getGameClue(MinigameType minigame, int clueIndex){
    switch(minigame){
      case MinigameType.anime:
        return clueIndex == 1 ? firstClue : secondClue;
      case MinigameType.character:
        return clueIndex == 1 ? firstClue : secondClue;
      case MinigameType.soundtrack:
        return clueIndex == 1 ? firstClue : secondClue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 132,
          decoration: BoxDecoration(color: AppColors.subBorder),
          padding: EdgeInsets.all(AppSpacing.bs),
          child: Column(
            children: [
              Text(getGameClueIndex(minigame, 1), style : AppTextTheme.headingSmall, textAlign: TextAlign.center),
              if(attempt >= 3)
                Text(getGameClue(minigame, 1), style: AppTextTheme.bodyText, textAlign: TextAlign.center)
            ]
          ),
        ),
        SizedBox(width: AppSpacing.bs),
        Container(
          width: 164,
          decoration: BoxDecoration(color: AppColors.subBorder),
          padding: EdgeInsets.all(AppSpacing.bs),
          child: IntrinsicHeight(
            child: Column(
              children: [
                Text(getGameClueIndex(minigame, 2), style : AppTextTheme.headingSmall, textAlign: TextAlign.center),
                if(attempt >= 7)
                  Text(getGameClue(minigame, 2), style: AppTextTheme.bodyText, textAlign: TextAlign.center)
              ],
          ),
          )
          
        ),
      ],
    );
  }
}