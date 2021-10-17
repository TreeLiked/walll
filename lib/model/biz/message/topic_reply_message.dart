import 'package:json_annotation/json_annotation.dart';
import 'package:wall/model/biz/account/account.dart';
import 'package:wall/model/biz/message/asbtract_message.dart';

part 'topic_reply_message.g.dart';

@JsonSerializable()
class TopicReplyMessage extends AbstractMessage {

  late int topicId;
  late int mainReplyId;

  Account? replier;

  String? topicBody;
  String? replyContent;

  @override
  Map<String, dynamic> toJson() => _$TopicReplyMessageToJson(this);

  factory TopicReplyMessage.fromJson(Map<String, dynamic> json) => _$TopicReplyMessageFromJson(json);

  TopicReplyMessage();
}

