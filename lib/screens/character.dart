import 'package:flutter/material.dart';
import 'package:agg/constants/app_themes.dart';
import 'package:agg/widgets/widgets.dart';
import 'package:agg/enums/enums.dart';
import 'package:agg/models/minigame.dart';

class CharacterScreen extends StatefulWidget {
  const CharacterScreen({super.key});

  @override
  State<CharacterScreen> createState() => _CharacterScreenState();

}

class _CharacterScreenState extends State<CharacterScreen>{
  final MinigameType minigame = MinigameType.character;
  final TextEditingController controller = TextEditingController();

  @override
    void dispose(){
    controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        toolbarHeight: 96,
        title: Text('A.GG', style: AppTextTheme.screenLogo), 
        backgroundColor: AppColors.background,
        iconTheme: IconThemeData(color: AppColors.body),
        actions: [
          IconButton(
            onPressed: (){
              showDialog(
                context: context,
                builder: (context) {
                  return DialogBox(title:DialogType.settings);
                },
              );
            },
            icon: Icon(appIcons['settings'], size: 48, color: AppColors.subBorder)
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSpacing.bs),
        child: SingleChildScrollView(
          child: ValueListenableBuilder<GameMode>(
            valueListenable: currentGameMode,
            builder: (context, currentMode, child){
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children:[
                  TopInterface(minigame: minigame),
                  if (currentMode != GameMode.practice)...[
                    Text(getMinigame(minigame).instruction, style: AppTextTheme.bodyText),
                  ],
                  if (currentMode != GameMode.daily) ...[
                    ClueBox(minigame: minigame),
                  ], 
                  SizedBox(height: AppSpacing.xl),
                  Textbox(minigame: minigame, controller: controller),
                  SizedBox(height: AppSpacing.xl),
                  ClueIndicator(minigame: minigame),
                  if (currentMode != GameMode.practice)...[
                    SizedBox(height:AppSpacing.xl),
                    Text('Yesterday\'s answer was ...', style: AppTextTheme.bodyText),
                  ],
                  SizedBox(height:AppSpacing.xl),
                  MinigameButton(minigame: MinigameType.soundtrack),
                ],
              );
            }
          )
        ),
      ),
    );
  }
}