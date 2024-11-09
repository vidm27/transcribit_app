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
  bool isPlaying = false;
  final AudioPlayer audioPlayer = AudioPlayer();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  final _selectedColor = const Color(0xff1a73e8);
  final _unselectedColor = const Color(0xff5f6368);
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    _initAudio();
  }

  Duration tiempoToDuration(String tiempo) {
    var partes = tiempo.split(':');
    int minutos = int.parse(partes[0]);
    int segundos = int.parse(partes[1]);

    int milisegundos = partes.length > 2 ? int.parse(partes[2]) : 0;
    return Duration(
        minutes: minutos, seconds: segundos, milliseconds: milisegundos);
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
        body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: transcription.when(
                data: (data) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                color: Colors.white),
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.black,
                            tabs: const [
                              Tab(text: 'Transcripción'),
                              Tab(text: 'Audio'),
                            ]),
                      ),
                      Expanded(
                        child: TabBarView(controller: tabController, children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
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
                                        final tiempoFormateado =
                                            tiempoToTextFormat(segment);
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${tiempoFormateado["start"]} - ${tiempoFormateado["end"]}",
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
                                      }),
                                ),
                              ]),
                          Column(
                            key: const ValueKey(2),
                            children: [
                              Slider(
                                  min: 0,
                                  max: duration.inSeconds.toDouble(),
                                  value: position.inSeconds
                                      .clamp(0, duration.inSeconds)
                                      .toDouble(),
                                  onChanged: (double value) async {
                                    position = Duration(seconds: value.toInt());
                                    await audioPlayer.seek(position);
                                    await audioPlayer.resume();
                                  }),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    if (audioPlayer.state ==
                                        PlayerState.playing) {
                                      audioPlayer.pause();
                                    } else {
                                      final url =
                                          'http://127.0.0.1:8000/api/v1/audio/${data.id}';
                                      await audioPlayer.setSourceUrl(url);
                                      await audioPlayer.resume();
                                      setState(() {
                                        isPlaying = true;
                                        duration =
                                            tiempoToDuration(data.duration!);
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
                          )
                        ]),
                      )
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
