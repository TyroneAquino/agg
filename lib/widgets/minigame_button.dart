import 'package:agg/enums/minigame_type.dart';
import 'package:flutter/material.dart';
import 'package:agg/constants/app_themes.dart';
import 'package:agg/models/minigame.dart';

class MinigameButton extends StatelessWidget{
  final MinigameType minigame;
  
  const MinigameButton({
    super.key,
    required this.minigame,
  });

  @override
  Widget build(BuildContext context){
    final Minigame minigame = getMinigame(this.minigame);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => minigame.page)
        );
      },
      child: Container(
        height: 80,
        width: 272,
        decoration: BoxDecoration(color: minigame.color, border: Border.all(color: AppColors.subBorder, width: AppSpacing.bs)),
        child: Padding(
          padding: EdgeInsets.only(left: AppSpacing.bs),
            child: Row(
                children: [
                    Icon(appIcons[minigame.icon] ?? Icons.help_outline, size: 48, color: AppColors.subBorder),
                    const SizedBox(width: AppSpacing.bs),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Text(minigame.name, style: AppTextTheme.buttonTitle),
                            Text(minigame.description, style: AppTextTheme.buttonCaption),
                        ],
                    ),
                ],
            ),
        ),
      ),

    );
  }
}

