import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:agg/models/character_class.dart';

class CharacterRepository {
  static final SupabaseClient _supabase = Supabase.instance.client;
  static List<String>? _cachedNames;

  static Future<List<String>> getNames() async {
    // Already loaded → return cache
    if (_cachedNames != null) {
      return _cachedNames!;
    }
     // First request → get data from Supabase
    final response = await _supabase
        .from('character')
        .select('name');

     _cachedNames = response
        .map<String>((row) => row['name'] as String)
        .toList();

    return _cachedNames!;
  }

  static Future<Character> getCharacter(String guess) async{
    final Map<String, dynamic> response = await _supabase
      .from('character')
      .select()
      .eq('name',guess)
      .single();
    
    print('CHARACTER RESPONSE: $response');

    return Character.fromJson(response);
  }
}