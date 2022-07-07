enum NowPlayingStatus { loading, success, error, none }

class NowPlayingState {
  const NowPlayingState(
      {this.status = NowPlayingStatus.none, this.isPlaying});

  final NowPlayingStatus status;
  final bool? isPlaying;

  NowPlayingState copyWith(
      {NowPlayingStatus? status, bool? isPlaying}) {
    return NowPlayingState(
        status: status ?? this.status,
        isPlaying: isPlaying ?? this.isPlaying);
  }

  static NowPlayingState initial = NowPlayingState();
}
