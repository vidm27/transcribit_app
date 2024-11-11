import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AudioPlayerController extends StateNotifier<AudioPlayerState> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  AudioPlayerController() : super(AudioPlayerState());

  void init(String url) async {
    _audioPlayer.setSourceUrl(url);
    _audioPlayer.onPlayerStateChanged.listen((state) {
      final isPlaying = state == PlayerState.playing;
      updateState(isPlaying: isPlaying);
    });

    _audioPlayer.onPositionChanged.listen((position) {
      updateState(position: position);
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      updateState(duration: duration);
    });
  }

  void setDuration(Duration duration) => updateState(duration: duration);

  void play() => _audioPlayer.resume();

  void pause() => _audioPlayer.pause();

  void seek(Duration position) => _audioPlayer.seek(position);

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void updateState({bool? isPlaying, Duration? position, Duration? duration}) {
    state = state.copyWith(
      isPlaying: isPlaying ?? state.isPlaying,
      position: position ?? state.position,
      duration: duration ?? state.duration,
    );
  }
}

class AudioPlayerState {
  final bool isPlaying;
  final Duration position;
  final Duration duration;

  AudioPlayerState({
    this.isPlaying = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
  });

  AudioPlayerState copyWith({
    bool? isPlaying,
    Duration? position,
    Duration? duration,
  }) {
    return AudioPlayerState(
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      duration: duration ?? this.duration,
    );
  }
}

final audioPlayerProvider = StateNotifierProvider<AudioPlayerController, AudioPlayerState>(
  (ref) => AudioPlayerController(),
);
