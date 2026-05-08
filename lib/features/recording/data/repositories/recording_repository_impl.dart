import 'package:proyecto/features/recording/data/datasources/recording_datasource.dart';
import 'package:proyecto/features/recording/domain/repositories/recording_repository.dart';

class RecordingRepositoryImpl implements RecordingRepository {
  final RecordingDatasource _datasource;
  RecordingRepositoryImpl(this._datasource);

  @override
  Stream<double> get amplitudeStream => _datasource.amplitudeStream;

  @override
  Future<bool> hasPermission() => _datasource.hasPermission();

  @override
  Future<void> startRecording(String filepath) =>
      _datasource.startRecording(filepath);

  @override
  Future<String?> stopRecording() => _datasource.stopRecording();

  @override
  Future<String> buildFilePath() => _datasource.builFilePath();

  @override
  Future<void> pauseRecording() => _datasource.stopRecording();

  @override
  Future<void> resumeRecording() => _datasource.resumeRecording();
}
