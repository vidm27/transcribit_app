import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transcribit_app/features/transcription/models/transcription_model.dart';
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

  // final _selectedColor = const Color(0xff1a73e8);
  // final _unselectedColor = const Color(0xff5f6368);
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // tabController?.dispose();
    // audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transcription =
        ref.watch(transcriptionDetailProvider(widget.idTranscription));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Transcripción'),
      ),
      body: transcription.when(
        data: (data) {
          return Column(
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
                    child: _TranscriptionTextWidget(transcription: data),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _TranscriptionAudioWidget(
                        idTranscription: data.id, duration: data.duration!),
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
                      color: Colors.grey.withOpacity(0.5),
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
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.edit_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              )
            ],
          );
        },
        error: (error, stackTrace) => Text('Error, $error, $stackTrace'),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _TranscriptionTextWidget extends StatelessWidget {
  final TranscriptionDb transcription;
  const _TranscriptionTextWidget({super.key, required this.transcription});

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
  Widget build(BuildContext context) {
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
                        Text(
                          "${tiempoFormateado["start"]} - ${tiempoFormateado["end"]}",
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(segment.segmentOriginal,
                            style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w600)),
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
}

class _TranscriptionAudioWidget extends StatefulWidget {
  final String idTranscription;
  final String duration;
  const _TranscriptionAudioWidget(
      {super.key, required this.idTranscription, required this.duration});

  @override
  State<_TranscriptionAudioWidget> createState() =>
      _TranscriptionAudioWidgetState();
}

class _TranscriptionAudioWidgetState extends State<_TranscriptionAudioWidget> {
  bool isPlaying = false;
  final AudioPlayer audioPlayer = AudioPlayer();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initAudio();
  }

  @override
  void dispose() {
    if (mounted) {
      audioPlayer.dispose();
    }
    super.dispose();
  }

  void _initAudio() async {
    log("Init audio", level: 2);
    audioPlayer.onPlayerStateChanged.listen((state) async {
      log("State: $state", level: 2);
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
      if (state == PlayerState.playing && duration == Duration.zero) {
        final currentDuration = await audioPlayer.getDuration();
        setState(() {
          duration = currentDuration!;
        });
      }
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      log("Duration: $newDuration", level: 2);
      setState(() {
        duration = newDuration;
      });
    });

    audioPlayer.onPositionChanged.listen((newPosition) async {
      setState(() {
        position = newPosition;
      });
    });
    log("Init audio done", level: 2);
  }

  Duration tiempoToDuration(String tiempo) {
    var partes = tiempo.split(':');
    int minutos = int.parse(partes[0]);
    int segundos = int.parse(partes[1]);

    int milisegundos = partes.length > 2 ? int.parse(partes[2]) : 0;
    return Duration(
        minutes: minutos, seconds: segundos, milliseconds: milisegundos);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey(2),
      children: [
        Slider(
            min: 0,
            max: duration.inSeconds.toDouble(),
            value: position.inSeconds.clamp(0, duration.inSeconds).toDouble(),
            onChanged: (double value) async {
              position = Duration(seconds: value.toInt());
              await audioPlayer.seek(position);
              await audioPlayer.resume();
            }),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${position.inMinutes.toString().padLeft(2, '0')}:${(position.inSeconds % 60).toString().padLeft(2, '0')}",
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
            const Spacer(),
            Text(
                "${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}",
                style: const TextStyle())
          ],
        ),
        CircleAvatar(
          radius: 30,
          child: IconButton(
            onPressed: () async {
              if (audioPlayer.state == PlayerState.playing) {
                audioPlayer.pause();
              } else {
                final url =
                    'http://127.0.0.1:8000/api/v1/audio/${widget.idTranscription}';
                await audioPlayer.setSourceUrl(url);
                await audioPlayer.resume();
                setState(() {
                  isPlaying = true;
                  duration = tiempoToDuration(widget.duration);
                });
              }
            },
            icon: Icon(
              audioPlayer.state == PlayerState.playing
                  ? Icons.pause
                  : Icons.play_arrow,
              size: 40,
            ),
          ),
        )
      ],
    );
  }
}
