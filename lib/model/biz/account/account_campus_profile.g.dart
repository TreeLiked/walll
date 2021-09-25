// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_campus_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountCampusProfile _$AccountCampusProfileFromJson(Map<String, dynamic> json) {
  return AccountCampusProfile()
    ..institute = json['institute'] == null
        ? null
        : Institute.fromJson(json['institute'] as Map<String, dynamic>)
    ..major = json['major'] as String
    ..grade = json['grade'] as String
    ..cla = json['cla'] as String
    ..stuId = json['stuId'] as String;
}

Map<String, dynamic> _$AccountCampusProfileToJson(
        AccountCampusProfile instance) =>
    <String, dynamic>{
      'institute': instance.institute,
      'major': instance.major,
      'grade': instance.grade,
      'cla': instance.cla,
      'stuId': instance.stuId
    };
