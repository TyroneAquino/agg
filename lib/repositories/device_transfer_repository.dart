import 'package:supabase_flutter/supabase_flutter.dart';

class DeviceTransferRepository {
  static final SupabaseClient _supabase = Supabase.instance.client;

  static Future<Map<String, dynamic>> _call(Map<String, dynamic> body) async {
    try {
      final response = await _supabase.functions.invoke(
        'device-transfer',
        body: body,
      );

      final data = response.data;

      if (data is! Map) {
        throw Exception('Unexpected response from the server.');
      }

      final map = Map<String, dynamic>.from(data);

      if (map['error'] != null) {
        throw Exception(map['error']);
      }

      return map;
    } on FunctionException catch (e) {
      final details = e.details;

      if (details is Map && details['error'] != null) {
        throw Exception(details['error']);
      }

      // Include the status so "404 = not deployed" or "401 = auth" is obvious.
      throw Exception('Server error (${e.status}): ${details ?? e.reasonPhrase}');
    }
  }

  static Future<String> generateCode() async {
    final data = await _call({'action': 'generate'});

    final code = data['code'];
    if (code is! String) {
      throw Exception('Failed to generate transfer code.');
    }

    return code;
  }

  static Future<void> transferProgress(String code) async {
    final data = await _call({'action': 'transfer', 'code': code});

    if (data['success'] != true) {
      throw Exception('Transfer failed.');
    }
  }
}
