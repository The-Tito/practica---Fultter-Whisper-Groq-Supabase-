import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class StorageDatasource {
  Future<String> uploadAudio(String filePath);
  Future<String> getSignedUrl(String storagePath);
}

class SupabaseStorageDatasource implements StorageDatasource {
  final SupabaseClient _client;

  SupabaseStorageDatasource(this._client);

  @override
  Future<String> uploadAudio(String filePath) async {
    final userId = _client.auth.currentUser!.id;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final storagePath = '$userId/$timestamp.m4a';

    await _client.storage
        .from('audio-recordings')
        .upload(
          storagePath,
          File(filePath),
          fileOptions: const FileOptions(contentType: 'audio/m4a'),
        );

    return storagePath;
  }

  @override
  Future<String> getSignedUrl(String storagePath) async {
    return await _client.storage
        .from('audio-recordings')
        .createSignedUrl(storagePath, 3600);
  }
}
