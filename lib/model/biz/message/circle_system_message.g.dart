// // GENERATED CODE - DO NOT MODIFY BY HAND
//
// part of 'circle_system_message.dart';
//
// // **************************************************************************
// // JsonSerializableGenerator
// // **************************************************************************
//
//
// CircleSystemMessage _$CircleSystemMessageFromJson(Map<String, dynamic> json) {
//   return CircleSystemMessage()
//     ..sentTime = json['sentTime'] == null
//         ? null
//         : DateTime.parse(json['sentTime'] as String)
//     ..receiver = json['receiver'] == null
//         ? null
//         : Account.fromJson(json['receiver'] as Map<String, dynamic>)
//     ..readStatus = _$enumDecodeNullable(_$ReadStatusEnumMap, json['readStatus'])
//     ..messageType =
//         _$enumDecodeNullable(_$MessageTypeEnumMap, json['messageType'])
//     ..id = json['id'] as int
//     ..gmtCreated = json['gmtCreated'] == null
//         ? null
//         : DateTime.parse(json['gmtCreated'] as String)
//     ..gmtModified = json['gmtModified'] == null
//         ? null
//         : DateTime.parse(json['gmtModified'] as String)
//     ..delete = json['delete'] as bool
//     ..circleId = json['circleId'] as int
//     ..title = json['title'] as String
//     ..content = json['content'] as String
//     ..approval = json['approval'] == null
//         ? null
//         : CircleApproval.fromJson(json['approval'] as Map<String, dynamic>)
//     ..applyAccount = json['applyAccount'] == null
//         ? null
//         : Account.fromJson(json['applyAccount'] as Map<String, dynamic>)
//     ..optAccount = json['optAccount'] == null
//         ? null
//         : Account.fromJson(json['optAccount'] as Map<String, dynamic>);
// }
//
// Map<String, dynamic> _$CircleSystemMessageToJson(
//         CircleSystemMessage instance) =>
//     <String, dynamic>{
//       'sentTime': instance.sentTime?.toIso8601String(),
//       'receiver': instance.receiver,
//       'readStatus': _$ReadStatusEnumMap[instance.readStatus],
//       'messageType': _$MessageTypeEnumMap[instance.messageType],
//       'id': instance.id,
//       'gmtCreated': instance.gmtCreated?.toIso8601String(),
//       'gmtModified': instance.gmtModified?.toIso8601String(),
//       'delete': instance.delete,
//       'circleId': instance.circleId,
//       'title': instance.title,
//       'content': instance.content,
//       'approval': instance.approval,
//       'applyAccount': instance.applyAccount,
//       'optAccount': instance.optAccount,
//     };
//
// T _$enumDecode<T>(
//   Map<T, dynamic> enumValues,
//   dynamic source, {
//   T unknownValue,
// }) {
//   if (source == null) {
//     throw ArgumentError('A value must be provided. Supported values: '
//         '${enumValues.values.join(', ')}');
//   }
//
//   final value = enumValues.entries
//       .singleWhere((e) => e.value == source, orElse: () => null)
//       ?.key;
//
//   if (value == null && unknownValue == null) {
//     throw ArgumentError('`$source` is not one of the supported values: '
//         '${enumValues.values.join(', ')}');
//   }
//   return value ?? unknownValue;
// }
//
// T _$enumDecodeNullable<T>(
//   Map<T, dynamic> enumValues,
//   dynamic source, {
//   T unknownValue,
// }) {
//   if (source == null) {
//     return null;
//   }
//   return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
// }
//
// const _$ReadStatusEnumMap = {
//   ReadStatus.read: 'READ',
//   ReadStatus.unRead: 'UNREAD',
//   ReadStatus.ignored: 'IGNORED',
// };
//
// const _$MessageTypeEnumMap = <MessageType, dynamic>{
//   MessageType.TWEET_PRAISE: 'TWEET_PRAISE',
//   MessageType.TWEET_REPLY: 'TWEET_REPLY',
//   MessageType.TOPIC_REPLY: 'TOPIC_REPLY',
//   MessageType.POPULAR: 'POPULAR',
//   MessageType.PLAIN_SYSTEM: 'PLAIN_SYSTEM',
//   MessageType.REPORT: 'REPORT',
//   MessageType.CIRCLE_APPLY: 'CIRCLE_APPLY',
//   MessageType.CIRCLE_APPLY_RES: 'CIRCLE_APPLY_RES',
//   MessageType.CIRCLE_SIMPLE_SYS: 'CIRCLE_SIMPLE_SYS',
// };
