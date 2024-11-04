import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:transcribit_app/features/transcription/pages/transcription_home_page.dart';
import 'package:transcribit_app/features/transcription/providers/transcription_provider.dart';

class UploadPage extends ConsumerStatefulWidget {
  static const name = 'upload_page';
  const UploadPage({super.key});

  @override
  ConsumerState<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends ConsumerState<UploadPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    Future.microtask(() {
      ref.read(transcriptionProvider.notifier).uploadFile();
    });
  }

  @override
  void dispose() {
    super.dispose();

    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transcriptionState = ref.watch(transcriptionProvider);
    ref.listen(transcriptionProvider, (previous, next) {
      if (next.isCompleted && context.mounted && next.idTranscription != null) {
        context.push("/transcription/${next.idTranscription}");
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cargando archivo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 90,
              width: MediaQuery.sizeOf(context).width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 25,
                    width: MediaQuery.sizeOf(context).width * 0.8,
                    child: TweenAnimationBuilder(
                        tween: Tween<double>(
                            begin: 0, end: transcriptionState.progress),
                        duration: const Duration(milliseconds: 300),
                        builder: (context, value, child) {
                          return LinearProgressIndicator(
                            backgroundColor: const Color(0xFFE9E9E9),
                            color: const Color(0xFF5286FF),
                            value: value,
                            minHeight: 25,
                            borderRadius: BorderRadius.circular(10.0),
                          );
                        }),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text("Carga de archivo en progreso...",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.8,
                  child: const Text(
                    "La transcripción aparecerá aquí una vez completada",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Color(0xFFA9A9A9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
