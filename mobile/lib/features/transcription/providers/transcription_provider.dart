// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:transcribit_app/config/config.dart';
import 'package:transcribit_app/features/transcription/datasource/transcriptiondb_datasource_impl.dart';
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
    log("Uploading file: ${state.filePath}", level: 2);
    final filePath = state.filePath!;
    final fileName = filePath.split('/').last;
    FormData formData = FormData.fromMap({
      'path_file': await MultipartFile.fromFile(filePath, filename: fileName),
    });
    try {
      state = state.copyWith(
        isUploading: true,
      );
      final response = await _dio.request(
        '/transcription/',
        options: Options(method: 'POST'),
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

class TranscriptionDetailState {
  final TranscriptionDb transcription;
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;

  TranscriptionDetailState({
    required this.transcription,
    required this.isLoading,
    required this.hasError,
    this.errorMessage,
  });

  factory TranscriptionDetailState.initial() {
    return TranscriptionDetailState(
      transcription: TranscriptionDb.initial(),
      isLoading: true,
      hasError: false,
    );
  }

  TranscriptionDetailState copyWith({
    TranscriptionDb? transcription,
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
  }) {
    return TranscriptionDetailState(
      transcription: transcription ?? this.transcription,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
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
  // log("Transcription loaded: ${response.data}", level: 2);
  return TranscriptionDb.fromJson(response.data);
});

class TranscriptionProvider extends StateNotifier<TranscriptionDetailState> {
  final TranscriptiondbDatasourceImpl datasource;
  TranscriptionProvider({required this.datasource})
      : super(TranscriptionDetailState.initial());

  setup() {}

  Future<void> getTranscription(String id) async {
    state = state.copyWith(isLoading: true);
    final response = await datasource.getTranscription(id);
    state = state.copyWith(transcription: response, isLoading: false);
  }

  Future<void> updateTitleTranscription(String title) async {
    final transcription = state.transcription.copyWith(title: title);
    state = state.copyWith(transcription: transcription);
  }

  Future<void> updateSegmentsTranscription(
      String idSegment, String text) async {
    final segments = state.transcription.segments;

    for (int i = 0; i < segments.length; i++) {
      final segment = segments[i];
      if (segment.id == idSegment) {
        segments[i] = segment.copyWith(segmentOriginal: text);
      }
    }

    final transcription = state.transcription.copyWith(segments: segments);
    state = state.copyWith(transcription: transcription);
  }

  Future<void> updateTranscription() async {
    final transcription = state.transcription;
    await datasource.updateTitleTranscription(
        id: transcription.id, title: transcription.title ?? "");
    for (int i = 0; i < transcription.segments.length; i++) {
      final segment = transcription.segments[i];
      await datasource.updateSegmentTranscription(segment);
    }
  }

  Future<void> deleteTranscription(String id) async {
    state = state.copyWith(isLoading: true);
    final response = await datasource.deleteTranscription(id);
    if (response["status"] == "success") {
      state = state.copyWith(
          transcription: TranscriptionDb.initial(), isLoading: false);
    }
  }
}

final transcriptionDetailNotifierProvider = StateNotifierProvider.autoDispose<
    TranscriptionProvider, TranscriptionDetailState>((ref) {
  final datasource = TranscriptiondbDatasourceImpl();
  return TranscriptionProvider(datasource: datasource);
});
