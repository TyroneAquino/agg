import 'package:flutter/material.dart';
import 'package:agg/constants/app_themes.dart';

class GeneralButton extends StatelessWidget{
  final String title;
  final Color color;
  final VoidCallback onPressed;

  const GeneralButton({
    super.key,
    required this.title,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: color,
        side: BorderSide(color: AppColors.border, width: 4),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)
      ),
      child: Text(title, style: AppTextTheme.generalButton, textAlign: TextAlign.center,),
    );
  }
}