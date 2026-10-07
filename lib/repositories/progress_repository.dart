import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:agg/states/game_state.dart';
import 'package:agg/models/anime_class.dart';
import 'package:agg/models/character_class.dart';
import 'package:agg/models/soundtrack_class.dart';

class ProgressRepository {
  static final SupabaseClient _supabase = Supabase.instance.client;

  static String get _userId{
    final user = _supabase.auth.currentUser;

    if(user==null){
      throw Exception('Player not signed in');
    }

    return user.id; 
  }


  //save

  static Future<void> save(GameState gameState) async {
    final puzzleDate =
        DateTime.now().toIso8601String().substring(0, 10);

    final progress = {
      'dailyDate': puzzleDate,

      'anime': {
        'guesses': gameState.dailyAnimeGuesses,
        'attempts': gameState.dailyAnimeAttempts,
        'completed': gameState.dailyAnimeCompleted,
      },

      'character': {
        'guesses': gameState.dailyCharacterGuesses,
        'attempts': gameState.dailyCharacterAttempts,
        'completed': gameState.dailyCharacterCompleted,
      },

      'soundtrack': {
        'guesses': gameState.dailySoundtrackGuesses,
        'attempts': gameState.dailySoundtrackAttempts,
        'completed': gameState.dailySoundtrackCompleted,
      },
    };

    await _supabase
        .from('player_progress')
        .upsert({
          'user_id': _userId,
          'progress': progress,
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        });
  }
  //load

  static Future<void> restore(GameState gameState) async {
      final response = await _supabase
          .from('player_progress')
          .select('progress')
          .eq('user_id', _userId)
          .maybeSingle();

      if (response == null) {
        return;
      }

      final progress =Map<String, dynamic>.from(response['progress']);

      final savedDate = progress['dailyDate'];

      final currentDate = DateTime.now().toIso8601String().substring(0, 10);

      // Don't restore yesterday's daily puzzle.
      if (savedDate != currentDate) {
        return;
      }

      final anime =
          Map<String, dynamic>.from(progress['anime'] ?? {});

      final character =
          Map<String, dynamic>.from(progress['character'] ?? {});

      final soundtrack =
          Map<String, dynamic>.from(progress['soundtrack'] ?? {});

      gameState.dailyAnimeGuesses = List<Anime>.from(anime['guesses'] ?? []);

      gameState.dailyAnimeAttempts = anime['attempts'] ?? 0;

      gameState.dailyAnimeCompleted =anime['completed'] ?? false;

      gameState.dailyCharacterGuesses = List<Character>.from(character['guesses'] ?? []);

      gameState.dailyCharacterAttempts = character['attempts'] ?? 0;

      gameState.dailyCharacterCompleted = character['completed'] ?? false;

      gameState.dailySoundtrackGuesses = List<Soundtrack>.from(soundtrack['guesses'] ?? []);

      gameState.dailySoundtrackAttempts = soundtrack['attempts'] ?? 0;

      gameState.dailySoundtrackCompleted = soundtrack['completed'] ?? false;
  }

}