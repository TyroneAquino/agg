import 'package:agg/enums/enums.dart';
import 'package:agg/models/player_stats.dart';
import 'package:agg/states/game_state.dart';
import 'package:agg/widgets/minigame_button.dart';
import 'package:flutter/material.dart';
import 'package:agg/widgets/general_button.dart';
import 'package:agg/dialogs/device_transfer_dialog.dart';
import 'package:agg/constants/app_themes.dart';
import 'package:agg/models/soundtrack_class.dart';
import 'package:agg/dialogs/dialog_help.dart';

class AppDialog extends StatelessWidget{
  final DialogType title;
  final PlayerStats? stats;
  final MinigameType? minigame;
  final GameState? gameState;
  final Soundtrack? soundtrack;
  final Future<void> Function()? playAgain;

  const AppDialog({
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
  Widget build(BuildContext context){

    switch(title){
      
      //--------------SETTINGS-------------------------------------------------

      case(DialogType.settings):
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title.name[0].toUpperCase()+title.name.substring(1), style: AppTextTheme.headingMedium),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(appIcons['close'], color: AppColors.body)
                )
              ],
            ),
            SizedBox(height: AppSpacing.bs),
            ValueListenableBuilder<GameMode>(
              valueListenable: currentGameMode,
              builder: (context, curentMode, child) {
                return Row(
                  children: [
                    Expanded(
                      child: GeneralButton(
                        title: 'Daily Puzzle', 
                        color: curentMode == GameMode.daily ? AppColors.correct : AppColors.incorrect,
                        onPressed: (){
                          currentGameMode.value = GameMode.daily;
                          Navigator.pop(context);
                        }
                      ),
                    ),
                    Expanded(
                      child: GeneralButton(
                        title: 'Practice Mode', 
                        color: curentMode == GameMode.practice ? AppColors.correct : AppColors.incorrect,
                        onPressed: (){
                          currentGameMode.value = GameMode.practice;
                          Navigator.pop(context);
                        }, 
                      ),
                    ),
                  ],
                );
              },
            ),

