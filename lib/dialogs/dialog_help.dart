import 'package:flutter/material.dart';
import 'package:agg/enums/enums.dart';
import 'package:agg/constants/app_themes.dart';

class DialogHelp extends StatelessWidget {
  final MinigameType minigame;

  const DialogHelp({super.key, required this.minigame});

  @override
  Widget build(BuildContext context) {
    switch (minigame) {
      case MinigameType.anime:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.bs,
          children: [
            SizedBox(height: AppSpacing.bs),
            RichText(text: TextSpan(
              text: 'In this minigame, your goal is to guess the ',
              style: AppTextTheme.captionText,
              children: [
                TextSpan(
                  text: 'secret anime ',
                  style: AppTextTheme.captionTextBold
                ),
                TextSpan(
                  text: 'based on the clues provided.',
                )
              ]
            )),
            Text('First, enter the name of any anime. The game will compare your guess with the secret anime and provide clues to help you find the correct answer.', style: AppTextTheme.captionText),

            SizedBox(height: AppSpacing.bs),
            Text('Clues', style: AppTextTheme.headingSmall),
            RichText(text: TextSpan(
              children: [
                TextSpan(
                  text: 'Year: ',
                  style: AppTextTheme.captionTextBold
                ),
                TextSpan(
                  text: ' The year the anime first ever aired or released.',
                  style: AppTextTheme.captionText
                )
              ]
            )),
            RichText(text: TextSpan(
              children: [
                TextSpan(
                  text: 'Season: ',
                  style: AppTextTheme.captionTextBold
                ),
                TextSpan(
                  text: ' The season when the anime was first released, based on Japan\'s seasonal schedule',
                  style: AppTextTheme.captionText
                )
              ]
            )),
            RichText(text: TextSpan(
              children: [
                TextSpan(
                  text: 'Theme: ',
                  style: AppTextTheme.captionTextBold
                ),
                TextSpan(
                  text: ' The overall theme or subject of the anime.',
                  style: AppTextTheme.captionText
                )
              ]
            )),
            RichText(text: TextSpan(
              children: [
                TextSpan(
                  text: 'Genres: ',
                  style: AppTextTheme.captionTextBold
                ),
                TextSpan(
                  text: ' The genres associated with the anime.',
                  style: AppTextTheme.captionText
                )
              ]
            )),
            RichText(text: TextSpan(
              children: [
                TextSpan(
                  text: 'Demographic: ',
                  style: AppTextTheme.captionTextBold
                ),
                TextSpan(
                  text: ' The target audience of the anime, such as ',
                  style: AppTextTheme.captionText
                ),
                TextSpan(
                  text: ' Shounen, Shoujo, Seinen, Josei, or Kodomomuke',
                  style: AppTextTheme.captionTextBold
                ),
                TextSpan(
                  text: ' .Not Specified will be displayed if the anime does not have an official demographic.',
                  style: AppTextTheme.captionText
                ),
              ]
            )),
            RichText(text: TextSpan(
              children: [
                TextSpan(
                  text: 'Studio: ',
                  style: AppTextTheme.captionTextBold
                ),
                TextSpan(
                  text: ' The animation studio responsible for producing the anime. Multiple studios may be shown if more than one studio was involved.',
                  style: AppTextTheme.captionText
                )
              ]
            )),
            RichText(text: TextSpan(
              children: [
                TextSpan(
                  text: 'Source: ',
                  style: AppTextTheme.captionTextBold
                ),
                TextSpan(
                  text: ' The original source material the anime is based on, such as ',
                  style: AppTextTheme.captionText
                ),
                TextSpan(
                  text: 'Manga, Visual Novel, Novel, Light Novel, Webcomic, or Video Game.',
                  style: AppTextTheme.captionTextBold
                )
              ]
            )),
            RichText(text: TextSpan(
              children: [
                TextSpan(
                  text: 'Format: ',
                  style: AppTextTheme.captionTextBold
                ),
                TextSpan(
                  text: ' How the anime was released, such as ',
                  style: AppTextTheme.captionText
                ),
                TextSpan(
                  text: ' TV, Movie, OVA, or ONA.',
                  style: AppTextTheme.captionTextBold
                )
              ]
            )),

            SizedBox(height: AppSpacing.bs),
            Text('Clues Indicator', style: AppTextTheme.headingSmall),
            Text('Correct: The guess exactly matches the secret anime for that clue.', style:AppTextTheme.captionTextCorrect),
            Text('Partial: The guess partially matches the secret anime for that clue.', style:AppTextTheme.captionTextPartial),
            Text('Incorrect: The guess does not match the secret anime for that clue.', style:AppTextTheme.captionTextIncorrect),
            Text('Higher / Lower: The guessed value is either higher or lower than the secret anime\'s value.', style:AppTextTheme.captionTextComparison),
            RichText(text: TextSpan(
              text: 'If ',
              style: AppTextTheme.captionText,
              children: [
                TextSpan(
                  text: 'all clues are green',
                  style: AppTextTheme.captionTextCorrect
                ),
                TextSpan(
                  text: ', you have successfully guessed the secret anime.',
                )
              ]
            )),

            SizedBox(height: AppSpacing.bs),
            Text('Daily Mode', style: AppTextTheme.headingSmall),
            RichText(text: TextSpan(
              text: 'In ',
              style: AppTextTheme.captionText,
              children: [
                TextSpan(
                  text: 'Daily Mode',
                  style: AppTextTheme.captionTextBold
                ),
                TextSpan(
                  text: ', you have ',
                ),
                TextSpan(
                  text: '7 attempts ',
                  style: AppTextTheme.captionTextBold
                ),
                TextSpan(
                  text: 'to guess the secret anime.',
                ),
              ]
            )),

            SizedBox(height: AppSpacing.bs),
            Text('Practice Mode', style: AppTextTheme.headingSmall),
            RichText(text: TextSpan(
              text: 'In ',
              style: AppTextTheme.captionText,
              children: [
                TextSpan(
                  text: 'Practice Mode',
                  style: AppTextTheme.captionTextBold
                ),
                TextSpan(
                  text: ', you have ',
                ),
                TextSpan(
                  text: 'unlimited attempts ',
                  style: AppTextTheme.captionTextBold
                ),
                TextSpan(
                  text: 'to guess the secret anime.',
                ),
              ]
            )),
            Text('Additional clues are unlocked as you make more attempts:', style: AppTextTheme.captionText),
            RichText(text: TextSpan(
              children: [
                TextSpan(
                  text: '  •	3rd Attempt: ',
                  style: AppTextTheme.captionTextBold,
                ),
                TextSpan(
                  text: 'A clue about the anime\'s current status, based on information available as of ',
                  style: AppTextTheme.captionText
                ),
                TextSpan(
                  text: 'October 3, 2026 ',
                  style: AppTextTheme.captionTextBold
                ),
                TextSpan(
                  text: ', is revealed.',
                  style: AppTextTheme.captionText
                ),
              ]
            )),
            RichText(text: TextSpan(
              children: [
                TextSpan(
                  text: '  •	7th Attempt: ',
                  style: AppTextTheme.captionTextBold,
                ),
                TextSpan(
                  text: 'A short synopsis of the anime is revealed.',
                  style: AppTextTheme.captionText
                ),
              ]
            )),
            RichText(text: TextSpan(
              text: 'Once you complete a Practice Mode session, you can  ',
              style: AppTextTheme.captionText,
              children: [
                TextSpan(
                  text: 'play again as many times as you like.',
                  style: AppTextTheme.captionTextBold
                ),
              ]
            )),
          ],
        );
      
      case MinigameType.character:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.bs,
          children: [
            SizedBox(height: AppSpacing.sm),
            RichText(text: TextSpan(
              text: 'In this minigame, your goal is to guess the ',
              style: AppTextTheme.captionText,
              children: [
                TextSpan(
                  text: 'secret character ',
                  style: AppTextTheme.captionTextBold
                ),
                TextSpan(
                  text: 'based on the clues provided.',
                )
              ]
            )),
            Text('First, enter the name of any anime character. The game will compare your guess with the secret character and provide clues to help you find the correct answer.', style: AppTextTheme.captionText),

            SizedBox(height: AppSpacing.bs),
            Text('Clues', style: AppTextTheme.headingSmall),
            RichText(text: TextSpan(
              children: [
                TextSpan(
                  text: 'Anime: ',
                  style: AppTextTheme.captionTextBold
                ),
                TextSpan(
                  text: ' The anime series that the character appears in.',
                  style: AppTextTheme.captionText
                )
              ]
            )),
            RichText(text: TextSpan(
              children: [
                TextSpan(
                  text: 'Hair: ',
                  style: AppTextTheme.captionTextBold
                ),
                TextSpan(
                  text: ' The character\'s hair color. Multiple hair colors may be provided if the character\'s hair color changes throughout the anime.',
                  style: AppTextTheme.captionText
                )
              ]
            )),
            RichText(text: TextSpan(
              children: [
                TextSpan(
                  text: 'Eye: ',
                  style: AppTextTheme.captionTextBold
                ),
                TextSpan(
                  text: ' The character\'s eye color. Multiple hair colors may be provided if the character\'s hair color changes throughout the anime.',
                  style: AppTextTheme.captionText
                )
              ]
            )),
            RichText(text: TextSpan(
              children: [
                TextSpan(
                  text: 'Sex: ',
                  style: AppTextTheme.captionTextBold
                ),
                TextSpan(
                  text: ' The character\'s sex, such as ',
                  style: AppTextTheme.captionText
                ),
                TextSpan(
                  text: 'Male or Female.',
                  style: AppTextTheme.captionTextBold
                ),
              ]
            )),
            RichText(text: TextSpan(
              children: [
                TextSpan(
                  text: 'Species: ',
                  style: AppTextTheme.captionTextBold
                ),
                TextSpan(
                  text: ' The character\'s species or race, such as ',
                  style: AppTextTheme.captionText
                ),
                TextSpan(
                  text: 'Human, Demon, Elf, ',
                  style: AppTextTheme.captionTextBold
                ),
                TextSpan(
                  text: 'or other applicable species.',
                  style: AppTextTheme.captionText
                ),
              ]
            )),
            RichText(text: TextSpan(
              children: [
                TextSpan(
                  text: 'Occupation: ',
                  style: AppTextTheme.captionTextBold
                ),
                TextSpan(
                  text: ' The character\'s occupation or role, such as  ',
                  style: AppTextTheme.captionText
                ),
                TextSpan(
                  text: 'Student, Teacher, Soldier, ',
                  style: AppTextTheme.captionTextBold
                ),
                TextSpan(
                  text: 'or other applicable occupations.',
                  style: AppTextTheme.captionText
                ),
              ]
            )),
            RichText(text: TextSpan(
              children: [
                TextSpan(
                  text: 'Affiliation: ',
                  style: AppTextTheme.captionTextBold
                ),
                TextSpan(
                  text: ' An organization, group, faction, or other entity that the character is associated with.',
                  style: AppTextTheme.captionText
                )
              ]
            )),
            RichText(text: TextSpan(
              children: [
                TextSpan(
                  text: 'Status: ',
                  style: AppTextTheme.captionTextBold
                ),
                TextSpan(
                  text: ' The character\'s current status, such as ',
                  style: AppTextTheme.captionText
                ),
                TextSpan(
                  text: 'Alive, Deceased,',
                  style: AppTextTheme.captionTextBold
                ),
                TextSpan(
                  text: ' or other applicable status.',
                  style: AppTextTheme.captionText
                ),
              ]
            )),
            RichText(text: TextSpan(
              children: [
                TextSpan(
                  text: 'Power System: ',
                  style: AppTextTheme.captionTextBold
                ),
                TextSpan(
                  text: ' The power system or abilities associated with the character\'s anime, if applicable. Not Specified will be displayed if the anime does not have a defined power system.',
                  style: AppTextTheme.captionText
                )
              ]
            )),

            SizedBox(height: AppSpacing.md),
            Text('Clues Indicator', style: AppTextTheme.headingSmall),
            Text('Correct: The guess exactly matches the secret character for that clue.', style:AppTextTheme.captionTextCorrect),
            Text('Partial: The guess partially matches the secret character for that clue.', style:AppTextTheme.captionTextPartial),
            Text('Incorrect: The guess does not match the secret character for that clue.', style:AppTextTheme.captionTextIncorrect),
            RichText(text: TextSpan(
              text: 'If ',
              style: AppTextTheme.captionText,
              children: [
                TextSpan(
                  text: 'all clues are green',
                  style: AppTextTheme.captionTextCorrect
                ),
                TextSpan(
                  text: ', you have successfully guessed the secret character.',
                )
              ]
            )),
            
            SizedBox(height: AppSpacing.md),
            Text('Daily Mode', style: AppTextTheme.headingSmall),
            RichText(text: TextSpan(
              text: 'In ',
              style: AppTextTheme.captionText,
              children: [
                TextSpan(
                  text: 'Daily Mode',
                  style: AppTextTheme.captionTextBold
                ),
                TextSpan(
                  text: ', you have ',
                ),
                TextSpan(
                  text: '7 attempts ',
                  style: AppTextTheme.captionTextBold
                ),
                TextSpan(
                  text: 'to guess the secret character.',
                ),
              ]
            )),

            SizedBox(height: AppSpacing.md),
            Text('Practice Mode', style: AppTextTheme.headingSmall),
            RichText(text: TextSpan(
              text: 'In ',
              style: AppTextTheme.captionText,
              children: [
                TextSpan(
                  text: 'Practice Mode',
                  style: AppTextTheme.captionTextBold
                ),
                TextSpan(
                  text: ', you have ',
                ),
                TextSpan(
                  text: 'unlimited attempts ',
                  style: AppTextTheme.captionTextBold
                ),
                TextSpan(
                  text: 'to guess the secret character.',
                ),
              ]
            )),
            Text('Additional clues are unlocked as you make more attempts:', style: AppTextTheme.captionText),
             RichText(text: TextSpan(
              children: [
                TextSpan(
                  text: '  •	3rd Attempt: ',
                  style: AppTextTheme.captionTextBold,
                ),
                TextSpan(
                  text: 'A clue about the character\'s signature style, alias, belongings, etc. is provided.',
                  style: AppTextTheme.captionText
                ),
              ]
            )),
            RichText(text: TextSpan(
              children: [
                TextSpan(
                  text: '  •	7th Attempt: ',
                  style: AppTextTheme.captionTextBold,
                ),
                TextSpan(
                  text: 'A quote said by the character is provided.',
                  style: AppTextTheme.captionText
                ),
              ]
            )),
            RichText(text: TextSpan(
              text: 'Once you complete a Practice Mode session, you can  ',
              style: AppTextTheme.captionText,
              children: [
                TextSpan(
                  text: 'play again as many times as you like.',
                  style: AppTextTheme.captionTextBold
                ),
              ]
            )),

          ],
        );

