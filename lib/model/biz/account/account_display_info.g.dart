// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_display_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountDisplayInfo _$AccountDisplayInfoFromJson(Map<String, dynamic> json) {
  return AccountDisplayInfo()
    ..displayHistoryTweet = json['displayHistoryTweet'] as bool
    ..nick = json['nick'] as String
    ..signature = json['signature'] as String
    ..role = _$enumDecodeNullable(_$AccountRoleEnumMap, json['role'])
    ..avatarUrl = json['avatarUrl'] as String
    ..email = json['email'] as String
    ..displayName = json['displayName'] as bool
    ..name = json['name'] as String
    ..displaySex = json['displaySex'] as bool
    ..gender = json['gender'] as String
    ..displayAge = json['displayAge'] as bool
    ..age = json['age'] as int
    ..displayQQ = json['displayQQ'] as bool
    ..qq = json['qq'] as String
    ..displayWeChat = json['displayWeChat'] as bool
    ..wechat = json['wechat'] as String
    ..displayPhone = json['displayPhone'] as bool
    ..mobile = json['mobile'] as String
    ..displayRegion = json['displayRegion'] as bool
    ..province = json['province'] as String
    ..city = json['city'] as String
    ..district = json['district'] as String
    ..displayInstitute = json['displayInstitute'] as bool
    ..displayMajor = json['displayMajor'] as bool
    ..displayCla = json['displayCla'] as bool
    ..displayGrade = json['displayGrade'] as bool
    ..instituteName = json['instituteName'] as String
    ..major = json['major'] as String
    ..grade = json['grade'] as String
    ..cla = json['cla'] as String;
}

Map<String, dynamic> _$AccountDisplayInfoToJson(AccountDisplayInfo instance) =>
    <String, dynamic>{
      'displayHistoryTweet': instance.displayHistoryTweet,
      'nick': instance.nick,
      'signature': instance.signature,
      'role': _$AccountRoleEnumMap[instance.role],
      'avatarUrl': instance.avatarUrl,
      'email': instance.email,
      'displayName': instance.displayName,
      'name': instance.name,
      'displaySex': instance.displaySex,
      'gender': instance.gender,
      'displayAge': instance.displayAge,
      'age': instance.age,
      'displayQQ': instance.displayQQ,
      'qq': instance.qq,
      'displayWeChat': instance.displayWeChat,
      'wechat': instance.wechat,
      'displayPhone': instance.displayPhone,
      'mobile': instance.mobile,
      'displayRegion': instance.displayRegion,
      'province': instance.province,
      'city': instance.city,
      'district': instance.district,
      'displayInstitute': instance.displayInstitute,
      'displayMajor': instance.displayMajor,
      'displayCla': instance.displayCla,
      'displayGrade': instance.displayGrade,
      'instituteName': instance.instituteName,
      'major': instance.major,
      'grade': instance.grade,
      'cla': instance.cla
    };

T? _$enumDecode<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }
  return enumValues.entries
      .singleWhere((e) => e.value == source,
          orElse: () => throw ArgumentError(
              '`$source` is not one of the supported values: '
              '${enumValues.values.join(', ')}'))
      .key;
}

T? _$enumDecodeNullable<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source);
}

const _$AccountRoleEnumMap = <AccountRole, dynamic>{
  AccountRole.user: 'USER',
  AccountRole.schoolAdmin: 'SCHOOL_ADMIN',
  AccountRole.systemAdmin: 'SYSTEM_ADMIN'
};
