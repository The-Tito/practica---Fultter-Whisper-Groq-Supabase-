import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyecto/core/di/injection.dart';
import 'package:proyecto/features/transcriptions/domain/repositories/processing_repository.dart';
import 'package:proyecto/features/transcriptions/domain/usecases/process_recording_usecase.dart';

sealed class ProcessingState {}

class ProcessingIdle extends ProcessingState {}

class ProcessingStep extends ProcessingState {
  final String message;
  ProcessingStep(this.message);
}

class ProcessingDone extends ProcessingState {
  final String transcriptionId;
  ProcessingDone(this.transcriptionId);
}

class ProcessingError extends ProcessingState {
  final String message;
  ProcessingError(this.message);
}

class ProcessingNotifier extends Notifier<ProcessingState> {
  ProcessingRepository get _repository => getIt<ProcessingRepository>();

  @override
  ProcessingState build() => ProcessingIdle();

  Future<void> process({
    required String filePath,
    required int durationSeconds,
  }) async {
    state = ProcessingStep('Iniciando...');
    try {
      final usecase = ProcessRecordingUsecase(_repository);
      final id = await usecase.execute(
        filePath: filePath,
        durationSeconds: durationSeconds,
        onStep: (message) => state = ProcessingStep(message),
      );
      state = ProcessingDone(id);
    } catch (e) {
      state = ProcessingError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  void reset() => state = ProcessingIdle();
}

final processingProvider =
    NotifierProvider<ProcessingNotifier, ProcessingState>(
      ProcessingNotifier.new,
    );
