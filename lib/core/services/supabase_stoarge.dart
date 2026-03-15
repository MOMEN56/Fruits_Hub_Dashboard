import 'dart:io';

import 'package:fruit_hub_dashboard/core/config/app_secrets.dart';
import 'package:fruit_hub_dashboard/core/services/stoarage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as p;

class SupabaseStoargeService implements StoarageService {
  static bool _isInitialized = false;
  final SupabaseClient supabase = Supabase.instance.client;
  static initSupabase() async {
    if (_isInitialized) {
      return;
    }
    AppSecrets.validateSupabaseConfig();
    try {
      await Supabase.initialize(
        url: AppSecrets.supabaseUrl,
        anonKey: AppSecrets.supabaseAnonKey,
      );
    } catch (_) {}
    _isInitialized = true;
  }

  @override
  Future<String> uploadFile(File file, String path) async {
    String fileName = p.basenameWithoutExtension(file.path);
    String extension = p.extension(file.path);
    String fullPath = '$path/$fileName$extension';

    try {
      await supabase.storage.from('product-images').uploadBinary(
            fullPath,
            file.readAsBytesSync(),
            fileOptions: FileOptions(contentType: 'image/$extension'),
          );
      return supabase.storage.from('product-images').getPublicUrl(fullPath);
    } catch (e) {
      throw Exception('Upload failed: $e');
    }
  }
}
