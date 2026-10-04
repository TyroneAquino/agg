import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:agg/models/soundtrack_class.dart';

class SoundtrackRepository {
  static final SupabaseClient _supabase = Supabase.instance.client;
  static List<String>? _cachedNames;

  static Future<List<String>> getNames() async{
    // Already loaded → return cache
    if (_cachedNames != null) {
      return _cachedNames!;
    }

    final response = await _supabase
      .from('soundtrack')
      .select('anime');

    _cachedNames = response
      .map<String>((row) => row['anime'] as String)
      .toList();

    return _cachedNames!;
  }

  static Future<Soundtrack> getSoundtrack(String guess) async{
    final Map<String, dynamic> response = await _supabase
      .from('soundtrack')
      .select()
      .eq('anime', guess)
      .limit(1)
      .single();

    print('soundtrack RESPONSE: $response');
    return Soundtrack.fromJson(response);
  }

  static Future<Soundtrack> getSoundtrackById(int id) async{
    final Map<String, dynamic> response = await _supabase
      .from('soundtrack')
      .select()
      .eq('id', id)
      .single();

    print('soundtrack RESPONSE: $response');
    return Soundtrack.fromJson(response);
  }
}
