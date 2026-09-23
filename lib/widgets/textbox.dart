import 'package:agg/enums/minigame_type.dart';
import 'package:flutter/material.dart';
import 'package:agg/constants/app_themes.dart';

class Textbox extends StatelessWidget{
  final MinigameType minigame;
  final TextEditingController controller;

  const Textbox({
    super.key,
    required this.minigame,
    required this.controller,
  });

  @override
  Widget build(BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width:256,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: minigame.toString(), 
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.subBorder, width: 4))
            ),
          ),
        ),
        SizedBox(width: AppSpacing.bs),
        Icon(appIcons['enter'] ?? Icons.help_outline, size: 48, color: AppColors.subBorder),
      ],
    );
  }
}