import 'package:agg/enums/minigame_type.dart';
import 'package:flutter/material.dart';
import 'package:agg/constants/app_themes.dart';
import 'package:agg/screens/anime.dart';
import 'package:agg/screens/character.dart';
import 'package:agg/screens/soundtrack.dart';

class Minigame{
  final String name;
  final String description;
  final String prompt;
  final String instruction;
  final String icon;
  final Color color;
  final Widget page;

  const Minigame({
      required this.name,
      required this.description,
      required this.prompt,
      required this.instruction,
      required this.icon,
      required this.color,
      required this.page,
    });
}

Minigame getMinigame(MinigameType minigame){
  switch(minigame){
    case MinigameType.anime:
      return Minigame(
        name: 'Anime',
        description: 'Guess the Anime',
        prompt: 'Guess today\'s anime series',
        instruction: 'Start by guessing any anime series',
        icon: 'tv',
        color: AppColors.anime,
        page: const AnimeScreen(),
      );

    case MinigameType.character:
      return Minigame(
        name: 'Character',
        description: 'Guess the Character',
        prompt: 'Guess today\'s anime character',
        instruction: 'Start by guessing an anime character',
        icon: 'person',
        color: AppColors.character,
        page: const CharacterScreen(),
      );

    case MinigameType.soundtrack:
      return Minigame(
        name: 'Soundtrack',
        description: 'Guess the Soundtrack',
        prompt: 'Guess which anime today\'s soundtrack belongs',
        instruction: '',
        icon: 'sound',
        color: AppColors.soundtrack,
        page: const SoundtrackScreen(),
      );
          
  }
}