import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'storage_service.dart';

class SubaStorage implements StorageService {
  final SupabaseClient _client = Supabase.instance.client;

  @override
  Future<String> uploadFile(File file, String path) async {
    final fileName = p.basename(file.path);
    final fullPath = '$path/$fileName';

    await _client.storage
        .from('product-images') // اسم الـ bucket
        .upload(
          fullPath,
          file,
          fileOptions: const FileOptions(upsert: true, cacheControl: '3600'),
        );

    final imageUrl = _client.storage
        .from('product-images')
        .getPublicUrl(fullPath);

    return imageUrl;
  }
}
