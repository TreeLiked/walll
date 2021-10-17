// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asbtract_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AbstractMessage _$AbstractMessageFromJson(Map<String, dynamic> json) {
  MessageType mst = _$enumDecodeNullable(_$MessageTypeEnumMap, json['messageType'])!;
  switch (mst) {
    case MessageType.TOPIC_REPLY:
      return TopicReplyMessage.fromJson(json);
    case MessageType.TWEET_PRAISE:
      return TweetPraiseMessage.fromJson(json);
    case MessageType.TWEET_REPLY:
      return TweetReplyMessage.fromJson(json);
    case MessageType.POPULAR:
      return PopularMessage.fromJson(json);
    case MessageType.PLAIN_SYSTEM:
      return PlainSystemMessage.fromJson(json);
    case MessageType.REPORT:
      // TODO: Handle this case.
      return AbstractMessage();
    case MessageType.CIRCLE_APPLY:
    case MessageType.CIRCLE_APPLY_RES:
    case MessageType.CIRCLE_SIMPLE_SYS:
      // TODO: Handle this case.
      return AbstractMessage();
  }
  // return AbstractMessage()
  //   ..sentTime = json['sentTime'] == null ? null : DateTime.parse(json['sentTime'] as String)
  //   ..receiver = json['receiver'] == null ? null : Account.fromJson(json['receiver'] as Map<String, dynamic>)
  //   ..readStatus = _$enumDecodeNullable(_$ReadStatusEnumMap, json['readStatus'])
  //   ..messageType = _$enumDecodeNullable(_$MessageTypeEnumMap, json['messageType'])
  //   ..id = json['id'] as int
  //   ..gmtCreated = json['gmtCreated'] == null ? null : DateTime.parse(json['gmtCreated'] as String)
  //   ..gmtModified = json['gmtModified'] == null ? null : DateTime.parse(json['gmtModified'] as String)
  //   ..delete = json['delete'] as bool;
}

Map<String, dynamic> _$AbstractMessageToJson(AbstractMessage instance) => <String, dynamic>{
      'sentTime': instance.sentTime.toIso8601String(),
      'receiver': instance.receiver,
      'readStatus': _$ReadStatusEnumMap[instance.readStatus],
      'messageType': _$MessageTypeEnumMap[instance.messageType],
      'id': instance.id,
      'gmtCreated': instance.gmtCreated!.toIso8601String(),
      'gmtModified': instance.gmtModified!.toIso8601String(),
      'delete': instance.delete
    };

T _$enumDecode<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }
  return enumValues.entries
      .singleWhere((e) => e.value == source,
          orElse: () => throw ArgumentError('`$source` is not one of the supported values: '
              '${enumValues.values.join(', ')}'))
      .key;
}

T? _$enumDecodeNullable<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source);
}

const _$ReadStatusEnumMap = <ReadStatus, dynamic>{
  ReadStatus.read: 'READ',
  ReadStatus.unRead: 'UNREAD',
  ReadStatus.ignored: 'IGNORED'
};

const _$MessageTypeEnumMap = <MessageType, dynamic>{
  MessageType.TWEET_PRAISE: 'TWEET_PRAISE',
  MessageType.TWEET_REPLY: 'TWEET_REPLY',
  MessageType.TOPIC_REPLY: 'TOPIC_REPLY',
  MessageType.POPULAR: 'POPULAR',
  MessageType.PLAIN_SYSTEM: 'PLAIN_SYSTEM',
  MessageType.REPORT: 'REPORT',
  MessageType.CIRCLE_APPLY: 'CIRCLE_APPLY',
  MessageType.CIRCLE_APPLY_RES: 'CIRCLE_APPLY_RES',
  MessageType.CIRCLE_SIMPLE_SYS: 'CIRCLE_SIMPLE_SYS',
};
