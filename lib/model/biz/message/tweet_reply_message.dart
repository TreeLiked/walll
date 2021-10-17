import 'package:json_annotation/json_annotation.dart';
import 'package:wall/model/biz/account/account.dart';
import 'package:wall/model/biz/message/asbtract_message.dart';

part 'tweet_reply_message.g.dart';

@JsonSerializable()
class TweetReplyMessage extends AbstractMessage {
  late int tweetId;
  late int mainReplyId;

  String? tweetBody;
  String? coverUrl;

  String? replyContent;
  Account? replier;

  // 回复是否匿名
  bool? anonymous;

  @override
  Map<String, dynamic> toJson() => _$TweetReplyMessageToJson(this);

  factory TweetReplyMessage.fromJson(Map<String, dynamic> json) => _$TweetReplyMessageFromJson(json);

  TweetReplyMessage();
}
