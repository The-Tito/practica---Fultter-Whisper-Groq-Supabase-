import 'package:supabase_flutter/supabase_flutter.dart';

abstract class TranscriptionDatasource {
  Future<String> save({
    required String transcript,
    required String title,
    required String aiContent,
    required String audioPath,
    required int durationSeconds,
  });
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
}
