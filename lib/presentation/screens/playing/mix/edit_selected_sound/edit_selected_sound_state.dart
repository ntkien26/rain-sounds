import 'package:flutter/widgets.dart';
import 'package:rain_sounds/data/local/model/sound.dart';

enum EditSelectedSoundStatus { loading, success, empty, error, update }

@immutable
class EditSelectedSoundState {
  const EditSelectedSoundState({
    this.status = EditSelectedSoundStatus.empty,
    this.selectedSounds,
    this.sounds,
  });

  final EditSelectedSoundStatus status;
  final List<Sound>? selectedSounds;
  final List<Sound>? sounds;

  EditSelectedSoundState copyWith({
    EditSelectedSoundStatus? status,
    List<Sound>? selectedSounds,
    List<Sound>? sounds,
  }) {
    return EditSelectedSoundState(
      status: status ?? this.status,
      selectedSounds: selectedSounds ?? this.selectedSounds,
      sounds: sounds ?? this.sounds,
    );
  }

  static EditSelectedSoundState initial = const EditSelectedSoundState();
}
