import 'package:dio/dio.dart';
import 'package:rain_sounds/data/remote/api/music_api.dart';
import 'package:rain_sounds/data/remote/model/group_music_model.dart';
import 'package:rain_sounds/data/remote/service/base_service.dart';
import 'package:rain_sounds/data/remote/service/data_state.dart';
import 'package:retrofit/dio.dart';

class MusicService with ConvertAbleDataState {

  MusicService(this._api);

  final MusicAPI _api;

  Future<DataState<List<GroupMusicModel>>> getListGroupMusic() async {
    try {
      final HttpResponse<List<GroupMusicModel>> _response = await _api.getListGroupMusic("sleep_music.json");
      print("getListGroupMusic: ${_response.data.length}");
      return convertToDataState(_response);
    } on DioError catch (error) {
      print("getListGroupMusic: ${error}");
      return DataFailed<List<GroupMusicModel>>(error);
    }
  }
}