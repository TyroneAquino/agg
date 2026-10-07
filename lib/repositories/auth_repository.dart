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

  //create 
  static Future<void> createAccount({
    required String email,
    required String password,
  })async{
    final user = currentUser;

    if(user == null){
      throw Exception(
        'No user is currently signed in.',
      );
    }

    if(!user.isAnonymous){
      throw Exception(
        'This user already has a permanent account.',
      );
    }

    debugPrint(
      'Converting anonymous user ${user.id} '
      'into permanent account.',
    );

    await _supabase.auth.updateUser(UserAttributes(email: email.trim()));

    /*
     * If email confirmation is enabled in Supabase,
     * the password must be set after the email has
     * been verified.
     *
     * If confirmation is disabled, this can be done
     * immediately.
    */
  }

  static Future<void> setPassword(
    String password
  )async{
    final user = currentUser;

    if(user == null){
      throw Exception(
        'No user is currently signed in.',
      );
    }

    await _supabase.auth.updateUser(UserAttributes(password: password));

  }

  // log in another device

  static Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _supabase.auth.signInWithPassword(email: email.trim(), password: password);

    debugPrint('Signed in as ${currentUser?.id}',);
  }

  //sign out

  static Future<void> signOut() async{
    await _supabase.auth.signOut();

    debugPrint('User signed out');
  }
}
