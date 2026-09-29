import 'package:flutter/foundation.dart'; 
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  static final SupabaseClient _supabase = Supabase.instance.client;
  
  static Future<void> ensureSignedIn() async {
    debugPrint('User before sign-in: ${_supabase.auth.currentUser?.id}');
    
    if(_supabase.auth.currentUser != null){
       debugPrint('Existing session restored.');
      return;
    }

    debugPrint('No session found. Creating anonymous user...');

    final response = await _supabase.auth.signInAnonymously();
    debugPrint('Signed-in user: ${response.user?.id}');
    if (response.user == null){
      throw Exception('Could not create an anonymous user.');
    }
  }

}
