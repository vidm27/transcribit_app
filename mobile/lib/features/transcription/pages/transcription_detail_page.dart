import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:transcribit_app/features/history/providers/history_provider.dart';
import 'package:transcribit_app/features/transcription/models/transcription_model.dart';
import 'package:transcribit_app/features/transcription/providers/player_provider.dart';
import 'package:transcribit_app/features/transcription/providers/providers.dart';

class TranscriptionDetailPage extends ConsumerStatefulWidget {
  static const name = 'transcription_detail_page';
  final String idTranscription;
  const TranscriptionDetailPage({super.key, required this.idTranscription});

  @override
  ConsumerState<TranscriptionDetailPage> createState() =>
      _TranscriptionDetailPageState();
}

class _TranscriptionDetailPageState
    extends ConsumerState<TranscriptionDetailPage>
    with TickerProviderStateMixin {
  TabController? tabController;
  bool isEditing = false;

  // final _selectedColor = const Color(0xff1a73e8);
  // final _unselectedColor = const Color(0xff5f6368);
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);

    Future.microtask(() {
      ref.read(transcriptionDetailNotifierProvider.notifier).getTranscription(
            widget.idTranscription,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final transcriptionState = ref.watch(transcriptionDetailNotifierProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              context.go('/');
            },
            icon: const Icon(Icons.home),
          ),
        ],
        title: isEditing
            ? TextFormField(
                initialValue: transcriptionState.transcription.title,
                onChanged: ref
                    .read(transcriptionDetailNotifierProvider.notifier)
                    .updateTitleTranscription,
                style: const TextStyle(color: Colors.black),
                textAlign: TextAlign.left,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              )
            : Text(
                transcriptionState.transcription.title!.isEmpty
                    ? "No tiene título"
                    : transcriptionState.transcription.title!,
              ),
      ),
      body: transcriptionState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.all(5.0),
                    height: MediaQuery.of(context).size.height * 0.05,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey[300],
                    ),
                    child: TabBar(
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        controller: tabController,
                        indicator: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Colors.white),
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.black,
                        tabs: const [
                          Tab(text: 'Transcripción'),
                          Tab(text: 'Audio'),
                        ]),
                  ),
                ),
                Expanded(
                  child: TabBarView(controller: tabController, children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _TranscriptionTextWidget(
                        transcription: transcriptionState.transcription,
                        isEditing: isEditing,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _TranscriptionAudioWidget(
                          idTranscription: transcriptionState.transcription.id,
                          duration: transcriptionState.transcription.duration!),
                    )
                  ]),
                ),
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C45B3),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withAlpha((0.5 * 255).toInt()),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          icon: const Icon(
                            Icons.ios_share_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () {}),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          showModalDelete();
                        },
                      ),
                      isEditing
                          ? IconButton(
                              icon: const Icon(Icons.save_rounded,
                                  color: Colors.white, size: 30),
                              onPressed: () {
                                setState(() {
                                  isEditing = !isEditing;
                                });
                                ref
                                    .read(transcriptionDetailNotifierProvider
                                        .notifier)
                                    .updateTranscription();
                              },
                            )
                          : IconButton(
                              icon: const Icon(
                                Icons.edit_rounded,
                                color: Colors.white,
                                size: 30,
                              ),
                              onPressed: () {
                                setState(() {
                                  isEditing = !isEditing;
                                });
                              },
                            ),
                    ],
                  ),
                )
              ],
            ),
    );
  }

  void showModalDelete() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha((0.5 * 255).toInt()),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "¿Desea eliminar la transcripción?",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("No")),
                    TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFF2C45B3),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          ref
                              .read(
                                  transcriptionDetailNotifierProvider.notifier)
                              .deleteTranscription(widget.idTranscription);
                          context.pop();
                          ref.read(historyNotifierProvider.notifier).refresh();
                        },
                        child: const Text("Si")),
                    const SizedBox(
                      width: 15,
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }
}

class _TranscriptionTextWidget extends ConsumerWidget {
  final TranscriptionDb transcription;
  final bool isEditing;
  const _TranscriptionTextWidget(
      {super.key, required this.transcription, this.isEditing = false});

