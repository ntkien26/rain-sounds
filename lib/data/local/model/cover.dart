import 'package:json_annotation/json_annotation.dart';

part 'cover.g.dart';

@JsonSerializable()
class Cover {
  String? thumbnail;
  String? background;

  Cover({this.thumbnail, this.background});

  factory Cover.fromJson(Map<String, dynamic> json) => _$CoverFromJson(json);
}