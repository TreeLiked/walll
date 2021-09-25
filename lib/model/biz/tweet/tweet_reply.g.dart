// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tweet_reply.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TweetReply _$TweetReplyFromJson(Map<String, dynamic> json) {
  return TweetReply()
    ..id = json['id'] as int
    ..tweetId = json['tweetId'] as int
    ..parentId = json['parentId'] as int
    ..type = json['type'] as int
    ..body = json['body'] as String
    ..account = json['account'] == null ? null : Account.fromJson(json['account'] as Map<String, dynamic>)
    ..tarAccount =
        json['tarAccount'] == null ? null : Account.fromJson(json['tarAccount'] as Map<String, dynamic>)
    ..children = json['children'] == null
        ? null
        : (json['children'] as List)
            .map((e) => e == null ? null : TweetReply.fromJson(e as Map<String, dynamic>))
            .cast<TweetReply>()
            .toList()
    ..anonymous = json['anonymous'] as bool
    ..hot = json['hot'] as int
    ..praise = json['praise'] as int
    ..replyCount = json['replyCount'] as int
    ..bizCode = json['bizCode'] as String
    ..gmtModified = json['gmtModified'] == null ? null : DateTime.parse(json['gmtModified'] as String)
    ..gmtCreated = json['gmtCreated'] == null ? null : DateTime.parse(json['gmtCreated'] as String)
    ..sentTime = json['sentTime'] == null ? null : DateTime.parse(json['sentTime'] as String);
}

Map<String, dynamic> _$TweetReplyToJson(TweetReply instance) => <String, dynamic>{
      'id': instance.id,
      'tweetId': instance.tweetId,
      'parentId': instance.parentId,
      'type': instance.type,
      'body': instance.body,
      'account': instance.account,
      'tarAccount': instance.tarAccount,
      'children': instance.children,
      'anonymous': instance.anonymous,
      'hot': instance.hot,
      'praise': instance.praise,
      'replyCount': instance.replyCount,
      'bizCode': instance.bizCode,
      'gmtModified': instance.gmtModified?.toIso8601String(),
      'gmtCreated': instance.gmtCreated?.toIso8601String(),
      'sentTime': DateUtil.formatDate(instance.sentTime, format: DateFormats.full),
    };
