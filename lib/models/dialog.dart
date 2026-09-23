import 'package:agg/enums/enums.dart';
import 'package:flutter/material.dart';
import 'package:agg/widgets/general_button.dart';
import 'package:agg/constants/app_themes.dart';

class AppDialog extends StatelessWidget{
  final DialogType title;

  const AppDialog({
    super.key,
    required this.title
  });

  @override
  Widget build(BuildContext context){

    switch(title){

      case(DialogType.settings):
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: AppSpacing.bs),
            ValueListenableBuilder<GameMode>(
              valueListenable: currentGameMode,
              builder: (context, curentMode, child) {
                return Row(
                  children: [
                    Expanded(
                      child: GeneralButton(
                        title: 'Daily Puzzle', 
                        color: curentMode == GameMode.daily ? AppColors.correct : AppColors.partial,
                        onPressed: (){
                          currentGameMode.value = GameMode.daily;
                          Navigator.pop(context);
                        }
                      ),
                    ),
                    Expanded(
                      child: GeneralButton(
                        title: 'Practice Mode', 
                        color: curentMode == GameMode.practice ? AppColors.correct : AppColors.partial,
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
                        
            SizedBox(height: AppSpacing.lg),
            GeneralButton(
              title: 'Exit', 
              color: AppColors.exit, 
              onPressed: (){},
            ),
          ],
        );

      default: return const SizedBox.shrink();
    }
  }
}