  Map<String, dynamic> tiempoToTextFormat(Segment segment) {
    final minutosInicio = segment.minutesStart.floor();
    final minutosFin = segment.minutesEnd.floor();
    final segundoInicio = ((segment.minutesStart - minutosInicio) * 60).round();
    final segundoFin = ((segment.minutesEnd - minutosFin) * 60).round();
    final tiempoInicioFormat =
        "${minutosInicio.toString().padLeft(2, '0')}:${segundoInicio.toString().padLeft(2, '0')}";
    final tiempoFinFormat =
        "${minutosFin.toString().padLeft(2, '0')}:${segundoFin.toString().padLeft(2, '0')}";
    return {
      "start": tiempoInicioFormat,
      "end": tiempoFinFormat,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 15,
        ),
        Text(
          "Duración: ${transcription.duration}",
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Expanded(
          child: ListView.builder(
              itemCount: transcription.segments.length,
              itemBuilder: (context, index) {
                final segment = transcription.segments[index];
                final tiempoFormateado = tiempoToTextFormat(segment);
                return Card(
                  color: Colors.grey[100],
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        durationWidget(tiempoFormateado),
                        const SizedBox(
                          height: 3,
                        ),
                        isEditing
                            ? TextFormField(
                                maxLines: (segment.segmentOriginal.length / 50)
                                    .ceil(),
                                initialValue: segment.segmentOriginal,
                                onChanged: (value) {
                                  ref
                                      .read(transcriptionDetailNotifierProvider
                                          .notifier)
                                      .updateSegmentsTranscription(
                                          segment.id, value);
                                },
                                decoration: const InputDecoration(
                                    border: InputBorder.none),
                              )
                            : Text(
                                segment.segmentOriginal,
                                style: const TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                        const SizedBox(
                          height: 2,
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }

  Text durationWidget(Map<String, dynamic> tiempoFormateado) {
    return Text(
      "${tiempoFormateado["start"]} - ${tiempoFormateado["end"]}",
      style: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.bold,
        color: Colors.grey[700],
      ),
    );
  }
}

class _TranscriptionAudioWidget extends ConsumerWidget {
  final String idTranscription;
  final String duration;

  const _TranscriptionAudioWidget(
      {required this.idTranscription, required this.duration});

  Duration tiempoToDuration(String tiempo) {
    var partes = tiempo.split(':');
    int minutos = int.parse(partes[0]);
    int segundos = int.parse(partes[1]);
    int milisegundos = partes.length > 2 ? int.parse(partes[2]) : 0;
    return Duration(
        minutes: minutos, seconds: segundos, milliseconds: milisegundos);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioPlayerState = ref.watch(audioPlayerProvider);
    final audioController = ref.read(audioPlayerProvider.notifier);

    ref.listen(audioPlayerProvider, (previous, next) {
      if (previous?.duration == Duration.zero && next.duration != Duration.zero) {
        audioController.setDuration(tiempoToDuration(duration));
      }
    });

    final maxDuration = audioPlayerState.duration.inSeconds.toDouble() > 0
        ? audioPlayerState.duration.inSeconds.toDouble()
        : 1.0;

    final sliderValue = audioPlayerState.position.inSeconds.toDouble().clamp(0.0, maxDuration);

    return Column(
      children: [
        TweenAnimationBuilder(
            tween: Tween<double>(
                begin: 0.0,
                end: audioPlayerState.duration.inSeconds.toDouble()),
            duration: const Duration(milliseconds: 300),
            builder: (context, value, child) {
              return Slider(
                min: 0,
                max: maxDuration,
                value: sliderValue,
                onChanged: (double newValue) async {
                  audioController.seek(Duration(seconds: newValue.toInt()));
                  audioController.play();
                },
              );
            }),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${audioPlayerState.position.inMinutes.toString().padLeft(2, '0')}:${(audioPlayerState.position.inSeconds % 60).toString().padLeft(2, '0')}",
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
            const Spacer(),
            Text(
              "${audioPlayerState.duration.inMinutes.toString().padLeft(2, '0')}:${(audioPlayerState.duration.inSeconds % 60).toString().padLeft(2, '0')}",
              style: const TextStyle(),
            ),
          ],
        ),
        CircleAvatar(
          radius: 30,
          child: IconButton(
            onPressed: () {
              if (audioPlayerState.isPlaying) {
                audioController.pause();
              } else {
                final currentDuration = tiempoToDuration(duration);
                final url =
                    'http://127.0.0.1:8000/api/v1/audio/$idTranscription';
                audioController.init(url);
                audioController.setDuration(currentDuration);
                audioController.play();
              }
            },
            icon: Icon(
              audioPlayerState.isPlaying ? Icons.pause : Icons.play_arrow,
              size: 40,
            ),
          ),
        )
      ],
    );
  }
}