            SizedBox(height: AppSpacing.bs),
            ListTile(
              tileColor: AppColors.subBorder,
              leading: Icon(appIcons['device'], color: AppColors.body,),
              title: Text('Switch Device', style: AppTextTheme.bodyText),
              subtitle: Text('Transfer your A.GG progress', style: AppTextTheme.guessText),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    return const DeviceTransferDialog();
                  },
                );
              },
            ),

            SizedBox(height: AppSpacing.lg),
            GeneralButton(
              title: 'Exit', 
              color: AppColors.exit, 
              onPressed: (){},
            ),
          ],
        );

      //--------------Statistics-------------------------------------------------

      case(DialogType.statistics):
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title.name[0].toUpperCase()+title.name.substring(1), style: AppTextTheme.headingMedium),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(appIcons['close'], color: AppColors.body)
                )
              ],
            ),
            SizedBox(height: AppSpacing.bs),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Puzzles Solved', style: AppTextTheme.bodyText),
                Text(stats?.puzzlesSolved.toString() ?? '0', style: AppTextTheme.bodyText),
              ],
            ),
            SizedBox(height: AppSpacing.bs),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Win Rate', style: AppTextTheme.bodyText),
                Text('${stats?.winRate.toStringAsFixed(0)}%', style: AppTextTheme.bodyText),
                
              ],
            ),
            SizedBox(height: AppSpacing.bs),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Average Guess', style: AppTextTheme.bodyText),
                Text(stats?.averageGuess.toStringAsFixed(2) ?? '0', style: AppTextTheme.bodyText),
                
              ],
            ),
            SizedBox(height: AppSpacing.bs),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('One Shot', style: AppTextTheme.bodyText),
                Text(stats?.oneShots.toString() ?? '0', style: AppTextTheme.bodyText),
                
              ],
            ),
            SizedBox(height: AppSpacing.bs),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,  
              children: [
                Text('Current Streak', style: AppTextTheme.bodyText),
                Text(stats?.currentStreak.toString() ?? '0', style: AppTextTheme.bodyText),
              ],
            ),
            SizedBox(height: AppSpacing.bs),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Longest Streak', style: AppTextTheme.bodyText),
                Text(stats?.longestStreak.toString() ?? '0', style: AppTextTheme.bodyText),
              ],
            ),
          ],
        );

      //--------------HOW TO PLAY-------------------------------------------------

      case(DialogType.help):
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('How to Play', style: AppTextTheme.headingMedium),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(appIcons['close'], color: AppColors.body)
                )
              ],
            ),
            switch(minigame){
              MinigameType.anime => DialogHelp(minigame: MinigameType.anime),
              MinigameType.character => DialogHelp(minigame: MinigameType.character),
              MinigameType.soundtrack => DialogHelp(minigame: MinigameType.soundtrack),
              null => const SizedBox.shrink()
            }
          ],
        );
      
      //--------------DAILY MODE(VICOTRY)-------------------------------------------------

      case(DialogType.victory):
        final answerName = switch(minigame){
          MinigameType.anime => gameState?.dailyAnimeAnswer?.name,
          MinigameType.character => gameState?.dailyCharacterAnswer?.name,
          MinigameType.soundtrack => gameState?.dailySoundtrackAnswer?.anime,
          null => null
        };

        final attempts = switch(minigame){
          MinigameType.anime => gameState?.dailyAnimeAttempts,
          MinigameType.character => gameState?.dailyCharacterAttempts,
          MinigameType.soundtrack => gameState?.dailySoundtrackAttempts,
          null => null
        };

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(appIcons['close'], color: AppColors.subBackground),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(appIcons['close'], color: AppColors.body)
                ),
              ],
            ),
            Text('Congratulations!', style: AppTextTheme.headingMedium, textAlign: TextAlign.center),
            SizedBox(height: AppSpacing.xl),
            Text('You guessed $answerName', style: AppTextTheme.bodyText, textAlign: TextAlign.center),
            Text('Number of Tries: $attempts', style: AppTextTheme.bodyText, textAlign: TextAlign.center),
            SizedBox(height: AppSpacing.xl),
            if(minigame == MinigameType.soundtrack)SoundtrackDialog(soundtrack: soundtrack),
            SizedBox(height: AppSpacing.xl),
            Text('Statistics', style: AppTextTheme.bodyText, textAlign: TextAlign.center),
            SizedBox(height: AppSpacing.bs),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(stats?.puzzlesSolved.toString() ?? '0', style: AppTextTheme.bodyText),
                    Text('Total', style: AppTextTheme.bodyText),
                    Text('Puzzle', style: AppTextTheme.bodyText)
                  ],
                ),
                SizedBox(width: AppSpacing.md),
                Column(
                  children: [
                    Text('${stats?.winRate.toStringAsFixed(0)}%', style: AppTextTheme.bodyText),
                    Text('Win', style: AppTextTheme.bodyText),
                    Text('Rate', style: AppTextTheme.bodyText)
                  ],
                ),
                SizedBox(width: AppSpacing.md),
                Column(
                  children: [
                    Text(stats?.currentStreak.toString() ?? '0', style: AppTextTheme.bodyText),
                    Text('Current', style: AppTextTheme.bodyText),
                    Text('Streak', style: AppTextTheme.bodyText)
                  ],
                ),
                SizedBox(width: AppSpacing.md),
                Column(
                  children: [
                    Text(stats?.longestStreak.toString() ?? '0', style: AppTextTheme.bodyText),
                    Text('Longest', style: AppTextTheme.bodyText),
                    Text('Streak', style: AppTextTheme.bodyText)
                  ],
                ),
              ],
            ),
            SizedBox(height: AppSpacing.xl),
            if(minigame != MinigameType.soundtrack)Text('Next Minigame:', style: AppTextTheme.bodyText),
            SizedBox(height: AppSpacing.bs),
            if(minigame == MinigameType.anime) MinigameButton(minigame: MinigameType.character, gameState: gameState!),
            if(minigame == MinigameType.character) MinigameButton(minigame: MinigameType.soundtrack, gameState: gameState!)
          ]
        );

      //--------------DAILY MODE(LOSE)-------------------------------------------------

      case(DialogType.lose):
      final answerName = switch(minigame){
          MinigameType.anime => gameState?.dailyAnimeAnswer?.name,
          MinigameType.character => gameState?.dailyCharacterAnswer?.name,
          MinigameType.soundtrack => gameState?.dailySoundtrackAnswer?.anime,
          null => null
        };
        
        final attempts = switch(minigame){
          MinigameType.anime => gameState?.dailyAnimeAttempts,
          MinigameType.character => gameState?.dailyCharacterAttempts,
          MinigameType.soundtrack => gameState?.dailySoundtrackAttempts,
          null => null
        };

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(appIcons['close'], color: AppColors.subBackground),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(appIcons['close'], color: AppColors.body)
                ),
              ],
            ),
            Text('Nice Try!', style: AppTextTheme.headingMedium),
            SizedBox(height: AppSpacing.xl),
            Text('Today\'s Answer: $answerName', style: AppTextTheme.bodyText),
            Text('Number of Tries: $attempts', style: AppTextTheme.bodyText),
            SizedBox(height: AppSpacing.xl),
            if(minigame == MinigameType.soundtrack)SoundtrackDialog(soundtrack: soundtrack),
            SizedBox(height: AppSpacing.xl),
            Text('Statistics', style: AppTextTheme.bodyText),
            SizedBox(height: AppSpacing.bs),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(stats?.puzzlesSolved.toString() ?? '0', style: AppTextTheme.bodyText),
                    Text('Total', style: AppTextTheme.bodyText),
                    Text('Puzzle', style: AppTextTheme.bodyText)
                  ],
                ),
                SizedBox(width: AppSpacing.md),
                Column(
                  children: [
                    Text('${stats?.winRate.toStringAsFixed(0)}%', style: AppTextTheme.bodyText),
                    Text('Win', style: AppTextTheme.bodyText),
                    Text('Rate', style: AppTextTheme.bodyText)
                  ],
                ),
                SizedBox(width: AppSpacing.md),
                Column(
                  children: [
                    Text(stats?.currentStreak.toString() ?? '0', style: AppTextTheme.bodyText),
                    Text('Current', style: AppTextTheme.bodyText),
                    Text('Streak', style: AppTextTheme.bodyText)
                  ],
                ),
                SizedBox(width: AppSpacing.md),
                Column(
                  children: [
                    Text(stats?.longestStreak.toString() ?? '0', style: AppTextTheme.bodyText),
                    Text('Longest', style: AppTextTheme.bodyText),
                    Text('Streak', style: AppTextTheme.bodyText)
                  ],
                ),
              ],
            ),
            SizedBox(height: AppSpacing.xl),
            if(minigame != MinigameType.soundtrack)Text('Next Minigame:', style: AppTextTheme.bodyText),
            SizedBox(height: AppSpacing.bs),
            if(minigame == MinigameType.anime) MinigameButton(minigame: MinigameType.character, gameState: gameState!),
            if(minigame == MinigameType.character) MinigameButton(minigame: MinigameType.soundtrack, gameState: gameState!)
          ]
        );  

      //--------------PACTICE MODE END-------------------------------------------------

      case(DialogType.practice):
        final answerName = switch(minigame){
          MinigameType.anime => gameState?.practiceAnimeAnswer?.name,
          MinigameType.character => gameState?.practiceCharacterAnswer?.name,
          MinigameType.soundtrack => gameState?.practiceSoundtrackAnswer?.anime,
          null => null
        };

        final attempts = switch(minigame){
          MinigameType.anime => gameState?.practiceAnimeAttempts,
          MinigameType.character => gameState?.practiceCharacterAttempts,
          MinigameType.soundtrack => gameState?.practiceSoundtrackAttempts,
          null => null
        };

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(appIcons['close'], color: AppColors.subBackground),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(appIcons['close'], color: AppColors.body)
                ),
              ],
            ),
            Text('Congratulations!', style: AppTextTheme.headingMedium, textAlign: TextAlign.center),
            SizedBox(height: AppSpacing.xl),
            Text('You guessed $answerName', style: AppTextTheme.bodyText, textAlign: TextAlign.center),
            Text('Number of Tries: $attempts', style: AppTextTheme.bodyText, textAlign: TextAlign.center),
            SizedBox(height: AppSpacing.xl),
            if(minigame == MinigameType.soundtrack)SoundtrackDialog(soundtrack: soundtrack),
            SizedBox(height: AppSpacing.xl),
            GeneralButton(
              title: 'Play Again', 
              color: AppColors.correct, 
              onPressed: () async {
                await playAgain?.call();
                if (context.mounted){
                  Navigator.pop(context);
                }
              },
            ),
            SizedBox(height: AppSpacing.xl),
            Text('Other Minigame:', style: AppTextTheme.bodyText),
            if(minigame != MinigameType.anime)...[MinigameButton(minigame: MinigameType.anime, gameState: gameState!)],
            SizedBox(height: AppSpacing.bs),
            if(minigame != MinigameType.character)...[MinigameButton(minigame: MinigameType.character, gameState: gameState!)],
            SizedBox(height: AppSpacing.bs),
            if(minigame != MinigameType.soundtrack)...[MinigameButton(minigame: MinigameType.soundtrack, gameState: gameState!)],
          ]
        );    
    }
  }
}

//--------------SOUNDTRACK CREDITS-------------------------------------------------

class SoundtrackDialog extends StatelessWidget{
  final Soundtrack? soundtrack;

  const SoundtrackDialog({
    super.key,
    this.soundtrack
  });

  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        Text('Soundtrack: ${soundtrack?.title ?? ''}', style: AppTextTheme.bodyText, textAlign: TextAlign.center),
        SizedBox(height: AppSpacing.bs),
        Text('Artist: ${soundtrack?.artist ?? ''}', style: AppTextTheme.bodyText, textAlign: TextAlign.center),
      ]
    );
  }
}