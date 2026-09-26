import 'package:flutter/material.dart';
import 'package:agg/constants/app_themes.dart';
import 'package:agg/models/character_class.dart';

class GuessRowCharacter extends StatelessWidget{
  final Character guess;
  final Character answer;

  const GuessRowCharacter({
    super.key,
    required this.guess,
    required this.answer
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppSpacing.sm,
      children:[
        BoxCharacter(guess.name, answer: answer.name),
        BoxCharacter(guess.series, answer: answer.series),
        BoxCharacter(guess.eye, answer: answer.eye),
        BoxCharacter(guess.hair, answer: answer.hair),
        BoxCharacter(guess.sex, answer: answer.sex),
        BoxCharacter(guess.species, answer: answer.species),
        BoxCharacter(guess.occupation, answer: answer.occupation),
        BoxCharacter(guess.affiliation, answer: answer.affiliation),
        BoxCharacter(guess.status, answer: answer.status),
        BoxCharacter(guess.power, answer: answer.power),
      ]
    );
  }
}

class BoxCharacter<T> extends StatelessWidget{
  final T content;
  final T answer;

  const BoxCharacter(this.content, {super.key, required this.answer});

  Color get displayColor  => switch (content) {
    String s when s == answer => AppColors.correct,
    String _ => AppColors.incorrect,

    List<String> list => listColor(list),

    _=> AppColors.incorrect,
  };

  Color listColor(List<String> list){
    print('CONTENT LIST: $list');
  print('ANSWER: $answer');
  print('ANSWER TYPE: ${answer.runtimeType}');
    final answerList  = answer as List<String>;
    final matches = list.where( (item) => answerList.contains(item)).length;

    if (matches == answerList.length && list.length == answerList.length){
      return AppColors.correct;
    }

    if (matches > 0){
      return AppColors.partial;
    }

    return AppColors.incorrect;
  }

  String get displayContent => switch (content){
      String s => s,
      List<String> list => list.join(', '),
      _ => 'Unknown'
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 128,
      height: 64,
      padding: EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(color: displayColor, border: Border.all(color: AppColors.subBorder, width: 4)),
      child: Align(
        alignment: Alignment.center,
        child: Text(displayContent, style: AppTextTheme.guessText, textAlign: TextAlign.center)
      )
    );
  }

}