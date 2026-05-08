import 'package:proyecto/features/recording/domain/repositories/recording_repository.dart';

class StopRecordingUsecase {
  final RecordingRepository _repository;
  StopRecordingUsecase(this._repository);

  Future<String?> execute() => _repository.stopRecording();
}
