import 'package:agg/models/anime_class.dart';
import 'package:agg/models/character_class.dart';

class GameState{
  //Anime game states
  List<Anime> animeGuesses = [];
  Anime? animeAnswer;
  //anime daily
  List<String> dailyAnimeNames = [];
  bool animeNamesInitialized = false;

  //Character game states
  List<Character> characterGuesses = [];
  Character? characterAnswer;
  //character daily
  List<String> dailyCharacterNames = [];
  bool characterNamesInitialized = false;
}