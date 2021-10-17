import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wall/model/biz/account/account.dart';
import 'package:wall/model/biz/message/circle_system_message.dart';
import 'package:wall/model/biz/message/plain_system_message.dart';
import 'package:wall/model/biz/message/popular_message.dart';
import 'package:wall/model/biz/message/topic_reply_message.dart';
import 'package:wall/model/biz/message/tweet_praise_message.dart';
import 'package:wall/model/biz/message/tweet_reply_message.dart';

part 'asbtract_message.g.dart';

@JsonSerializable()
class AbstractMessage {
  Account? receiver;
  ReadStatus? readStatus;
  late MessageType messageType;
  late int id;

  late DateTime sentTime;
  late DateTime? gmtCreated;
  late DateTime? gmtModified;

  // 是否消息被删除了
  bool? delete;

  Map<String, dynamic> toJson() => _$AbstractMessageToJson(this);

  factory AbstractMessage.fromJson(Map<String, dynamic> json) => _$AbstractMessageFromJson(json);

  AbstractMessage();
}

enum ReadStatus { read, unRead, ignored }

enum MessageType {
  /// 推文点赞
  TWEET_PRAISE,

  /// 推文回复
  TWEET_REPLY,

  /// 话题回复
  TOPIC_REPLY,

  /// 上热门
  POPULAR,

  /// 普通系统消息
  PLAIN_SYSTEM,

  /// 举报消息
  REPORT,

  /// 用户申请加入圈子
  CIRCLE_APPLY,

  /// 用户申请加入圈子结果的消息
  CIRCLE_APPLY_RES,

  /// 圈子简单通知，例如申请加入圈子结果，用户退出圈子等
  CIRCLE_SIMPLE_SYS
}
