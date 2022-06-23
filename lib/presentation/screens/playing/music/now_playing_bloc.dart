import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rain_sounds/data/local/service/sound_service.dart';
import 'package:rain_sounds/presentation/screens/playing/music/now_playing_event.dart';
import 'package:rain_sounds/presentation/screens/playing/music/now_playing_state.dart';

class NowPlayingBloc extends Bloc<NowPlayingEvent, NowPlayingState> {
  final SoundService soundService;

  NowPlayingBloc(this.soundService) : super(NowPlayingState.initial) {
    on(_onNowPlayingEvent);
  }

  Future<void> _onNowPlayingEvent(
      NowPlayingEvent event, Emitter<NowPlayingState> emit) async {

    if (event is PlayMusicEvent) {

      emit(state.copyWith(isPlaying: true, ));
    } else if (event is ToggleEvent) {

    }
  }
}
