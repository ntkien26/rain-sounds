import 'package:rain_sounds/data/local/model/mix.dart';

enum NowMixPlayingStatus { loading, success, error, none }

class NowMixPlayingState {
  const NowMixPlayingState(
      {this.status = NowMixPlayingStatus.none, this.mix, this.isPlaying});

  final NowMixPlayingStatus status;
  final Mix? mix;
  final bool? isPlaying;

  NowMixPlayingState copyWith(
      {NowMixPlayingStatus? status, Mix? mix, bool? isPlaying}) {
    return NowMixPlayingState(
        status: status ?? this.status,
        mix: mix ?? this.mix,
        isPlaying: isPlaying ?? this.isPlaying);
  }

  static NowMixPlayingState initial = const NowMixPlayingState();
}
