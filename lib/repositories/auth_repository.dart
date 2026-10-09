import 'package:flutter/foundation.dart'; 
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  static final SupabaseClient _supabase = Supabase.instance.client;
  
  //current user

  static User? get currentUser => _supabase.auth.currentUser;
  static bool get isSignedIn => currentUser != null;
  static bool get isAnonymous => currentUser?.isAnonymous ?? true;
  static String? get email => currentUser?.email;

  //initial authentication

  static Future<void> ensureSignedIn() async {
    debugPrint('User before sign-in: ${currentUser?.id}');
    
    if(currentUser != null){
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
