import 'package:dio/dio.dart';
import 'package:rain_sounds/data/remote/model/group_music_model.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/http.dart';

part 'music_api.g.dart';

@RestApi()
abstract class MusicAPI {

  factory MusicAPI(Dio dio) = _MusicAPI;

  @GET("ios/{file}")
  Future<HttpResponse<List<GroupMusicModel>>> getListGroupMusic(@Path("file") String file);

}