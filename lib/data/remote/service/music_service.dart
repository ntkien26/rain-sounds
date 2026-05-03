import 'package:dio/dio.dart';
import 'package:rain_sounds/common/configs/env_config.dart';
import 'package:rain_sounds/data/remote/api/music_api.dart';
import 'package:rain_sounds/data/remote/model/group_music_model.dart';
import 'package:rain_sounds/data/remote/model/music_model.dart';
import 'package:rain_sounds/data/remote/service/base_service.dart';
import 'package:rain_sounds/data/remote/service/data_state.dart';

class MusicService with ConvertAbleDataState {

  MusicService(this._api);

  final MusicAPI _api;

  Future<DataState<List<GroupMusicModel>>> getListGroupMusic() async {
    try {
      final dio = Dio();

      final response = await dio.get(
        '${EnvConfig.supabaseUrl}/rest/v1/group_music',
        queryParameters: {
          'select': '*, music(*)',
          'order': 'id.asc',
        },
        options: Options(
          headers: {
            'apikey': EnvConfig.supabaseAnonKey,
            'Authorization': 'Bearer ${EnvConfig.supabaseAnonKey}',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        final List<GroupMusicModel> groups = [];

        for (final groupJson in data) {
          final List<dynamic> musicList = groupJson['music'] as List<dynamic>? ?? [];

          final List<MusicModel> items = musicList.map((musicJson) {
            return MusicModel(
              id: musicJson['id'] as int?,
              title: musicJson['title'] as String?,
              premium: musicJson['premium'] as bool? ?? false,
              group: groupJson['group_name'] as String?,
              url: musicJson['url'] as String?,
              thumbnail: musicJson['thumbnail'] as String?,
              background: musicJson['background'] as String?,
              badge: musicJson['badge'] as String?,
            );
          }).toList();

          groups.add(GroupMusicModel(
            group: groupJson['group_name'] as String?,
            description: groupJson['description'] as String?,
            items: items,
          ));
        }

        print("getListGroupMusic supabase: ${groups.length} groups");
        return DataSuccess<List<GroupMusicModel>>(groups);
      }

      return DataSuccess<List<GroupMusicModel>>([]);
    } catch (error) {
      print("getListGroupMusic error: $error");
      return DataSuccess<List<GroupMusicModel>>([]);
    }
  }
}