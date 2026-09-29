import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:agg/models/player_stats.dart';
import 'package:agg/enums/minigame_type.dart';
import 'package:flutter/foundation.dart'; 

class StatsRepository {
   static final SupabaseClient _supabase = Supabase.instance.client;

   static String get _userId{
    final user = _supabase.auth.currentUser;

    if(user==null){
      throw Exception('Player not signed in.');
    }

    return user.id;
   }

   static const animeDaily = 'animeDaily';
   static const characterDaily = 'characterDaily';
   static const soundtrackDaily = 'soundtrackDaily';

  static Future<Map<String, PlayerStats>> loadAll() async{
    debugPrint('Loading stats for user: $_userId');
    final response = await _supabase
      .from('player_stats')
      .select('stats')
      .eq('user_id', _userId)
      .maybeSingle();

    final rawStats = response?['stats'];

    Map<String, dynamic> json = {};
    if(rawStats is Map){
      json = Map<String, dynamic>.from(rawStats);
    }

    final result = <String, PlayerStats>{
      animeDaily: PlayerStats.fromJson(_toMap(json[animeDaily])),
      characterDaily: PlayerStats.fromJson(_toMap(json[characterDaily])),
      soundtrackDaily: PlayerStats.fromJson(_toMap(json[soundtrackDaily]))
    };

    return result;
  }

  static Map<String, dynamic>? _toMap(dynamic value){
    if (value is Map){
      return Map<String, dynamic>.from(value);
    }
    return null;
  }

  static Future<void> _saveAll(Map<String, PlayerStats> allStats) async {
    final payload = {
      'user_id' : _userId,
      'stats': {
        for(final entry in allStats.entries)
          entry.key: entry.value.toJson(),
      }
    };

    debugPrint('Saving player stats payload: $payload');

    final response =await _supabase
      .from('player_stats')
      .upsert(payload, onConflict: 'user_id')
      .select('user_id, stats, updated_at')
      .single();

     debugPrint('Supabase saved player stats: $response');
  }

  static Future<PlayerStats> recordResult({
    required MinigameType minigame, 
    required bool won, 
    required int guesses, 
    required String puzzleKey
  }) async {
    debugPrint('========== RECORDING DAILY RESULT ==========');
    debugPrint('User ID: $_userId');
    debugPrint('Minigame: $minigame');
    debugPrint('Won: $won');
    debugPrint('Guesses: $guesses');
    debugPrint('Puzzle key: $puzzleKey');

    if (guesses <= 0) {
      throw ArgumentError.value(
        guesses,
        'guesses',
        'Must be greater than zero.',
      );
    }

    final allStats = await loadAll();

    final key = switch(minigame){
      MinigameType.anime => animeDaily,
      MinigameType.character => characterDaily,
      MinigameType.soundtrack => soundtrackDaily
    };

    final stats = allStats[key]!;

    if(stats.lastRecordedPuzzle == puzzleKey){
      return stats;
    }

    stats.puzzlesPlayed++;

    if(won){
      stats.puzzlesSolved++;
      stats.totalGuesses += guesses;

      if(guesses == 1){
        stats.oneShots++;
      }

      stats.currentStreak++;

      if (stats.currentStreak > stats.longestStreak) {
        stats.longestStreak = stats.currentStreak;
      }

    } else  {
      stats.currentStreak = 0;
    }
    
    stats.lastRecordedPuzzle = puzzleKey; 

    await _saveAll(allStats);
    final savedStats = (allStats);

    debugPrint(
      'Verified saved stats: ${savedStats[key]!.toJson()}',
    );
    debugPrint('========== DAILY RESULT RECORDED ==========');

    return stats;
  }

}