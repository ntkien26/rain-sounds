import 'package:flutter/widgets.dart';
import 'package:rain_sounds/data/local/model/sound.dart';

enum SoundsStatus { loading, success, empty, error, update }

@immutable
class SoundsState {
  const SoundsState(
      {this.status = SoundsStatus.empty,
      this.sounds,
      this.totalSelected,
      this.isPlaying});

  final SoundsStatus status;
  final List<Sound>? sounds;
  final int? totalSelected;
  final bool? isPlaying;

  SoundsState copyWith(
      {SoundsStatus? status,
      List<Sound>? sounds,
      int? totalSelected,
      bool? isPlaying = false}) {
    return SoundsState(
        status: status ?? this.status,
        sounds: sounds ?? this.sounds,
        totalSelected: totalSelected ?? this.totalSelected,
        isPlaying: isPlaying ?? this.isPlaying);
  }

  static SoundsState initial = const SoundsState();
}