      case MinigameType.soundtrack:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.bs,
          children: [
            SizedBox(height: AppSpacing.sm),
            RichText(text: TextSpan(
              text: 'In this minigame, your goal is to guess the ',
              style: AppTextTheme.captionText,
              children: [
                TextSpan(
                  text: 'anime that the soundtrack is from',
                  style: AppTextTheme.captionTextBold
                ),
                TextSpan(
                  text: '.',
                )
              ]
            )),
            Text('Listen to the soundtrack and use the clues provided to identify the anime it belongs to.', style: AppTextTheme.captionText),

            SizedBox(height: AppSpacing.bs),
            Text('Clues Indicator', style: AppTextTheme.headingSmall),
            Text('Correct: The guess matches the secret anime of the soundtrack.', style: AppTextTheme.captionTextCorrect),
            Text('Incorrect: The guess does not match the secret anime of the soundtrack.', style: AppTextTheme.captionTextIncorrect),
            RichText(text: TextSpan(
              text: 'If the ',
              style: AppTextTheme.captionText,
              children: [
                TextSpan(
                  text: 'guess is green',
                  style: AppTextTheme.captionTextCorrect
                ),
                TextSpan(
                  text: ', you have successfully guessed the anime the soundtrack is from.',
                )
              ]
            )),

            SizedBox(height: AppSpacing.bs),
            Text('Daily Mode', style: AppTextTheme.headingSmall),
            RichText(text: TextSpan(
              text: 'In ',
              style: AppTextTheme.captionText,
              children: [
                TextSpan(
                  text: 'Daily Mode',
                  style: AppTextTheme.captionTextBold
                ),
                TextSpan(
                  text: ', you have ',
                ),
                TextSpan(
                  text: '7 attempts ',
                  style: AppTextTheme.captionTextBold
                ),
                TextSpan(
                  text: 'to guess the anime of the soundtrack.',
                ),
              ]
            )),

            SizedBox(height: AppSpacing.bs),
            Text('Practice Mode', style: AppTextTheme.headingSmall),
            RichText(text: TextSpan(
              text: 'In ',
              style: AppTextTheme.captionText,
              children: [
                TextSpan(
                  text: 'Practice Mode',
                  style: AppTextTheme.captionTextBold
                ),
                TextSpan(
                  text: ', you have ',
                ),
                TextSpan(
                  text: 'unlimited attempts ',
                  style: AppTextTheme.captionTextBold
                ),
                TextSpan(
                  text: 'to guess the anime of the soundtrack.',
                ),
              ]
            )),
            Text('Additional clues are unlocked as you make more attempts:', style: AppTextTheme.captionText),
            RichText(text: TextSpan(
              children: [
                TextSpan(
                  text: '  •	3rd Attempt: ',
                  style: AppTextTheme.captionTextBold,
                ),
                TextSpan(
                  text: 'The soundtrack type such as opening, ending or insert is revealed.',
                  style: AppTextTheme.captionText
                ),
              ]
            )),
            RichText(text: TextSpan(
              children: [
                TextSpan(
                  text: '  •	7th Attempt: ',
                  style: AppTextTheme.captionTextBold,
                ),
                TextSpan(
                  text: 'The artist is revealed.',
                  style: AppTextTheme.captionText
                ),
              ]
            )),
            RichText(text: TextSpan(
              text: 'Once you complete a Practice Mode session, you can  ',
              style: AppTextTheme.captionText,
              children: [
                TextSpan(
                  text: 'play again as many times as you like.',
                  style: AppTextTheme.captionTextBold
                ),
              ]
            )),
          ],
        );
    
    }
  }
}