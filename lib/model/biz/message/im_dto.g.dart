// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'im_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImDTO _$ImDTOFromJson(Map<String, dynamic> json) {
  return ImDTO()
    ..command = json['command'] as int
    ..data = json['data'];
}

Map<String, dynamic> _$ImDTOToJson(ImDTO instance) => <String, dynamic>{
      'command': instance.command,
      'data': instance.data,
    };
