// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Account _$AccountFromJson(Map<String, dynamic> json) {
  return Account()
    ..id = json['id'] as String
    ..nick = json['nick'] as String
    ..signature = json['signature'] as String
    ..avatarUrl = json['avatarUrl'] as String
    ..mobile = json['mobile'] as String
    ..regType = json['regType'] as int
    ..openId = json['openId'] as String
    ..birthDay = json['birthDay'] == null
        ? null
        : DateTime.parse(json['birthDay'] as String)
    ..gender = json['gender'] as String
    ..province = json['province'] as String
    ..city = json['city'] as String
    ..district = json['district'] as String
    ..qq = json['qq'] as String
    ..weixin = json['weixin'] as String
    ..profile = json['profile'] == null
        ? null
        : AccountProfile.fromJson(json['profile'] as Map<String, dynamic>);
}

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'id': instance.id,
      'nick': instance.nick,
      'signature': instance.signature,
      'avatarUrl': instance.avatarUrl,
      'mobile': instance.mobile,
      'regType': instance.regType,
      'openId': instance.openId,
      'birthDay': instance.birthDay?.toIso8601String(),
      'gender': instance.gender,
      'province': instance.province,
      'city': instance.city,
      'district': instance.district,
      'qq': instance.qq,
      'weixin': instance.weixin,
      'profile': instance.profile
    };
