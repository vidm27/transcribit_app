import 'dart:async';
import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:transcribit_app/features/transcription/providers/providers.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row(
                //   children: [
                //     const Text(
                //       'Transcripciones recientes',
                //       style: TextStyle(
                //           color: Colors.black,
                //           fontSize: 18.0,
                //           fontWeight: FontWeight.bold),
                //     ),
                //     const Spacer(),
                //     TextButton(
                //       onPressed: () {},
                //       style: const ButtonStyle(
                //           textStyle: WidgetStatePropertyAll<TextStyle>(
                //               TextStyle(color: Colors.blue))),
                //       child: const Text('Ver todos',
                //           style: TextStyle(color: Colors.blue)),
                //     ),
                //   ],
                // ),
                // SizedBox(
                //   width: MediaQuery.of(context).size.width,
                //   height: 120,
                //   child: ListView(
                //     scrollDirection: Axis.horizontal,
                //     children: const [
                //       Card(
                //         child: Column(
                //           children: [Text('Transcripción 1')],
                //         ),
                //       ),
                //       Card(
                //         child: Column(
                //           children: [Text('Transcripción 1')],
                //         ),
                //       ),
                //       Card(
                //         child: Column(
                //           children: [Text('Transcripción 1')],
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                const SizedBox(
                  height: 12,
                ),
                const Text(
                  "Crear una nueva transcripción",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
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
                          minimumSize: const Size.fromHeight(50),
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
                        context.push('/recording');
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                )
              ],
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
