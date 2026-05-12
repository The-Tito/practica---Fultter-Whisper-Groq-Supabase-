import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class RecordingDatasource {
  final AudioRecorder _recorder = AudioRecorder();
  final _amplitudeController = StreamController<double>.broadcast();
  Timer? _amplitudeTimer;

  Stream<double> get amplitudeStream => _amplitudeController.stream;

  Future<bool> hasPermission() => _recorder.hasPermission();

  Future<String> builFilePath() async {
    final dir = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '${dir.path}/recording_$timestamp.m4a';
  }

  Future<void> startRecording(String filePath) async {
    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 64000,
        sampleRate: 44100,
        numChannels: 1,
      ),
      path: filePath,
    );
    _startAmplitudePolling();
  }

  void _startAmplitudePolling() {
    _amplitudeTimer?.cancel();
    _amplitudeTimer = Timer.periodic(const Duration(milliseconds: 100), (
      _,
    ) async {
      try {
        final amp = await _recorder.getAmplitude();
        final normalized = ((amp.current + 60) / 50).clamp(0.0, 1.0);
        _amplitudeController.add(normalized);
      } catch (e) {
        print('❌ Error de amplitud: $e');
      }
    });
  }

  Future<String?> stopRecording() async {
    _amplitudeTimer?.cancel();
    return _recorder.stop();
  }

  Future<void> pauseRecording() async {
    _amplitudeTimer?.cancel();
    await _recorder.pause();
  }

  Future<void> resumeRecording() async {
    await _recorder.resume();
    _startAmplitudePolling();
  }

  Future<void> dispose() async {
    _amplitudeTimer?.cancel();
    await _amplitudeController.close();
    await _recorder.dispose();
  }
}
