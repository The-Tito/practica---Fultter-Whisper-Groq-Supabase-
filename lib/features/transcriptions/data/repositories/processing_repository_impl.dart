import 'package:proyecto/features/transcriptions/data/datasources/groq_datasource.dart';
import 'package:proyecto/features/transcriptions/data/datasources/storage_datasource.dart';
import 'package:proyecto/features/transcriptions/data/datasources/transcription_datasource.dart';
import 'package:proyecto/features/transcriptions/domain/repositories/processing_repository.dart';

class ProcessingRepositoryImpl implements ProcessingRepository {
  final GroqDatasource _groq;
  final StorageDatasource _storage;
  final TranscriptionDatasource _transcription;

  ProcessingRepositoryImpl({
    required GroqDatasource groq,
    required StorageDatasource storage,
    required TranscriptionDatasource transcription,
  }) : _groq = groq,
       _storage = storage,
       _transcription = transcription;

  @override
  Future<String> transcribe(String filePath) async {
    try {
      return await _groq.transcribe(filePath);
    } catch (e) {
      throw Exception(
        'Error al transcribir: ${e.toString().replaceAll('Exception: ', '')}',
      );
    }
  }

  @override
  Future<String> generateTitle(String transcript) async {
    try {
      return await _groq.generateTitle(transcript);
    } catch (e) {
      throw Exception(
        'Error al generar título: ${e.toString().replaceAll('Exception: ', '')}',
      );
    }
  }

  @override
  Future<String> developIdea(String transcript) async {
    try {
      return await _groq.developIdea(transcript);
    } catch (e) {
      throw Exception(
        'Error al desarrollar idea: ${e.toString().replaceAll('Exception: ', '')}',
      );
    }
  }

  @override
  Future<String> uploadAudio(String filePath) async {
    try {
      return await _storage.uploadAudio(filePath);
    } catch (e) {
      throw Exception(
        'Error al subir audio: ${e.toString().replaceAll('Exception: ', '')}',
      );
    }
  }

  @override
  Future<String> saveRecord({
    required String transcript,
    required String title,
    required String aiContent,
    required String audioPath,
    required int durationSeconds,
  }) async {
    try {
      return await _transcription.save(
        transcript: transcript,
        title: title,
        aiContent: aiContent,
        audioPath: audioPath,
        durationSeconds: durationSeconds,
      );
    } catch (e) {
      throw Exception(
        'Error al guardar: ${e.toString().replaceAll('Exception: ', '')}',
      );
    }
  }
}
