// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pub_v.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VersionBO _$PubVersionFromJson(Map<String, dynamic> json) {
  return VersionBO()
    ..versionId = json['versionId'] as int
    ..name = json['name'] as String
    ..mark = json['mark'] as String
    ..platform = json['platform'] as String
    ..apkUrl = json['apkUrl'] as String
    ..pubTime = json['pubTime'] == null
        ? null
        : DateTime.parse(json['pubTime'] as String)
    ..description = json['description'] as String
    ..updateDesc = json['updateDesc'] as String
    ..cover = json['cover'] as String;
}

Map<String, dynamic> _$PubVersionToJson(VersionBO instance) =>
    <String, dynamic>{
      'versionId': instance.versionId,
      'name': instance.name,
      'mark': instance.mark,
      'platform': instance.platform,
      'apkUrl': instance.apkUrl,
      'pubTime': instance.pubTime?.toIso8601String(),
      'description': instance.description,
      'updateDesc': instance.updateDesc,
      'cover': instance.cover
    };
