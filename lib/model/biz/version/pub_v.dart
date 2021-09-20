import 'package:json_annotation/json_annotation.dart';

part 'pub_v.g.dart';

@JsonSerializable()
class VersionBO {
  int? versionId;
  String? name;
  String? mark;
  String? platform;
  String? apkUrl;
  DateTime? pubTime;
  String? description;
  String? updateDesc;
  String? cover;

  VersionBO();

  Map<String, dynamic> toJson() => _$PubVersionToJson(this);

  factory VersionBO.fromJson(Map<String, dynamic> json) => _$PubVersionFromJson(json);
}
