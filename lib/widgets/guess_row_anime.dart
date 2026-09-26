import 'package:flutter/material.dart';
import 'package:agg/constants/app_themes.dart';
import 'package:agg/models/anime_class.dart';

class GuessRowAnime extends StatelessWidget{
  final Anime guess;
  final Anime answer;

  const GuessRowAnime({
    super.key,
    required this.guess,
    required this.answer
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppSpacing.sm,
      children:[
        BoxContent(guess.name, answer: answer.name),
        BoxContent(guess.year, answer: answer.year),
        BoxContent(guess.season, answer: answer.season),
        BoxContent(guess.theme, answer: answer.theme),
        BoxContent(guess.genre, answer: answer.genre),
        BoxContent(guess.demographic, answer: answer.demographic),
        BoxContent(guess.studio, answer: answer.studio),
        BoxContent(guess.source, answer: answer.source),
        BoxContent(guess.format, answer: answer.format),
      ]
    );
  }
}

class BoxContent<T> extends StatelessWidget{
  final T content;
  final T answer; 

  const BoxContent(this.content, {super.key, required this.answer});

  Color get displayColor  => switch (content) {
    String s when s == answer => AppColors.correct,
    String _ => AppColors.incorrect,

    int i when i == answer => AppColors.correct,
    int _ => AppColors.comparison,

    List<String> list => listColor(list),

    _=> AppColors.incorrect,
  };

  Color listColor(List<String> list){
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
      int i => i.toString(),
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
      child: content is int ? Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(displayContent, style: AppTextTheme.guessText),
          if ((content as int) != (answer as int))
            Icon((content as int) > (answer as int) ? appIcons['lower'] : appIcons['higher']),
        ],
      )
      :Align(
        alignment: Alignment.center,
        child:Text(displayContent, textAlign: TextAlign.center, style: AppTextTheme.guessText)
      )
    );
  }
}
