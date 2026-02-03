import 'dart:io';

import 'package:fruit_hub_dashboard/core/services/stoarage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as b;

class SupabaseStoargeService implements StoarageService {
  static late Supabase _supabase;

  static initSupabase() async {
    _supabase = await Supabase.initialize(
      url: 'https://iwhxwcqfcpcblvdifidv.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Iml3aHh3Y3FmY3BjYmx2ZGlmaWR2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njk2MjA0NzgsImV4cCI6MjA4NTE5NjQ3OH0.BZp9PXcXXOJbb5Npy3wra7JO6Ed0M-JrRqYXSQ8F83c',
    );
  }

  @override
  Future<String> uploadFile(File file, String path) async {
    String fileName = b.basenameWithoutExtension(file.path);
    String extensionName = b.extension(file.path);

    try {
      final result =
          await _supabase.client.storage.from('product-images').upload(
                '$path/$fileName$extensionName',
                file,
              );
      print('✅ Upload succeeded: $result');
      return result;
    } on StorageException catch (e) {
      print('❌ StorageException: ${e.message}, StatusCode: ${e.statusCode}');
      rethrow;
    } catch (e) {
      print('❌ Unknown error: $e');
      rethrow;
    }
  }
}
