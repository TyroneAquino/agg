import 'package:agg/models/soundtrack_class.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:agg/models/anime_class.dart';
import 'package:agg/models/character_class.dart';
import 'package:agg/repositories/soundtrack_repository.dart';
import 'package:agg/repositories/anime_repository.dart';
import 'package:agg/repositories/character_repository.dart';
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

  static Future<Anime> getYesterdayAnimeAnswer() async {
    final yesterday = DateTime.now()
    .subtract(const Duration(days: 1))
    .toIso8601String()
    .substring(0, 10);

    final response = await _supabase
      .from('daily_answers')
      .select('answer_anime')
      .eq('date', yesterday)
      .single();

    final animeId = response['answer_anime'] as int;
    return AnimeRepository.getAnimeById(animeId);
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
  
  static Future<Character> getYesterdayCharacterAnswer() async {
    final yesterday = DateTime.now()
    .subtract(const Duration(days: 1))
    .toIso8601String()
    .substring(0, 10);

    final response = await _supabase
      .from('daily_answers')
      .select('answer_character')
      .eq('date', yesterday)
      .single();

    final characterId = response['answer_character'] as int;
    return CharacterRepository.getCharacterById(characterId);
  }

  static Future<Soundtrack> getSoundtrackAnswer() async {
    final schedule = await _getTodaySchedule();
    final answerId = schedule['answer_soundtrack'] as int;
    
    final response = await _supabase
      .from('soundtrack')
      .select()
      .eq('id', answerId) //answerid will always get the same soundtrack everyday
      .single();

    return Soundtrack.fromJson(response);
  }

  //yesterday's answer
  static Future<Soundtrack> getYesterdaySoundtrackAnswer() async {
    final yesterday = DateTime.now()
    .subtract(const Duration(days: 1))
    .toIso8601String()
    .substring(0, 10);

    final response = await _supabase
      .from('daily_answers')
      .select('answer_soundtrack')
      .eq('date', yesterday)
      .single();

    final soundtrackId = response['answer_soundtrack'] as int;
    return SoundtrackRepository.getSoundtrackById(soundtrackId);
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

  //locked answer for soundtrack to only simulate the minigame
  static Future<Soundtrack> getSoundtrackAnswer() async {
    final response = await _supabase
    .from('soundtrack')
    .select()
    .eq('id', 8)
    .single();

    return Soundtrack.fromJson(response);
  }     
    
}