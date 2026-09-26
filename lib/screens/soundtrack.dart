import 'package:agg/states/game_state.dart';
import 'package:flutter/material.dart';
import 'package:agg/constants/app_themes.dart';
import 'package:agg/widgets/widgets.dart';
import 'package:agg/enums/enums.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SoundtrackScreen extends StatefulWidget {

  final GameState gameState;
  const SoundtrackScreen({super.key, required this.gameState});

  @override
  State<SoundtrackScreen> createState() => _SoundtrackScreenState();
}

class _SoundtrackScreenState extends State<SoundtrackScreen>{
  final MinigameType minigame = MinigameType.soundtrack;
  final supabase = Supabase.instance.client;
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
            icon: Icon(appIcons['settings'], size: 48, color: AppColors.subBorder,)
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  TopInterface(minigame:  minigame),
                  SizedBox(height: AppSpacing.xl),
                  ClueBox(minigame: minigame),
                  SizedBox(height: AppSpacing.xl),
                  //Textbox(minigame: minigame, controller: controller),
                  if (currentMode != GameMode.practice) ...[
                    SizedBox(height: AppSpacing.xl),
                    Text('Yesterday\'s answer was ...', style: AppTextTheme.bodyText)
                  ]
                ],
              );
            }
          ), 
        ),
      ),
    );
  }
}