import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transcribit_app/config/api/api_config.dart';
import 'package:transcribit_app/features/transcription/models/transcription_response_model.dart';

final historyProvider =
    FutureProvider.autoDispose<TranscriptionResponse>((ref) async {
  final dio = Dio(apiConfig);
  final response = await dio.get('/transcription/');

  if (response.statusCode != 200) {
    log("Error getting history: ${response.statusCode}", level: 2);
    throw Exception('Failed to load history');
  }
  // log("History loaded: ${response.data}", level: 2);
  return TranscriptionResponse.fromJson(response.data);
});

class HistoryNotifier extends StateNotifier<List<Transcription>> {
  HistoryNotifier() : super([]);

  int currentPage = 0;
  bool isLoading = false;
  bool hasNextPage = false;

  Future<void> refresh() async {
    currentPage = 0;
    loadNextPage();
  }

  Future<void> loadNextPage() async {
    if (isLoading) return;
    isLoading = true;

    if (hasNextPage == false && currentPage != 0) {
      isLoading = false;
      return;
    }
    currentPage++;
    log("Current page: $currentPage", level: 2);
    final dio = Dio(apiConfig);
    final response = await dio.get('/transcription/?page=$currentPage');
    final transcription = TranscriptionResponse.fromJson(response.data);
    if (response.statusCode != 200) {
      log("Error getting history: ${response.statusCode}", level: 2);
      throw Exception('Failed to load history');
    }
    if (transcription.next != null) {
      hasNextPage = true;
    } else {
      hasNextPage = false;
    }
    // log("History loaded: ${response.data}", level: 2);
    state = [...state, ...transcription.results];
    isLoading = false;
  }
}

final historyNotifierProvider =
    StateNotifierProvider<HistoryNotifier, List<Transcription>>(
        (ref) => HistoryNotifier());
