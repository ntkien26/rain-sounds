import 'package:dio/dio.dart';
import 'package:rain_sounds/common/configs/network_config.dart';
import 'package:rain_sounds/data/remote/model/group_music_json_model.dart';
import 'package:retrofit/http.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: NetworkConfig.baseUrl)
abstract class RestClient {

  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("/sleep_music.json")
  Future<List<GroupMusicJsonModel>> getListGroupMusic();

}