abstract class ProcessingRepository {
  Future<String> transcribe(String filePath);
  Future<String> generateTitle(String transcript);
  Future<String> developIdea(String transcript);
  Future<String> uploadAudio(String filePath);
  Future<String> saveRecord({
    required String transcript,
    required String title,
    required String aiContent,
    required String audioPath,
    required int durationSeconds,
  });
  Future<Map<String, dynamic>> getTranscriptionById(String id);
  Future<String> getSignedUrl(String storagePath);
  Future<List<Map<String, dynamic>>> getAllTranscriptions();
}
