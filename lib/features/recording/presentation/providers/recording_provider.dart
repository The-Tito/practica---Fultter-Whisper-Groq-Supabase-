import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyecto/core/di/injection.dart';
import 'package:proyecto/features/recording/domain/repositories/recording_repository.dart';
import 'package:proyecto/features/recording/domain/usecases/start_recording_usecase.dart';
import 'package:proyecto/features/recording/domain/usecases/stop_recording_usecase.dart';

sealed class RecordingState {}

class RecordingIdle extends RecordingState {}

class RecordingInProgress extends RecordingState {
  final Duration elapsed;
  final double amplitude;
  RecordingInProgress({required this.elapsed, required this.amplitude});
}

class RecordingPaused extends RecordingState {
  final Duration elapsed;
  RecordingPaused({required this.elapsed});
}

class RecordingDone extends RecordingState {
  final String filePath;
  final Duration duration;
  RecordingDone({required this.filePath, required this.duration});
}

class RecordingError extends RecordingState {
  final String message;
  RecordingError(this.message);
}

class RecordingNotifier extends Notifier<RecordingState> {
  RecordingRepository get _repository => getIt<RecordingRepository>();

  late final StartRecordingUsecase _startUsecase;
  late final StopRecordingUsecase _stopUsecase;
  Timer? _timer;
  double _currentAmplitude = 0.05;

  StreamSubscription<double>? _ampSubscription;
  int _elapsedMs = 0;
  String? _currentFilePath;

  @override
  RecordingState build() {
    _startUsecase = StartRecordingUsecase(_repository);
    _stopUsecase = StopRecordingUsecase(_repository);
    return RecordingIdle();
  }

  Future<void> startRecording() async {
    final hasPermission = await _repository.hasPermission();
    if (!hasPermission) {
      state = RecordingError('Permiso de micrófono denegado');
      return;
    }

    try {
      _elapsedMs = 0;
      final filePath = await _repository.buildFilePath();
      _currentFilePath = filePath;

      await _startUsecase.execute(filePath);
      _startTimer();
      _ampSubscription = _repository.amplitudeStream.listen((amp) {
        _currentAmplitude = amp;
      });
    } catch (e) {
      state = RecordingError(e.toString());
    }
  }

  Future<void> stopRecording() async {
    _timer?.cancel();
    await _ampSubscription?.cancel();
    final path = await _stopUsecase.execute();

    if (path != null) {
      state = RecordingDone(
        filePath: path,
        duration: Duration(milliseconds: _elapsedMs),
      );
    } else {
      state = RecordingError('No se pudo guardar la grabación');
    }
  }

  void reset() {
    _timer?.cancel();
    _ampSubscription?.cancel();
    _elapsedMs = 0;
    state = RecordingIdle();
  }

  Future<void> pauseRecording() async {
    _timer?.cancel();
    await _ampSubscription?.cancel();
    await _repository.pauseRecording();
    state = RecordingPaused(elapsed: Duration(milliseconds: _elapsedMs));
  }

  Future<void> resumeRecording() async {
    await _repository.resumeRecording();
    _startTimer();
    _ampSubscription = _repository.amplitudeStream.listen((amp) {
      _currentAmplitude = amp;
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      _elapsedMs += 100;
      state = RecordingInProgress(
        elapsed: Duration(milliseconds: _elapsedMs),
        amplitude: _currentAmplitude,
      );
    });
  }
}

final recordingProvider = NotifierProvider<RecordingNotifier, RecordingState>(
  RecordingNotifier.new,
);
