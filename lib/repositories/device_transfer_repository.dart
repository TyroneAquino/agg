import 'package:supabase_flutter/supabase_flutter.dart';

class DeviceTransferRepository {
  static final SupabaseClient _supabase =
      Supabase.instance.client;

  static Future<String> generateCode() async {
    final response =
        await _supabase.functions.invoke(
      'device-transfer',
      body: {
        'action': 'generate',
      },
    );

    if (response.data == null) {
      throw Exception(
        'Failed to generate transfer code.',
      );
    }

    final data =
        Map<String, dynamic>.from(response.data);

    if (data['error'] != null) {
      throw Exception(data['error']);
    }

    return data['code'] as String;
  }

  static Future<void> transferProgress(
    String code,
  ) async {
    final response =
        await _supabase.functions.invoke(
      'device-transfer',
      body: {
        'action': 'transfer',
        'code': code,
      },
    );

    if (response.data == null) {
      throw Exception(
        'Transfer failed.',
      );
    }

    final data =
        Map<String, dynamic>.from(response.data);

    if (data['error'] != null) {
      throw Exception(data['error']);
    }

    if (data['success'] != true) {
      throw Exception(
        'Transfer failed.',
      );
    }
  }
}