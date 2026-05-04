enum NowPlayingStatus { loading, success, error, none }

class NowPlayingState {
  const NowPlayingState({
    this.status = NowPlayingStatus.none,
    this.isPlaying,
    this.isLooping = false,
    this.sleepTimerRemaining,
  });

  final NowPlayingStatus status;
  final bool? isPlaying;
  final bool isLooping;
  final Duration? sleepTimerRemaining;

  NowPlayingState copyWith({
    NowPlayingStatus? status,
    bool? isPlaying,
    bool? isLooping,
    Duration? sleepTimerRemaining,
    bool clearSleepTimer = false,
  }) {
    return NowPlayingState(
      status: status ?? this.status,
      isPlaying: isPlaying ?? this.isPlaying,
      isLooping: isLooping ?? this.isLooping,
      sleepTimerRemaining:
          clearSleepTimer ? null : (sleepTimerRemaining ?? this.sleepTimerRemaining),
    );
  }

  static NowPlayingState initial = const NowPlayingState();
}
