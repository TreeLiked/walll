import 'package:json_annotation/json_annotation.dart';
import 'package:wall/model/biz/account/account.dart';
import 'package:wall/model/biz/message/asbtract_message.dart';

part 'tweet_praise_message.g.dart';

@JsonSerializable()
class TweetPraiseMessage extends AbstractMessage {
  late int tweetId;

  Account? praiser;

  String? tweetBody;

  /// 如果没有文字内容，则给出封面图片
  String? coverUrl;

  @override
  Map<String, dynamic> toJson() => _$TweetPraiseMessageToJson(this);

  factory TweetPraiseMessage.fromJson(Map<String, dynamic> json) => _$TweetPraiseMessageFromJson(json);

  TweetPraiseMessage();
}
