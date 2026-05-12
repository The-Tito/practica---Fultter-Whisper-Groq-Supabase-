import 'package:proyecto/features/transcriptions/domain/repositories/processing_repository.dart';

class ProcessRecordingUsecase {
  final ProcessingRepository _repository;

  ProcessRecordingUsecase(this._repository);

  Future<String> execute({
    required String filePath,
    required int durationSeconds,
    required void Function(String message) onStep,
  }) async {
    onStep('Transcribiendo audio...');
    final transcript = await _repository.transcribe(filePath);

    onStep('Generando título...');
    final title = await _repository.generateTitle(transcript);
    onStep('Desarrollando tu idea...'); // ← nuevo paso

    final aiContent = await _repository.developIdea(transcript);

    onStep('Subiendo audio...');
    final audioPath = await _repository.uploadAudio(filePath);

    onStep('Guardando nota...');
    final id = await _repository.saveRecord(
      transcript: transcript,
      title: title,
      aiContent: aiContent,
      audioPath: audioPath,
      durationSeconds: durationSeconds,
    );

    return id;
  }
}
