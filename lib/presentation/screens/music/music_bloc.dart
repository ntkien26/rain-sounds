import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rain_sounds/data/remote/client/rest_client.dart';
import 'package:rain_sounds/presentation/screens/music/music_event.dart';
import 'package:rain_sounds/presentation/screens/music/music_state.dart';

class MusicBloc extends Bloc<MusicEvent, MusicState> {

  final RestClient restClient;

  MusicBloc({required this.restClient}) : super(MusicState.initState) {
      loadGroupMusic();
  }

  Future<void> loadGroupMusic() async {
    print('Load group music');
    final list = await restClient.getListGroupMusic();
    list.forEach((element) {
      print('Group: ${element.group}');
    });
  }
}