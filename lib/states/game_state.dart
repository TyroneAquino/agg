import 'package:agg/models/anime_class.dart';
import 'package:agg/models/character_class.dart';
import 'package:agg/models/soundtrack_class.dart';
import 'package:agg/models/player_stats.dart';

class GameState{
  //Anime game states
  bool animeNamesInitialized = false;
  PlayerStats? animeStats;
  //anime daily
  Anime? dailyAnimeAnswer;
  List<String> dailyAnimeNames = []; //available guesses
  List<Anime> dailyAnimeGuesses = []; //guesses attempted by the user
  int dailyAnimeAttempts = 0; //attempts
  bool dailyAnimeCompleted = false; //flag for completion
  //anime practice
  Anime? practiceAnimeAnswer;
  List<String> practiceAnimeNames = [];
  List<Anime> practiceAnimeGuesses = [];
  int practiceAnimeAttempts = 0; //attempts
  bool practiceAnimeCompleted = false;

  //Character game states
  bool characterNamesInitialized = false;
  PlayerStats? characterStats;
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
  int practiceCharacterAttempts = 0;
  bool practiceCharacterCompleted = false;

  //Soundtrack game states
  bool soundtrackNamesInitialized = false;
  PlayerStats? soundtrackStats;
  //Soundtrack daily
  Soundtrack? dailySoundtrackAnswer;
  List<String> dailySoundtrackNames = [];
  List<Soundtrack> dailySoundtrackGuesses = [];
  int dailySoundtrackAttempts = 0;
  bool dailySoundtrackCompleted = false;
  //Soundtrack practice
  Soundtrack? practiceSoundtrackAnswer;
  List<String> practiceSoundtrackNames = [];
  List<Soundtrack> practiceSoundtrackGuesses = [];
  int practiceSoundtrackAttempts = 0;
  bool practiceSoundtrackCompleted = false;

  Map<String, dynamic> toJson({
    required String dailyDate,
  }){
    return{
      'dailyDate': dailyDate,

      'anime':{
        'attempts': dailyAnimeAttempts,
        'completed': dailyAnimeCompleted,
        'guesses': dailyAnimeGuesses.map((anime) => anime.name).toList(),
      },

      'character':{
        'attempts': dailyCharacterAttempts,
        'completed': dailyCharacterCompleted,
        'guesses': dailyCharacterGuesses.map((character) => character.name).toList(),
      },

      'soundtrack':{
        'attempts': dailySoundtrackAttempts,
        'completed': dailySoundtrackCompleted,
        'guesses': dailySoundtrackGuesses.map((soundtrack) => soundtrack.anime).toList(),
      },
    };
  }

  void clearDailyProgress(){
    dailyAnimeGuesses.clear();
    dailyAnimeAttempts = 0;
    dailyAnimeCompleted = false;

    dailyCharacterGuesses.clear();
    dailyCharacterAttempts = 0;
    dailyCharacterCompleted = false;

    dailySoundtrackGuesses.clear();
    dailySoundtrackAttempts = 0;
    dailySoundtrackCompleted = false;
  }
}