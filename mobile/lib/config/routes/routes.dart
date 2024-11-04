import 'dart:developer';

import 'package:go_router/go_router.dart';
import 'package:transcribit_app/features/features.dart';
import 'package:transcribit_app/features/transcription/pages/transcription_detail_page.dart';

import '../../features/transcription/pages/pages.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MenuScreen(),
    ),
    GoRoute(
      path: '/upload',
      name: UploadPage.name,
      builder: (context, state) => const UploadPage(),
    ),
    GoRoute(
      path: '/transcription/:id',
      name: TranscriptionDetailPage.name,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        log("Transcription id: $id", level: 2);
        return TranscriptionDetailPage(idTranscription: id);
      },
    ),
  ],
);
