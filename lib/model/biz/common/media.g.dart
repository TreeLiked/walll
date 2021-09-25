// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Media _$MediaFromJson(Map<String, dynamic> json) {
  return Media()
    ..index = json['index'] as int
    ..module = json['module'] as String
    ..mediaType = json['mediaType'] as String
    ..url = json['url'] as String
    ..name = json['name'] as String;
}

Map<String, dynamic> _$MediaToJson(Media instance) => <String, dynamic>{
      'index': instance.index,
      'module': instance.module,
      'mediaType': instance.mediaType,
      'url': instance.url,
      'name': instance.name
    };
