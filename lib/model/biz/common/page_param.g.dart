// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PageParam _$PageParamFromJson(Map<String, dynamic> json) {
  return PageParam(json['currentPage'] as int,
      pageSize: json['pageSize'] as int,
      types: (json['types'] as List).map((e) => e as String).toList(),
      orgId: json['orgId'] as int);
}

Map<String, dynamic> _$PageParamToJson(PageParam instance) => <String, dynamic>{
      'currentPage': instance.currentPage,
      'pageSize': instance.pageSize,
      'types': instance.types,
      'orgId': instance.orgId
    };
