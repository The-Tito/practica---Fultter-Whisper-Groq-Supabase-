import 'package:supabase_flutter/supabase_flutter.dart';

abstract class TranscriptionDatasource {
  Future<String> save({
    required String transcript,
    required String title,
    required String aiContent,
    required String audioPath,
    required int durationSeconds,
  });
  Future<Map<String, dynamic>> getById(String id);
  Future<List<Map<String, dynamic>>> getAll();
}

class SupabaseTranscriptionDatasource implements TranscriptionDatasource {
  final SupabaseClient _client;

  SupabaseTranscriptionDatasource(this._client);

  @override
  Future<String> save({
    required String transcript,
    required String title,
    required String aiContent,
    required String audioPath,
    required int durationSeconds,
  }) async {
    final userId = _client.auth.currentUser!.id;

    final response = await _client
        .from('transcriptions')
        .insert({
          'user_id': userId,
          'audio_url': audioPath,
          'transcript': transcript,
          'title': title,
          'ai_content': aiContent,
          'duration_seconds': durationSeconds,
        })
        .select('id')
        .single();

    return response['id'] as String;
  }

  @override
  Future<Map<String, dynamic>> getById(String id) async {
    final response = await _client
        .from('transcriptions')
        .select()
        .eq('id', id)
        .single();

    return response;
  }

  @override
  Future<List<Map<String, dynamic>>> getAll() async {
    final userId = _client.auth.currentUser!.id;

    final response = await _client
        .from('transcriptions')
        .select('id, title, transcript, duration_seconds, created_at')
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }
}
