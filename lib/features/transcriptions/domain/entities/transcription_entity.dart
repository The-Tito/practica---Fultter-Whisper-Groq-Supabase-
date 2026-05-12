class TranscriptionEntity {
  final String id;
  final String userId;
  final String audioUrl;
  final String transcript;
  final String title;
  final String aiContent;
  final int durationSeconds;
  final DateTime createdAt;

  const TranscriptionEntity({
    required this.id,
    required this.userId,
    required this.audioUrl,
    required this.transcript,
    required this.title,
    required this.durationSeconds,
    required this.createdAt,
    required this.aiContent,
  });
}
