import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:transcribit_app/config/config.dart';
import 'package:transcribit_app/features/transcription/domain/transcription_datasource.dart';
import 'package:transcribit_app/features/transcription/models/transcription_model.dart';

class TranscriptiondbDatasourceImpl extends TranscriptionDatasource {
  final dio = Dio(apiConfig);
  @override
  Future<Map<String, dynamic>> deleteTranscription(String id) async {
    final response = await dio.delete('/transcription/$id/');
    if (response.statusCode != 204) {
      log("Error deleting transcription: ${response.statusCode}", level: 2);
      throw Exception('Failed to delete transcription');
    }
    return {"message": "Transcription deleted", "id": id, "status": "success"};
  }

  @override
  Future<TranscriptionDb> getTranscription(String id) async {
    final response = await dio.get('/transcription/$id');
    if (response.statusCode != 200) {
      log("Error getting transcription: ${response.statusCode}", level: 2);
      throw Exception('Failed to load transcription');
    }
    return TranscriptionDb.fromJson(response.data);
  }

  @override
  Future<Map<String, dynamic>> updateSegmentTranscription(
      Segment segment) async {
    final response =
        await dio.put('/segment/${segment.id}/', data: segment.toJson());
    if (response.statusCode != 200) {
      log("Error updating segment transcription: ${response.statusCode}",
          level: 2);
      throw Exception('Failed to update segment transcription');
    }
    return {
      "message": "Segment updated",
      "id": segment.id,
      "status": "success"
    };
  }

  @override
  Future<Map<String, dynamic>> updateTitleTranscription(
      {required String id, required String title}) async {
    final response =
        await dio.put('/transcription/$id/', data: {"title": title});
    if (response.statusCode != 200) {
      log("Error updating title transcription: ${response.statusCode}",
          level: 2);
      throw Exception('Failed to update title transcription');
    }
    return {"message": "Title updated", "id": id, "status": "success"};
  }
}
