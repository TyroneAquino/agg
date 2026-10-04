import 'package:flutter/material.dart';
import 'package:agg/constants/app_themes.dart';
import 'package:agg/models/soundtrack_class.dart';

class GuessColumnSoundtrack extends StatelessWidget{
  final Soundtrack guess;
  final Soundtrack answer;

  const GuessColumnSoundtrack({
    super.key,
    required this.guess,
    required this.answer
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 200,
      padding: EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: guess.anime == answer.anime ? AppColors.correct : AppColors.incorrect,
        border: Border.all(color: AppColors.subBorder, width: 4),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(guess.anime, style: AppTextTheme.guessTextLarger, textAlign: TextAlign.center),
      ),
    );
  }
}