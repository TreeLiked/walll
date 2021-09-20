// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountProfile _$AccountProfileFromJson(Map<String, dynamic> json) {
  return AccountProfile()
    ..id = json['id'] as int
    ..accId = json['accId'] as String
    ..name = json['name'] as String
    ..mobile = json['mobile'] as String
    ..email = json['email'] as String
    ..gender = json['gender'] as String
    ..birthday = json['birthday'] == null
        ? null
        : DateTime.parse(json['birthday'] as String)
    ..province = json['province'] as String
    ..city = json['city'] as String
    ..district = json['district'] as String
    ..qq = json['qq'] as String
    ..wechat = json['wechat'] as String
    ..age = json['age'] as int
    ..displayHistoryTweet = json['displayHistoryTweet'] as bool;
}

Map<String, dynamic> _$AccountProfileToJson(AccountProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'accId': instance.accId,
      'name': instance.name,
      'mobile': instance.mobile,
      'email': instance.email,
      'gender': instance.gender,
      'birthday': instance.birthday?.toIso8601String(),
      'province': instance.province,
      'city': instance.city,
      'district': instance.district,
      'qq': instance.qq,
      'wechat': instance.wechat,
      'age': instance.age,
      'displayHistoryTweet': instance.displayHistoryTweet
    };
