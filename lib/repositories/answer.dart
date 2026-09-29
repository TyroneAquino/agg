import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:agg/models/anime_class.dart';
import 'package:agg/models/character_class.dart';
import 'dart:math';


class DailyAnswerRepository{
  static final SupabaseClient _supabase = Supabase.instance.client;
  
  static String _today(){
    final now = DateTime.now();

    final year = now.year.toString().padLeft(4, '0');
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  static Future<Map<String, dynamic>> _getTodaySchedule() async {
    final response = await _supabase
     .from('daily_answers')
     .select()
     .eq('date', _today())
     .single();

     return Map<String, dynamic>.from(response);
  }

    static Future<Anime> getAnimeAnswer() async {
      final schedule = await _getTodaySchedule();
      final answerId = schedule['answer_anime'] as int;

      final response = await _supabase
        .from('anime')
        .select()
        .eq('id', answerId)
        .single();

      return Anime.fromJson(response);
    }

    static Future<Character> getCharacterAnswer() async {
      final schedule = await _getTodaySchedule();
      final answerId = schedule['answer_character'] as int;

      final response = await _supabase
        .from('character')
        .select()
        .eq('id', answerId)
        .single();

      return Character.fromJson(response);
    }
}

class PracticeAnswer{
  static final SupabaseClient _supabase = Supabase.instance.client;
  static final Random _random = Random();

    static Future<Anime> getAnimeAnswer() async {
      final response = await _supabase
      .from('anime')
      .select()
      .eq('id', _random.nextInt(55) + 1)
      .single();

      return Anime.fromJson(response);
    }

    static Future<Character> getCharacterAnswer() async {
      final response = await _supabase
      .from('character')
      .select()
      .eq('id', _random.nextInt(65) + 1)
      .single();

      return Character.fromJson(response);
    }    
    
    


}