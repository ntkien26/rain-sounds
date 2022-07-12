import 'package:equatable/equatable.dart';
import 'package:rain_sounds/data/local/model/mix.dart';

abstract class EditSelectedSoundEvent extends Equatable {
  const EditSelectedSoundEvent();
}

class UpdateSound extends EditSelectedSoundEvent {
  final int soundId;
  final bool active;
  final double volume;

  const UpdateSound(
      {required this.soundId, required this.active, required this.volume});

  @override
  List<Object> get props => [soundId, active];
}

class RefreshEvent extends EditSelectedSoundEvent {
  @override
  List<Object?> get props => [];
}

class ResetEvent extends EditSelectedSoundEvent {

  final Mix mix;

  const ResetEvent({required this.mix});

  @override
  List<Object?> get props => [];
}