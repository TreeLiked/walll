import 'dart:async';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:wall/api/message_api.dart';
import 'package:wall/application.dart';
import 'package:wall/model/biz/account/account.dart';
import 'package:wall/model/biz/common/base_bloc.dart';
import 'package:wall/model/biz/message/im_dto.dart';
import 'package:wall/model/biz/tweet/tweet_reply.dart';
import 'package:wall/provider/msg_provider.dart';
import 'package:wall/provider/tweet_provider.dart';
import 'package:wall/util/coll_util.dart';
import 'package:wall/util/str_util.dart';
import 'package:wall/util/toast_util.dart';

class MessageUtil extends BaseBloc {
  static const String _tag = "MessageUtil";

  // ws 长连接客户端
  static StompClient? _stompClient;

  static StompClient? get stompClient => _stompClient;

  static set setStompClient(StompClient value) {
    _stompClient = value;
  }

  static Future<int> queryMessageCntTotal(BuildContext? context) async {
    int value = await MessageApi.queryMsgCount(MessageCategory.all);
    Provider.of<MsgProvider>(context ?? Application.context!, listen: false).updateTotal(value);
    return value;
  }

  static Future<int> queryTweetInterMsgCnt(BuildContext? context) async {
    int val = await MessageApi.queryMsgCount(MessageCategory.interaction);
    Provider.of<MsgProvider>(context ?? Application.context!, listen: false).updateTweetInterCnt(val);
    return val;
  }

  static Future<int> queryTweetNewMsgCnt(BuildContext? context) async {
    int val = await MessageApi.queryMsgCount(MessageCategory.tweetNew);
    Provider.of<MsgProvider>(context ?? Application.context!, listen: false).updateTweetNewCnt(val);
    return val;
  }

  static Future<int> querySysMsgCnt(BuildContext? context) async {
    int val = await MessageApi.queryMsgCount(MessageCategory.system);
    Provider.of<MsgProvider>(context ?? Application.context!, listen: false).updateSysCnt(val);
    return val;
  }

  static Future<Map<String, int>> batchQueryMsgCnt(BuildContext? context, List<MessageCategory> msgCategory) async {
    Map<String, int> map = await MessageApi.batchQueryMsgCount(msgCategory.map((e) => msgCategoryCodeMap[e]!).toList());
    if (CollUtil.isMapEmpty(map)) {
      return {};
    }
    map.forEach((msgCode, msgCnt) {
      MessageCategory c = codeMsgCategoryMap[msgCode]!;
      if (c == MessageCategory.interaction) {
        Provider.of<MsgProvider>(context ?? Application.context!, listen: false).updateTweetInterCnt(msgCnt);
      } else if (c == MessageCategory.system) {
        Provider.of<MsgProvider>(context ?? Application.context!, listen: false).updateSysCnt(msgCnt);
      } else if (c == MessageCategory.circleSys) {
        Provider.of<MsgProvider>(context ?? Application.context!, listen: false).updateCirSysCnt(msgCnt);
      } else if (c == MessageCategory.circleInteraction) {
        Provider.of<MsgProvider>(context ?? Application.context!, listen: false).updateCirInterCnt(msgCnt);
      }
    });
    return map;
  }

  static void close() {
    stompClient?.deactivate();
  }

  static void handleInstantMessage(ImDTO? instruction, {BuildContext? context}) async {
    if (instruction == null) {
      return;
    }
    context ??= Application.context!;

    int command = instruction.command!;

    LogUtil.e("Received Command: ${command.toString()}, Data: ${instruction.data.toString()}", tag: _tag);
    switch (command) {
      case ImDTO.commandTweetCreated: // 有新推文内容，data: BaseTweet
        queryTweetNewMsgCnt(context);
        ToastUtil.showToast(context, "有新的内容，刷新试试 ～", gravity: ToastGravity.BOTTOM);
        break;
      case ImDTO.commonTweetPraised: // 用户推文被点赞了，data: 点赞的账户模型
        Account praiseAcc = Account.fromJson(instruction.data);
        ToastUtil.showToast(context, "${praiseAcc.nick} 刚刚赞了你 ～",
            gravity: ToastGravity.BOTTOM, length: Toast.LENGTH_LONG);
        break;
      case ImDTO.commonTweetReplied: // 用户被评论，data: 评论的内容
        TweetReply tr = TweetReply.fromJson(instruction.data);
        String? displayReply =
            StrUtil.isEmpty(tr.body) ? null : (tr.body!.length > 6 ? tr.body!.substring(0, 6) : tr.body);
        String displayContent = (tr.anonymous! || tr.account == null || StrUtil.isEmpty(tr.account!.nick))
            ? "有位童鞋默默回复了你 ～"
            : "${tr.account!.nick} 刚刚回复了你${displayReply == null ? ' ～ ' : '：$displayReply'}";
        ToastUtil.showToast(context, displayContent, gravity: ToastGravity.BOTTOM);
        break;
      case ImDTO.commondTweetDeleted: // 推文被删除，data: 删除的推文id
        int detTweetId = instruction.data;
        Provider.of<TweetProvider>(context, listen: false).delete(detTweetId);
        break;
      case ImDTO.commandPullMessage:
        // 在消息页面用消息总线处理
        break;
      default:
        break;
    }
    wsCommandEventBus.fire(instruction);
  }

  @override
  void dispose() {}
}
