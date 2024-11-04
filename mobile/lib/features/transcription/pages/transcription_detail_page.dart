import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transcribit_app/features/transcription/providers/providers.dart';

class TranscriptionDetailPage extends ConsumerWidget {
  static const name = 'transcription_detail_page';
  final String idTranscription;
  const TranscriptionDetailPage({super.key, required this.idTranscription});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transcription =
        ref.watch(transcriptionDetailProvider(idTranscription));
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Transcripción'),
        ),
        body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: transcription.when(
                data: (data) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Duración: ${data.duration}",
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Expanded(
                          child: ListView.builder(
                              itemCount: data.segments.length,
                              itemBuilder: (context, index) {
                                final segment = data.segments[index];
                                final minutosInicio =
                                    segment.minutesStart.floor();
                                final minutosFin = segment.minutesEnd.floor();
                                final segundoInicio =
                                    ((segment.minutesStart - minutosInicio) *
                                            60)
                                        .round();
                                final segundoFin =
                                    ((segment.minutesEnd - minutosFin) * 60)
                                        .round();
                                final tiempoInicioFormat =
                                    "${minutosInicio.toString().padLeft(2, '0')}:${segundoInicio.toString().padLeft(2, '0')}";
                                final tiempoFinFormat =
                                    "${minutosFin.toString().padLeft(2, '0')}:${segundoFin.toString().padLeft(2, '0')}";
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "$tiempoInicioFormat - $tiempoFinFormat",
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Text(segment.segmentOriginal,
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black,
                                        )),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                  ],
                                );
                              }))
                    ],
                  );
                },
                error: (error, stackTrace) =>
                    Text('Error, $error, $stackTrace'),
                loading: () => const Center(child: CircularProgressIndicator()),
              )),
        ));
  }
}
