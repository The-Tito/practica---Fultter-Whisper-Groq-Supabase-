import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyecto/core/di/injection.dart';
import 'package:proyecto/features/transcriptions/domain/repositories/processing_repository.dart';

sealed class DetailState {}

class DetailLoading extends DetailState {}

class DetailLoaded extends DetailState {
  final String id;
  final String title;
  final String transcript;
  final String aiContent;
  final String audioUrl;
  final int durationSeconds;
  final DateTime createdAt;

  DetailLoaded({
    required this.id,
    required this.title,
    required this.transcript,
    required this.aiContent,
    required this.audioUrl,
    required this.durationSeconds,
    required this.createdAt,
  });
}

class DetailError extends DetailState {
  final String message;
  DetailError(this.message);
}

class DetailNotifier extends Notifier<DetailState> {
  ProcessingRepository get _repository => getIt<ProcessingRepository>();

  @override
  DetailState build() => DetailLoading();

  Future<void> load(String id) async {
    state = DetailLoading();

    try {
      final data = await _repository.getTranscriptionById(id);

      final audioUrl = await _repository.getSignedUrl(
        data['audio_url'] as String,
      );
      state = DetailLoaded(
        id: data['id'] as String,
        title: data['title'] as String,
        transcript: data['transcript'] as String,
        aiContent: data['ai_content'] as String,
        audioUrl: audioUrl,
        durationSeconds: data['duration_seconds'] as int,
        createdAt: DateTime.parse(data['created_at'] as String),
      );
    } catch (e) {
      state = DetailError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  void reset() => state = DetailLoading();
}

final detailProvider = NotifierProvider<DetailNotifier, DetailState>(
  DetailNotifier.new,
);
