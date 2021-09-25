import 'package:common_utils/common_utils.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wall/model/biz/account/account.dart';

part 'tweet_reply.g.dart';

@JsonSerializable()
class TweetReply {
  int? id;

  int? tweetId;

  int? parentId;

  int? type;

  String? body;

  Account? account;
  Account? tarAccount;

  List<TweetReply>? children;

  bool? anonymous;

  int? hot;
  int? praise;
  int? replyCount;

  DateTime? gmtModified;
  DateTime? gmtCreated;
  DateTime? sentTime;

  String? bizCode;

  TweetReply();

  Map<String, dynamic> toJson() => _$TweetReplyToJson(this);

  factory TweetReply.fromJson(Map<String, dynamic> json) =>
      _$TweetReplyFromJson(json);
}
