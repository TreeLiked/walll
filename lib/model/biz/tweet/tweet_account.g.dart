// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tweet_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TweetAccount _$TweetAccountFromJson(Map<String, dynamic> json) {
  return TweetAccount()
    ..id = json['id'] as String
    ..nick = json['nick'] as String
    ..signature = json['signature'] as String
    ..avatarUrl = json['avatarUrl'] as String
    ..institute = json['institute'] as String
    ..cla = json['cla'] as String
    ..gender = json['gender'] as String;
}

Map<String, dynamic> _$TweetAccountToJson(TweetAccount instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nick': instance.nick,
      'signature': instance.signature,
      'avatarUrl': instance.avatarUrl,
      'institute': instance.institute,
      'cla': instance.cla,
      'gender': instance.gender
    };
