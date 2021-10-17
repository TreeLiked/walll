// import 'package:json_annotation/json_annotation.dart';
// import 'package:wall/model/biz/account/account.dart';
// import 'package:wall/model/biz/message/asbtract_message.dart';
//
// part 'circle_system_message.g.dart';
//
// @JsonSerializable()
// class CircleSystemMessage extends AbstractMessage {
//   /// apply
//   late int circleId;
//   String? title;
//   String? content;
//   CircleApproval? approval;
//   Account? applyAccount;
//
//   /// apply res 增加
//   Account? optAccount;
//
//   /// simple notification
//
//   CircleSystemMessage();
//
//   Map<String, dynamic> toJson() => _$CircleSystemMessageToJson(this);
//
//   factory CircleSystemMessage.fromJson(Map<String, dynamic> json) => _$CircleSystemMessageFromJson(json);
//
//   String getSimpleBody() {
//     if (messageType == MessageType.CIRCLE_APPLY) {
//       return '${applyAccount.nick}申请加入${approval.circleName}';
//     } else if (messageType == MessageType.CIRCLE_APPLY_RES) {
//       bool agree = approval.status == 1;
//       return '${optAccount.id == Application.getAccountId ? '你' : optAccount.nick}已${agree ? '同意' : '拒绝'}'
//           '${applyAccount.id == Application.getAccountId ? '你' : applyAccount.nick}加入${approval.circleName}';
//     } else if (messageType == MessageType.CIRCLE_SIMPLE_SYS) {
//       return '$content';
//     } else {
//       return '不支持的消息类型';
//     }
//   }
// }
