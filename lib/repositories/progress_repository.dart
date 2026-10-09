import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:agg/states/game_state.dart';
import 'package:agg/models/anime_class.dart';
import 'package:agg/models/character_class.dart';
import 'package:agg/models/soundtrack_class.dart';
import 'package:agg/repositories/anime_repository.dart';
import 'package:agg/repositories/character_repository.dart';
import 'package:agg/repositories/soundtrack_repository.dart';

class ProgressRepository {
  static final SupabaseClient _supabase = Supabase.instance.client;

  static String get _userId{
    final user = _supabase.auth.currentUser;

    if(user==null){
      throw Exception('Player not signed in');
    }

    return user.id; 
  }

  static String _today(){
    final now = DateTime.now();
    final y = now.year.toString().padLeft(4, '0');
    final m = now.month.toString().padLeft(2, '0');
    final d = now.day.toString().padLeft(2, '0');
    
    return '$y-$m-$d';
  }

  //---------------save-------------

  static Future<void> save(GameState gameState) async {
    try{
      final progress = gameState.toJson(dailyDate: _today());

      await _supabase.from('player_progress').upsert({
        'user_id': _userId,
        'progress': progress,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      });

    }catch(e){
      debugPrint('Could not save progress: $e');
    }
  }

  //---------------restore-------------

  static Future<void> restore(GameState gameState) async {
    final response = await _supabase
      .from('player_progress')
      .select('progress')
      .eq('user_id', _userId)
      .maybeSingle();

    if (response == null){return;}

    final raw = response['progress'];
    if (raw is! Map) {return;}

    final progress = Map<String, dynamic>.from(raw);

    // Don't restore yesterday's daily puzzle.
    if (progress['dailyDate'] != _today()) return;
  
    final anime = _section(progress['anime']);
    final character = _section(progress['character']);
    final soundtrack = _section(progress['soundtrack']);

    final results = await Future.wait([
      _loadGuesses<Anime>(_names(anime['guesses']), AnimeRepository.getAnime),
      _loadGuesses<Character>(_names(character['guesses']), CharacterRepository.getCharacter),
      _loadGuesses<Soundtrack>(_names(soundtrack['guesses']), SoundtrackRepository.getSoundtrack),
    ]);

    gameState.dailyAnimeGuesses = results[0] as List<Anime>;
    gameState.dailyAnimeAttempts = _int(anime['attempts']);
    gameState.dailyAnimeCompleted = anime['completed'] == true;

    gameState.dailyCharacterGuesses = results[1] as List<Character>;
    gameState.dailyCharacterAttempts = _int(character['attempts']);
    gameState.dailyCharacterCompleted = character['completed'] == true;

    gameState.dailySoundtrackGuesses = results[2] as List<Soundtrack>;
    gameState.dailySoundtrackAttempts = _int(soundtrack['attempts']);
    gameState.dailySoundtrackCompleted = soundtrack['completed'] == true;

    gameState.removeGuessedDailyNames();
  }
    
  //---------------hekpers-------------

  static Map<String, dynamic> _section(dynamic value) => value is Map ? Map<String, dynamic>.from(value) : <String, dynamic>{};

  static List<String> _names(dynamic value) => value is List ? value.whereType<String>().toList() : <String>[];

  static int _int(dynamic value) => value is num ? value.toInt() : 0;

  /// Fetches each guess by name. A name that can no longer be found
  /// (renamed or removed from the database) is skipped instead of
  /// failing the whole restore.
  static Future<List<T>> _loadGuesses<T>(
    List<String> names,
    Future<T> Function(String name) fetch,
  ) async {
    final loaded = await Future.wait(names.map((name) async {
      try {
        return await fetch(name);
      } catch (e) {
        debugPrint('Could not restore guess "$name": $e');
        return null;
      }
    }));

    return loaded.whereType<T>().toList();
  }

  

}