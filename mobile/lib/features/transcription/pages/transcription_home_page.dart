import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:transcribit_app/features/transcription/providers/providers.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool _isRecording = false;

  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final transcriptionState = ref.watch(transcriptionProvider);
    // ref.listen(transcriptionProvider, (previous, next) {
    //   if (next.isCompleted && context.mounted) {
    //     context.go("/transcription");
    //   }
    // });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transcripción'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const Row(
              children: [
                Text(
                  'Transcripción',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Buscar',
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.transparent),
                    gapPadding: 0),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: const Icon(Icons.mic, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            const Divider(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Transcripciones recientes',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        style: const ButtonStyle(
                            textStyle: WidgetStatePropertyAll<TextStyle>(
                                TextStyle(color: Colors.blue))),
                        child: const Text('Ver todos',
                            style: TextStyle(color: Colors.blue)),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 120,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: const [
                        Card(
                          child: Column(
                            children: [Text('Transcripción 1')],
                          ),
                        ),
                        Card(
                          child: Column(
                            children: [Text('Transcripción 1')],
                          ),
                        ),
                        Card(
                          child: Column(
                            children: [Text('Transcripción 1')],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                    "Crear una nueva transcripción",
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1C2E7A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                        onPressed: () async {
                          FilePickerResult? result = await FilePicker.platform
                              .pickFiles(allowedExtensions: [
                            'mp3',
                            'mp4',
                            'avi',
                            'mov',
                            'wav'
                          ], type: FileType.custom);
                          if (result != null) {
                            log('result.files.first.path: ${result.files.first.path}');
                            ref
                                .read(transcriptionProvider.notifier)
                                .setFilePath(result.files.first.path!);
                            if (context.mounted) {
                              context.push('/upload');
                            }
                          } else {
                            log('No seleccionaste un archivo');
                          }
                        },
                        child: const Wrap(
                          spacing: 20,
                          children: [
                            Icon(
                              Icons.cloud_upload_rounded,
                              color: Colors.white,
                            ),
                            Text(
                              'Cargar nuevo audio',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF607EFF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                        child: const Wrap(
                          spacing: 20,
                          children: [
                            Icon(Icons.mic, color: Colors.white),
                            Text('Iniciar grabación de audio',
                                style: TextStyle(color: Colors.white))
                          ],
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return FractionallySizedBox(
                                  heightFactor: 0.70,
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 20.0,
                                                backgroundColor:
                                                    Colors.grey[300],
                                                child: const Icon(
                                                  Icons.close,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const Spacer(),
                                              Wrap(
                                                spacing: 10.0,
                                                children: [
                                                  IconButton(
                                                    onPressed: () {},
                                                    icon: Icon(
                                                      Icons.delete_outline,
                                                      color: Colors.grey[500],
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {},
                                                    icon: Icon(
                                                      Icons.ios_share_outlined,
                                                      color: Colors.grey[500],
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: TextFormField(
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              hintText:
                                                  'Introduce el título de la transcripción',
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 50.0),
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Container(
                                                height: 110,
                                                width: 110,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color(0xFFFDEBEB),
                                                ),
                                              )
                                                  .animate(
                                                    onPlay: (controller) =>
                                                        controller.repeat(
                                                            reverse: true),
                                                  )
                                                  .fadeIn(
                                                    duration: 600.ms,
                                                  )
                                                  .scale(
                                                    duration: 600.ms,
                                                    begin:
                                                        const Offset(1.0, 1.0),
                                                    end: const Offset(1.3, 1.3),
                                                  ),
                                              Container(
                                                height: 90,
                                                width: 90,
                                                decoration: const BoxDecoration(
                                                    color: Color(0xFFFCDEDE),
                                                    shape: BoxShape.circle),
                                              )
                                                  .animate(
                                                    onPlay: (controller) =>
                                                        controller.repeat(
                                                            reverse: true),
                                                  )
                                                  .fadeIn(
                                                    duration: 600.ms,
                                                  )
                                                  .scale(
                                                    duration: 600.ms,
                                                    begin:
                                                        const Offset(1.0, 1.0),
                                                    end: const Offset(1.2, 1.2),
                                                  ),
                                              Container(
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
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        Container(
                                          color: const Color(0xFF607EFF),
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(10.0),
                                          height: 100,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                onTap: () {},
                                                child: const CircleAvatar(
                                                  radius: 20.0,
                                                  backgroundColor:
                                                      Color(0xFF222F6E),
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
                                                child: const CircleAvatar(
                                                  radius: 30.0,
                                                  backgroundColor:
                                                      Color(0xFF222F6E),
                                                  child: Icon(
                                                    Icons.stop,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10.0,
                                              ),
                                              const Text(
                                                '0:00',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 25.0),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
