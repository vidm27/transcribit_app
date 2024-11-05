import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:transcribit_app/features/history/providers/history_provider.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(historyNotifierProvider.notifier).loadNextPage();
    });
    initListenerScroll();
  }

  void initListenerScroll() {
    scrollController.addListener(() {
      if (ref.read(historyNotifierProvider.notifier).isLoading) return;

      if ((scrollController.position.pixels + 200) >=
          scrollController.position.maxScrollExtent) {
        ref.read(historyNotifierProvider.notifier).loadNextPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final historyState = ref.watch(historyNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: historyState.length,
                itemBuilder: (context, index) {
                  final transcription = historyState[index];
                  return ListTile(
                    onTap: () {
                      context.push("/transcription/${transcription.id}");
                    },
                    title: Text(transcription.title ?? "No tiene título"),
                    subtitle: Text(transcription.language ?? "No tiene idioma"),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
