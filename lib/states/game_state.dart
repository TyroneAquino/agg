import 'package:agg/models/anime_class.dart';
import 'package:agg/models/character_class.dart';

class GameState{
  //Anime game states
  bool animeNamesInitialized = false;
  //anime daily
  Anime? dailyAnimeAnswer;
  List<String> dailyAnimeNames = []; //available guesse
  List<Anime> dailyAnimeGuesses = []; //guesses attempted by the user
  int dailyAnimeAttempts = 0; //attempts
  bool dailyAnimeCompleted = false; //flag for completion
  //anime practice
  Anime? practiceAnimeAnswer;
  List<String> practiceAnimeNames = [];
  List<Anime> practiceAnimeGuesses = [];
  bool practiceAnimeCompleted = false;

  //Character game states
  bool characterNamesInitialized = false;
  //character daily
  Character? dailyCharacterAnswer;
  List<String> dailyCharacterNames = [];
  List<Character> dailyCharacterGuesses = [];
  int dailyCharacterAttempts = 0;
  bool dailyCharacterCompleted = false;
  //character practice
  Character? practiceCharacterAnswer;
  List<String> practiceCharacterNames = [];
  List<Character> practiceCharacterGuesses = [];
  bool practiceCharacterCompleted = false;
  
}