import 'package:agg/enums/enums.dart';
import 'package:flutter/material.dart';
import 'package:agg/constants/app_themes.dart';
import 'package:agg/models/soundtrack_class.dart';
import 'package:just_audio/just_audio.dart';

class ClueBox extends StatefulWidget{
  final MinigameType minigame;
  final String firstClue;
  final String secondClue;
  final int attempt; 
  final Soundtrack? soundtrack;

  const ClueBox({
    super.key,
    required this.minigame,
    required this.firstClue,
    required this.secondClue,
    required this.attempt,
    this.soundtrack
  });

  @override
  State<ClueBox> createState() => _ClueBoxState();
}

class _ClueBoxState extends State<ClueBox> {
  final AudioPlayer player = AudioPlayer();
  bool isPlaying = false; 
  double standardVolume = 0.7;

  @override 
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Container(
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
                if(widget.minigame != MinigameType.soundtrack) ...[
                  GameClue(minigame: widget.minigame, firstClue:widget.firstClue, secondClue:widget.secondClue, attempt: widget.attempt),
                ],
              ],

              if (widget.minigame == MinigameType.soundtrack) ... [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        isPlaying  ? appIcons['pause'] : appIcons['play'], size: 32, color: AppColors.subBorder
                      ),
                      onPressed:() async {
                        if (isPlaying) {
                          await player.pause();
                          setState(() {
                            isPlaying = false;
                          });
                        } else {
                          final url = widget.soundtrack?.link;
                          if(url == null || url.isEmpty){
                            debugPrint('Soundtrack link is null or empty');
                            return;
                          }
                          try{
                            debugPrint('Attempting to play audio: $url');
                            await player.setUrl(url);

                             debugPrint('Audio source loaded successfully');
                            await player.play();
  
                            setState((){
                              isPlaying = true;
                            });
                          } catch (e, stackTrace) {
                            debugPrint('Error playing audio: $e');
                            debugPrint('$stackTrace');
                          } 
                        }
                      },
                    ),

                    SizedBox(width:AppSpacing.bs),
                    Text(isPlaying ? 'Pause Audio' : 'Play Audio', style: AppTextTheme.bodyText),
                  ],
                ),
                SizedBox(height: AppSpacing.md),
                SizedBox(
                  width:300,
                  child: Slider(
                    min: 0.0,
                    max: 1.0,
                    thumbColor: AppColors.subBorder,
                    activeColor: AppColors.subBorder,
                    inactiveColor: AppColors.body,
                    value: standardVolume,
                    onChanged: (double newVolume) {
                      setState(() {
                        standardVolume = newVolume;
                      });
                      player.setVolume(standardVolume);
                    },
                  ), 
                ),

                SizedBox(height: AppSpacing.md),

                

                if(currentMode != GameMode.daily)...[
                  GameClue(minigame: widget.minigame, firstClue:widget.firstClue, secondClue:widget.secondClue, attempt: widget.attempt)
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
        return clueIndex == 1 ? 'Type' : 'Artist';
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