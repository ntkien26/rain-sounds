import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rain_sounds/data/remote/model/group_music_model.dart';
import 'package:rain_sounds/data/remote/service/data_state.dart';
import 'package:rain_sounds/data/remote/service/music_service.dart';
import 'package:rain_sounds/presentation/screens/music/music_event.dart';
import 'package:rain_sounds/presentation/screens/music/music_state.dart';

class MusicBloc extends Bloc<MusicEvent, MusicState> {

  final MusicService musicService;

  MusicBloc({required this.musicService}) : super(MusicState.initial) {
      loadGroupMusic();
  }

  Future<void> loadGroupMusic() async {
    emit(state.copyWith(status: MusicStatus.loading));

    final DataState<List<GroupMusicModel>> dataState = await musicService.getListGroupMusic();

    if (dataState.error != null) {
      emit(state.copyWith(status: MusicStatus.error));
      return;
    }

    if (dataState.data == null) {
      emit(state.copyWith(status: MusicStatus.empty));
      return;
    }

    emit(state.copyWith(status: MusicStatus.success, groupMusicList: dataState.data));
  }
}