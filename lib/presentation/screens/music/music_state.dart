import 'package:rain_sounds/data/remote/model/group_music_model.dart';

enum MusicStatus { loading, success, empty, error }

class MusicState {

  const MusicState({this.status = MusicStatus.empty, this.groupMusicList});

  final MusicStatus status;
  final List<GroupMusicModel>? groupMusicList;

  MusicState copyWith(
      {MusicStatus? status, List<GroupMusicModel>? groupMusicList}) {
    return MusicState(status: status ?? this.status, groupMusicList: groupMusicList);
  }

  static MusicState initial = const MusicState();
}