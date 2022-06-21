import 'package:equatable/equatable.dart';

abstract class SoundsEvent extends Equatable {
  const SoundsEvent();
}

class UpdateSound extends SoundsEvent {
  final int soundId;
  final bool active;
  final double volume;

  const UpdateSound(
      {required this.soundId, required this.active, required this.volume});

  @override
  List<Object> get props => [soundId, active];
}

class ToggleSoundsEvent extends SoundsEvent {

  @override
  List<Object?> get props => [];

}

class StopAllSoundsEvent extends SoundsEvent {

  @override
  List<Object?> get props => [];
}

class RefreshEvent extends SoundsEvent {
  @override
  List<Object?> get props => [];
}