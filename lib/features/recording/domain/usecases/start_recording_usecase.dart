import 'package:proyecto/features/recording/domain/repositories/recording_repository.dart';

class StartRecordingUsecase {
  final RecordingRepository _recordingRepository;
  StartRecordingUsecase(this._recordingRepository);

  Future<void> execute(String filePath) =>
      _recordingRepository.startRecording(filePath);
}
