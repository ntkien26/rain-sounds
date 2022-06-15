import 'package:rain_sounds/data/local/model/sound.dart';

enum SoundsStatus { loading, success, empty, error }

class SoundsState {

  const SoundsState({this.status = SoundsStatus.empty, this.sounds});

  final SoundsStatus status;
  final List<Sound>? sounds;

  SoundsState copyWith(
      {SoundsStatus? status, List<Sound>? sounds}) {
    return SoundsState(status: status ?? this.status, sounds: sounds);
  }

  static SoundsState initial = const SoundsState();
}