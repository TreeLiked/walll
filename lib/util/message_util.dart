// import 'dart:async';
// import 'dart:convert';
//
// import 'package:common_utils/common_utils.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:provider/provider.dart';
// import 'package:stomp_dart_client/stomp.dart';
// import 'package:wall/model/biz/common/base_bloc.dart';
//
// class SingleMessageControl extends BaseBloc {
//   static final String _TAG = "SingleMessageControl";
//
//   late StreamController<int> _controller;
//
//   /// 维护一个本地计数器，三种状态，-1初始｜0没有消息｜x(x>0)显示小红点数目
//   int _localCount = 0;
//
//   SingleMessageControl() {
//     this._controller = new StreamController<int>.broadcast();
//   }
//
//   void clear() {
//     _localCount = 0;
//     _controller.sink.add(0);
//   }
//
//   set streamCount(int count) {
//     _controller.sink.add(count);
//   }
//
//   set localCount(int count) {
//     this._localCount = count;
//   }
//
//   get localCount => _localCount;
//
//   get controller => _controller;
//
//   @override
//   void dispose() {
//     _controller?.close();
//   }
// }
//
// class MessageUtil extends BaseBloc {
//   // ws 长连接客户端
//   static StompClient? _stompClient;
//
//   static StompClient get stompClient => _stompClient;
//
//   static set setStompClient(StompClient value) {
//     _stompClient = value;
//   }
//
//   static Future<int> queryMessageCntTotal(BuildContext context) async {
//     int value = await MessageAPI.queryMsgCount(MessageCategory.ALL);
//     Provider.of<MsgProvider>(context ?? Application.context, listen: false).updateTotal(value);
//     return value;
//   }
//
//   static Future<int> queryCircleMsgCntTotal(BuildContext context) async {
//     int i1 = await queryCircleInterMsgCnt(context);
//     int i2 = await queryCircleSysMsgCntTotal(context);
//     return i1 + i2;
//   }
//
//   static Future<int> queryCircleInterMsgCnt(BuildContext context) async {
//     int val = await MessageAPI.queryMsgCount(MessageCategory.CIRCLE_INTERACTION);
//     Provider.of<MsgProvider>(context ?? Application.context, listen: false).updateCirInterCnt(val);
//     return val;
//   }
//
//   static Future<int> queryCircleSysMsgCntTotal(BuildContext context) async {
//     int val = await MessageAPI.queryMsgCount(MessageCategory.CIRCLE_SYS);
//     Provider.of<MsgProvider>(context ?? Application.context, listen: false).updateCirSysCnt(val);
//     return val;
//   }
//
//   static Future<int> queryTweetInterMsgCnt(BuildContext context) async {
//     int val = await MessageAPI.queryMsgCount(MessageCategory.INTERACTION);
//     Provider.of<MsgProvider>(context ?? Application.context, listen: false).updateTweetInterCnt(val);
//     return val;
//   }
//
//   static Future<int> queryTweetNewMsgCnt(BuildContext context) async {
//     int val = await MessageAPI.queryMsgCount(MessageCategory.TWEET_NEW);
//     Provider.of<MsgProvider>(context ?? Application.context, listen: false).updateTweetNewCnt(val);
//     return val;
//   }
//
//   static Future<int> querySysMsgCnt(BuildContext context) async {
//     int val = await MessageAPI.queryMsgCount(MessageCategory.SYSTEM);
//     Provider.of<MsgProvider>(context ?? Application.context, listen: false).updateSysCnt(val);
//     return val;
//   }
//
//   static Future<Map<String, int>> batchQueryMsgCnt(
//       BuildContext context, List<MessageCategory> msgCategory) async {
//     Map<String, int> map =
//         await MessageAPI.batchQueryMsgCount(msgCategory.map((e) => msgCategoryCodeMap[e]).toList());
//     if (CollectionUtil.isMapEmpty(map)) {
//       return {};
//     }
//     map.forEach((msgCode, msgCnt) {
//       MessageCategory c = codeMsgCategoryMap[msgCode];
//       if (c == MessageCategory.INTERACTION) {
//         Provider.of<MsgProvider>(context ?? Application.context, listen: false).updateTweetInterCnt(msgCnt);
//       } else if (c == MessageCategory.SYSTEM) {
//         Provider.of<MsgProvider>(context ?? Application.context, listen: false).updateSysCnt(msgCnt);
//       } else if (c == MessageCategory.CIRCLE_SYS) {
//         Provider.of<MsgProvider>(context ?? Application.context, listen: false).updateCirSysCnt(msgCnt);
//       } else if (c == MessageCategory.CIRCLE_INTERACTION) {
//         Provider.of<MsgProvider>(context ?? Application.context, listen: false).updateCirInterCnt(msgCnt);
//       }
//     });
//     return map;
//   }
//
//   static void close() {
//     stompClient?.deactivate();
//   }
//
//   static void handleInstantMessage(ImDTO instruction, {BuildContext context}) async {
//     if (instruction == null) {
//       return;
//     }
//     if (context == null) {
//       context = Application.context;
//     }
//     int command = instruction.command;
//
//     LogUtil.e("Received Command: ${command.toString()}, Data: ${instruction.data.toString()}",
//         tag: SingleMessageControl._TAG);
//     switch (command) {
//       case ImDTO.COMMAND_TWEET_CREATED: // 有新推文内容，data: BaseTweet
//         queryTweetNewMsgCnt(context);
//         ToastUtil.showToast(context, "有新的内容，刷新试试 ～", gravity: ToastGravity.BOTTOM);
//         break;
//       case ImDTO.COMMAND_TWEET_PRAISED: // 用户推文被点赞了，data: 点赞的账户模型
//         queryCircleInterMsgCnt(context);
//         Account praiseAcc = Account.fromJson(instruction.data);
//         if (praiseAcc != null) {
//           ToastUtil.showToast(context, "${praiseAcc.nick} 刚刚赞了你 ～",
//               gravity: ToastGravity.BOTTOM, length: Toast.LENGTH_LONG);
//         }
//         break;
//       case ImDTO.COMMAND_TWEET_REPLIED: // 用户被评论，data: 评论的内容
//         queryCircleInterMsgCnt(context);
//         TweetReply tr = TweetReply.fromJson(instruction.data);
//         if (tr != null) {
//           String displayReply =
//               StringUtil.isEmpty(tr.body) ? null : (tr.body.length > 6 ? tr.body.substring(0, 6) : tr.body);
//           String displayContent = (tr.anonymous || tr.account == null || StringUtil.isEmpty(tr.account.nick))
//               ? "有位童鞋默默回复了你 ～"
//               : "${tr.account.nick} 刚刚回复了你${displayReply == null ? ' ～ ' : '：$displayReply'}";
//           ToastUtil.showToast(context, '$displayContent', gravity: ToastGravity.BOTTOM);
//         }
//         break;
//       case ImDTO.COMMAND_TWEET_DELETED: // 推文被删除，data: 删除的推文id
//         int detTweetId = instruction.data;
//         Provider.of<TweetProvider>(context, listen: false).delete(detTweetId);
//         break;
//       case ImDTO.COMMAND_PULL_MSG:
//         // 在消息页面用消息总线处理
//         break;
//       default:
//         break;
//     }
//     wsCommandEventBus.fire(instruction);
//   }
//
//   @override
//   void dispose() {}
// }
