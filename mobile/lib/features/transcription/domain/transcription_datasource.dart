import 'package:transcribit_app/features/transcription/models/models.dart';

abstract class TranscriptionDatasource {
  Future<TranscriptionDb> getTranscription(String id);
  Future<Map<String, dynamic>> updateSegmentTranscription(Segment segment);
  Future<Map<String, dynamic>> updateTitleTranscription(
      {required String id, required String title});
  Future<Map<String, dynamic>> deleteTranscription(String id);
}
