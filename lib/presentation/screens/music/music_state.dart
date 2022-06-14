enum MusicStatus { none, loading, loaded, error }

class MusicState {

  const MusicState({this.status = MusicStatus.none});

  final MusicStatus status;

  static const MusicState initState = MusicState();
}