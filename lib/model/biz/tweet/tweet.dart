import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wall/model/biz/account/account.dart';
import 'package:wall/model/biz/common/media.dart';
import 'package:wall/model/biz/tweet/tweet_account.dart';
import 'package:wall/model/biz/tweet/tweet_reply.dart';

part 'tweet.g.dart';

@JsonSerializable()
class BaseTweet {
  int? id;
  int? orgId;
  String? body;
  String? type;
  bool? anonymous;

  TweetAccount? account;

  bool? enableReply;

  // Map<TweetReply, List<TweetReply>> replies;

  List<Media>? medias;

//  List<Media> medias;

  int? hot;
  int? praise;
  int? views;
  int? replyCount;
  bool? upTrend;

  @JsonKey(ignore: true, required: false, nullable: true, includeIfNull: false)
  Widget? linkWrapper;
  // @JsonKey(ignore: true, required: false, nullable: true, includeIfNull: false)
  // WebLinkModel wlm;
  @JsonKey(ignore: true, required: false, nullable: true, includeIfNull: false)
  Widget? mediaWrapper;

  /*
   * 直接回复
   */
  List<TweetReply>? dirReplies;

  /*
   * 最近指定时间点赞的账户 
   */
  List<Account>? latestPraise;

  DateTime? gmtModified;
  DateTime? gmtCreated;
  DateTime? sentTime;

  // 是否点赞
  bool? loved;

  BaseTweet();

  Map<String, dynamic> toJson() => _$BaseTweetToJson(this);

  factory BaseTweet.fromJson(Map<String, dynamic> json) => _$BaseTweetFromJson(json);
}
