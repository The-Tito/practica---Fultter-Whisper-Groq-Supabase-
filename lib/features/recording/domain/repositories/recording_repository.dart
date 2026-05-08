abstract class RecordingRepository {
  Future<bool> hasPermission();
  Future<void> startRecording(String filePath);
  Future<String?> stopRecording();
  Stream<double> get amplitudeStream;
  Future<String> buildFilePath();
  Future<void> pauseRecording();
  Future<void> resumeRecording();
}
