import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'data_service.dart';

class SupabaseService implements DatabaseService {
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  Future<void> addData({
    required String path,
    required Map<String, dynamic> data,
    String? documentId,
  }) async {
    try {
      if (documentId != null) {
        await supabase.from(path).upsert(data);
        log('Upsert success for ID: $documentId');
      } else {
        await supabase.from(path).insert(data);
        log('Insert success');
      }
    } catch (e) {
      log('Add data error: $e');
      throw Exception('Add data failed: $e');
    }
  }

  @override
  Future<dynamic> getData({
    required String path,
    String? documentId,
    Map<String, dynamic>? query,
  }) async {
    try {
      if (documentId != null) {
        return await supabase
            .from(path)
            .select()
            .eq('id', documentId)
            .maybeSingle();
      } else {
        dynamic q = supabase.from(path).select();
        if (query != null) {
          if (query['orderBy'] != null) {
            q = q.order(query['orderBy'], ascending: !query['descending']);
          }
          if (query['limit'] != null) {
            q = q.limit(query['limit']);
          }
        }
        return await q;
      }
    } catch (e) {
      throw Exception('Get data failed: $e');
    }
  }

  @override
  Stream<dynamic> streamData({
    required String path,
    Map<String, dynamic>? query,
  }) {
    try {
      dynamic q = supabase.from(path).stream(primaryKey: ['id']);
      if (query != null) {
        if (query['orderBy'] != null) {
          q = q.order(query['orderBy'], ascending: !query['descending']);
        }
        if (query['limit'] != null) {
          q = q.limit(query['limit']);
        }
      }
      log('Stream setup for path: $path with query: $query');
      return q;
    } catch (e, stackTrace) {
      log('Stream setup error: $e', stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> updateData({
    required String path,
    required Map<String, dynamic> data,
    String? documentId,
  }) async {
    try {
      final id = (documentId ?? '').trim();
      if (id.isEmpty) {
        throw Exception('Update failed: documentId is empty');
      }

      final updatedById =
          await supabase.from(path).update(data).eq('id', id).select('id');
      if (updatedById.isNotEmpty) {
        return;
      }

      await supabase.from(path).update(data).eq('order_id', id);
    } catch (e) {
      throw Exception('Update failed: $e');
    }
  }

  @override
  Future<void> deleteData({
    required String path,
    required String documentId,
  }) async {
    try {
      final id = documentId.trim();
      if (id.isEmpty) {
        throw Exception('Delete failed: documentId is empty');
      }

      final deletedById =
          await supabase.from(path).delete().eq('id', id).select('id');
      if (deletedById.isNotEmpty) {
        return;
      }

      await supabase.from(path).delete().eq('code', id);
    } catch (e) {
      throw Exception('Delete failed: $e');
    }
  }

  @override
  Future<bool> checkIfDataExists({
    required String path,
    required String documentId,
  }) async {
    try {
      final result =
          await supabase.from(path).select('id').eq('id', documentId).limit(1);
      return result.isNotEmpty;
    } catch (e) {
      throw Exception('Check exists failed: $e');
    }
  }
}
