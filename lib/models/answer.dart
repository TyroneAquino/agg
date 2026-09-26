import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:agg/models/anime_class.dart';
import 'package:agg/models/character_class.dart';

class DailyAnswerAnime{
  static final SupabaseClient _supabase = Supabase.instance.client;
  static int answerId = 1;

    static Future<Anime> getAnswer() async {
      final response = await _supabase
      .from('anime')
      .select()
      .eq('id', answerId)
      .single();

      return Anime.fromJson(response);
    }
}

class PracticeAnswerAnime{
  static final SupabaseClient _supabase = Supabase.instance.client;
  static int answerId = 35;

    static Future<Anime> getAnswer() async {
      final response = await _supabase
      .from('anime')
      .select()
      .eq('id', answerId)
      .single();

      return Anime.fromJson(response);
    }
}

class DailyAnswerCharacter{
  static final SupabaseClient _supabase = Supabase.instance.client;
  static int answerId = 1;

    static Future<Character> getAnswer() async {
      final response = await _supabase
      .from('character')
      .select()
      .eq('id', answerId)
      .single();

      return Character.fromJson(response);
    }
}

class PracticeAnswerCharacter{
  static final SupabaseClient _supabase = Supabase.instance.client;
  static int answerId = 54;

    static Future<Character> getAnswer() async {
      final response = await _supabase
      .from('character')
      .select()
      .eq('id', answerId)
      .single();

      return Character.fromJson(response);
    }
}