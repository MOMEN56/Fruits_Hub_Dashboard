import 'package:supabase_flutter/supabase_flutter.dart';

import 'data_service.dart';

class SubastoreService implements DatabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  @override
  Future<void> addData({
    required String path, // هنا path = table name
    required Map<String, dynamic> data,
    String? documentId, // optional, لو حبيت تحدد الـ id
  }) async {
    final table = _client.from(path);

    if (documentId != null) {
      // upsert row with specified id
      await table.upsert({'id': documentId, ...data});
    } else {
      // insert new row
      await table.insert(data);
    }
  }

  @override
  Future<Map<String, dynamic>> getData({
    required String path,
    required String docuementId,
  }) async {
    final table = _client.from(path);
    final response = await table.select().eq('id', docuementId).single();
    return response;
  }

  @override
  Future<bool> checkIfDataExists({
    required String path,
    required String docuementId,
  }) async {
    final table = _client.from(path);
    final response = await table.select().eq('id', docuementId);
    return response.isNotEmpty;
  }
}
