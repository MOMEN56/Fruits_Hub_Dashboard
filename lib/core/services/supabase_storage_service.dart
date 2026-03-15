import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:fruit_hub_dashboard/core/config/app_secrets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'storage_service.dart';

class SupabaseStorageService implements StorageService {
  static bool _isInitialized = false;

  final SupabaseClient supabase = Supabase.instance.client;

  static Future<void> initialize() async {
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
  Future<String> uploadFile(File file, String storagePath) async {
    final fileName = path.basenameWithoutExtension(file.path);
    final extension = path.extension(file.path);
    final fullPath = '$storagePath/$fileName$extension';
    final contentType = 'image/${extension.replaceFirst('.', '')}';

    try {
      await supabase.storage.from('product-images').uploadBinary(
            fullPath,
            file.readAsBytesSync(),
            fileOptions: FileOptions(contentType: contentType),
          );
      return supabase.storage.from('product-images').getPublicUrl(fullPath);
    } catch (e) {
      throw Exception('Upload failed: $e');
    }
  }
}
