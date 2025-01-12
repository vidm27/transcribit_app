import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
// import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:transcribit_app/features/transcription/providers/transcription_provider.dart'; // Ensure the spelling is correct
// import 'package:just_audio/just_audio.dart';

class RecordingPage extends ConsumerStatefulWidget {
  static const name = 'recording';
  const RecordingPage({super.key});

  @override
  ConsumerState<RecordingPage> createState() => _RecordingPageState();
}

class _RecordingPageState extends ConsumerState<RecordingPage> {
  final AudioRecorder audioRecorder = AudioRecorder();
  String? recordingPath;
  bool isRecording = false, isPlaying = false;
  Duration _recordingDuration = Duration.zero;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // _initAudio();
  }

  @override
  void dispose() {
    audioRecorder.dispose();
    // audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Recorder'),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                context.go('/upload');
              },
            )
          ],
        ),
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (isRecording) ...animatedHeartRecording(),
                      GestureDetector(
                        onTap: () async {
                          if (isRecording) {
                            await _stopRecording();
                          } else {
                            await _startRecording();
                          }
                        },
                        child: Container(
                          height: 70,
                          width: 70,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFD76060),
                          ),
                          child: const Icon(
                            Icons.mic,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Container(
                color: const Color(0xFF607EFF),
                width: double.infinity,
                padding: const EdgeInsets.all(10.0),
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (isRecording) {
                          audioRecorder.pause();
                          setState(() {
                            isRecording = false;
                          });
                        }
                      },
                      child: const CircleAvatar(
                        radius: 20.0,
                        backgroundColor: Color(0xFF222F6E),
                        child: Icon(
                          Icons.pause,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (isRecording) {
                          await _stopRecording();
                        }
                      },
                      child: const CircleAvatar(
                        radius: 30.0,
                        backgroundColor: Color(0xFF222F6E),
                        child: Icon(
                          Icons.stop,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      _recordingDuration
                          .toString()
                          .split('.')
                          .first
                          .padLeft(8, "0"),
                      style:
                          const TextStyle(color: Colors.white, fontSize: 25.0),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  List<Widget> animatedHeartRecording() {
    return [
      Container(
        height: 110,
        width: 110,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFFDEBEB),
        ),
      )
          .animate(
            onPlay: (controller) => controller.repeat(reverse: true),
          )
          .fadeIn(
            duration: 600.ms,
          )
          .scale(
            duration: 600.ms,
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.3, 1.3),
          ),
      Container(
        height: 90,
        width: 90,
        decoration: const BoxDecoration(
            color: Color(0xFFFCDEDE), shape: BoxShape.circle),
      )
          .animate(
            onPlay: (controller) => controller.repeat(reverse: true),
          )
          .fadeIn(
            duration: 600.ms,
          )
          .scale(
            duration: 600.ms,
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.2, 1.2),
          )
    ];
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordingDuration += const Duration(seconds: 1);
      });
    });
  }

  Future<void> _startRecording() async {
    if (await audioRecorder.hasPermission()) {
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String filePath = path.join(
          appDocDir.path, "${DateTime.now().millisecondsSinceEpoch}.m4a");
      setState(() {
        isRecording = true;
        _recordingDuration = Duration.zero;
      });
      await audioRecorder.start(const RecordConfig(), path: filePath);
      _startTimer();
    }
  }

  Future<void> _stopRecording() async {
    if (isRecording) {
      String? currentPath = await audioRecorder.stop();
      setState(() {
        isRecording = false;
        recordingPath = currentPath;
      });
      _stopTimer();
      ref.read(transcriptionProvider.notifier).setFilePath(recordingPath!);
    }
  }
}
