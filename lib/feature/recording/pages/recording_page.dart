import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:just_audio/just_audio.dart';

class RecordingPage extends StatefulWidget {
  const RecordingPage({super.key});

  @override
  State<RecordingPage> createState() => _RecordingPageState();
}

class _RecordingPageState extends State<RecordingPage> {
  final AudioRecorder audioRecorder = AudioRecorder();
  String? recordingPath;
  bool isRecording = false, isPlaying = false;
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _initAudio();
  }

  @override
  void dispose() {
    audioRecorder.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _initAudio() async {
    // Solicitar permiso para acceder al almacenamiento
    var status = await Permission.storage.request();
    if (status.isGranted) {
      // Establecer la ruta del archivo de audio local
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String filePath =
          '${appDocDir.path}/audio_example.mp3'; // Ruta del archivo local

      if (await File(filePath).exists()) {
        setState(() {
          recordingPath = filePath;
        });

        // Configurar el archivo de audio local
        await audioPlayer.setFilePath(recordingPath!);
      } else {
        print("Archivo de audio no encontrado en: $filePath");
      }

      // Escuchar cambios en el estado del reproductor
      audioPlayer.playerStateStream.listen((playerState) {
        if (playerState.processingState == ProcessingState.completed) {
          setState(() {
            isPlaying = false;
          });
        }
      });
    } else {
      print("Permiso denegado.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recorder'),
      ),
      floatingActionButton: _recodingButton(),
      body: _buildUI(),
    );
  }

  Widget _recodingButton() {
    return FloatingActionButton(
      onPressed: () async {
        if (isRecording) {
          final String? filePath = await audioRecorder.stop();
          if (filePath != null) {
            setState(() {
              isRecording = false;
              recordingPath = filePath;
            });
          }
        } else {
          if (await audioRecorder.hasPermission()) {
            final Directory appDir = await getApplicationDocumentsDirectory();
            final String filePath = path.join(
              appDir.path,
              "${DateTime.now()}.m4a",
            );
            await audioRecorder.start(const RecordConfig(), path: filePath);
            setState(() {
              isRecording = true;
              recordingPath = null;
            });
          }
        }
      },
      child: Icon(isRecording ? Icons.stop : Icons.mic),
    );
  }

  Widget _buildUI() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        children: [
          if (recordingPath != null)
            MaterialButton(
              onPressed: () {
                if (audioPlayer.playing) {
                  audioPlayer.stop();
                  setState(() {
                    isPlaying = false;
                  });
                } else {
                  audioPlayer.setFilePath(recordingPath!);
                  audioPlayer.play();
                  setState(() {
                    isPlaying = true;
                  });
                }
              },
              color: Theme.of(context).colorScheme.primary,
              child: Text(isPlaying ? 'Stop playing' : 'Start playing'),
            ),
          if (recordingPath == null) const Text('No recording found'),
        ],
      ),
    );
  }
}
