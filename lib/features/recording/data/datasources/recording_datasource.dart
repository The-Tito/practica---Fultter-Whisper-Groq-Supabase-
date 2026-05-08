import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class RecordingDatasource {
  final AudioRecorder _recorder = AudioRecorder();
  final _amplitudeController = StreamController<double>.broadcast();
  StreamSubscription? _ampSubscription;

  Stream<double> get amplitudeStream => _amplitudeController.stream;

  Future<bool> hasPermission() => _recorder.hasPermission();

  Future<String> builFilePath() async {
    final dir = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '${dir.path}/recording_$timestamp.m4a';
  }

  Future<void> startRecording(String filepath) async {
    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 64000,
        sampleRate: 16000,
        numChannels: 1,
      ),
      path: filepath,
    );

    _ampSubscription = _recorder
        .onAmplitudeChanged(const Duration(milliseconds: 100))
        .listen((amp) {
          final normalized = ((amp.current + 60) / 50).clamp(0.0, 1.0);
          _amplitudeController.add(normalized);
        });
  }

  Future<String?> stopRecording() async {
    await _ampSubscription?.cancel();
    return _recorder.stop();
  }

  Future<void> dispose() async {
    await _ampSubscription?.cancel();
    await _amplitudeController.close();
    await _recorder.dispose();
  }

  Future<void> pauseRecording() => _recorder.pause();

  Future<void> resumeRecording() async {
    await _recorder.resume();
    await _ampSubscription?.cancel();
    _ampSubscription = _recorder
        .onAmplitudeChanged(const Duration(milliseconds: 100))
        .listen((amp) {
          final normalized = ((amp.current + 60) / 50).clamp(0.0, 1.0);
          _amplitudeController.add(normalized);
        });
  }
}
