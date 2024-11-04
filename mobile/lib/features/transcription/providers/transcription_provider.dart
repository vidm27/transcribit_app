// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:transcribit_app/config/config.dart';
import 'package:transcribit_app/features/transcription/models/models.dart';

class TranscriptionState {
  final double progress;
  final bool isCompleted;
  final bool hasError;
  final bool isUploading;
  final String? idTranscription;
  final String? filePath;
  final String? errorMessage;

  TranscriptionState(
      {required this.progress,
      required this.isCompleted,
      required this.isUploading,
      required this.hasError,
      this.idTranscription,
      this.filePath,
      this.errorMessage});

  TranscriptionState.initial()
      : progress = 0.0,
        isCompleted = false,
        hasError = false,
        isUploading = false,
        idTranscription = null,
        filePath = null,
        errorMessage = null;

  TranscriptionState copyWith({
    double? progress,
    bool? isCompleted,
    bool? hasError,
    bool? isUploading,
    String? idTranscription,
    String? filePath,
    String? errorMessage,
  }) {
    return TranscriptionState(
      progress: progress ?? this.progress,
      isCompleted: isCompleted ?? this.isCompleted,
      hasError: hasError ?? this.hasError,
      isUploading: isUploading ?? this.isUploading,
      filePath: filePath ?? this.filePath,
      idTranscription: idTranscription ?? idTranscription,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class FileUploadNotifier extends StateNotifier<TranscriptionState> {
  final _dio = Dio(apiConfig);
  FileUploadNotifier() : super(TranscriptionState.initial());

  void setFilePath(String filePath) {
    state = state.copyWith(
      filePath: filePath,
    );
  }

  Future<void> uploadFile() async {
    FormData formData = FormData.fromMap({
      'path_file': await MultipartFile.fromFile(state.filePath!),
    });
    try {
      state = state.copyWith(
        isUploading: true,
      );
      final response = await _dio.post(
        '/transcription/',
        data: formData,
        onSendProgress: (count, total) {
          double newProgress = count / total;
          state = state.copyWith(
            progress: newProgress,
          );
        },
      );

      if (response.statusCode == 201) {
        final data = response.data;
        state = state.copyWith(
          isCompleted: true,
          idTranscription: data['id'],
        );
      }
    } catch (e) {
      log("Error uploading file: $e", level: 2);
      state = state.copyWith(
        hasError: true,
        errorMessage: e.toString(),
      );
    }

    state = state.copyWith(
      isUploading: false,
    );
  }
}

final transcriptionProvider =
    StateNotifierProvider<FileUploadNotifier, TranscriptionState>(
        (ref) => FileUploadNotifier());

final transcriptionDetailProvider =
    FutureProvider.autoDispose.family<TranscriptionDb, String>((ref, id) async {
  final dio = Dio(apiConfig);
  final response = await dio.get('/transcription/$id');

  if (response.statusCode != 200) {
    log("Error getting transcription: ${response.statusCode}", level: 2);
    throw Exception('Failed to load transcription');
  }
  log("Transcription loaded: ${response.data}", level: 2);
  return TranscriptionDb.fromJson(response.data);
});
