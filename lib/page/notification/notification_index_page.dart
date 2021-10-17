// ignore_for_file: unnecessary_this

import 'dart:async';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wall/api/message_api.dart';
import 'package:wall/config/routes/noti_router.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/constant/gap_constant.dart';
import 'package:wall/model/biz/message/asbtract_message.dart';
import 'package:wall/model/biz/message/im_dto.dart';
import 'package:wall/model/biz/message/plain_system_message.dart';
import 'package:wall/model/biz/message/topic_reply_message.dart';
import 'package:wall/model/biz/message/tweet_praise_message.dart';
import 'package:wall/model/biz/message/tweet_reply_message.dart';
import 'package:wall/provider/msg_provider.dart';
import 'package:wall/util/message_util.dart';
import 'package:wall/util/navigator_util.dart';
import 'package:wall/util/perm_util.dart';
import 'package:wall/util/theme_util.dart';
import 'package:wall/util/toast_util.dart';
import 'package:wall/util/umeng_util.dart';
import 'package:wall/widget/common/custom_app_bar.dart';
import 'package:wall/widget/notification/noti_index_item.dart';

class NotificationIndexPage extends StatefulWidget {
  const NotificationIndexPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NotificationIndexPageState();
  }
}

class _NotificationIndexPageState extends State<NotificationIndexPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin<NotificationIndexPage> {
  static const String _tag = "_NotificationIndexPageState";

  final String noMessage = "暂无新通知";

  bool isDark = false;

  final RefreshController _refreshController = new RefreshController(initialRefresh: true);

  dynamic _latestInteractionMsg;
  dynamic _latestSystemMsg;
  dynamic _latestCircleMsg;

  // 控制消息总线
  late StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    // 校验通知权限
    UMengUtil.userGoPage(UMengUtil.pageNotifyIndex);

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      checkNotification();
    });
    _subscription = wsCommandEventBus.on<ImDTO>().listen((ImDTO data) {
      int c = data.command!;
      if (c == ImDTO.commonTweetPraised || c == ImDTO.commonTweetReplied || c == ImDTO.commandPullMessage) {
        _fetchLatestMessage();
      }
    });
    _subscription.resume();
  }

  void checkNotification() async {
    Future.delayed(const Duration(seconds: 3)).then(
        (value) => PermissionUtil.checkAndRequestNotification(context, showTipIfDetermined: true, probability: 39));
  }

  _fetchLatestMessageAndCount() async {
    _fetchLatestMessage();
    _refreshController.refreshCompleted();
  }

  _fetchLatestMessage() async {
    MessageUtil.batchQueryMsgCnt(context, [MessageCategory.interaction, MessageCategory.system, MessageCategory.circle])
        .then((Map<String, int> cateCodeMsgCnt) {
      List<String> codes = [];
      cateCodeMsgCnt.forEach((code, msgCnt) {
        if (msgCnt > 0) {
          codes.add(code);
        }
      });
      MessageApi.batchFetchLatestMessage(codes).then((Map<String, AbstractMessage> cateCodeMsg) {
        cateCodeMsg.forEach((code, msg) {
          MessageCategory c = codeMsgCategoryMap[code]!;
          if (c == MessageCategory.interaction) {
            _fetchLatestInteractionMsg(msg: msg);
          } else if (c == MessageCategory.system) {
            _fetchLatestSystemMsg(msg: msg);
          } else if (c == MessageCategory.circle) {
            // 圈子
          }
        });
      });
    });
  }

  // 查询的具体的系统消息内容
  Future<void> _fetchLatestSystemMsg({AbstractMessage? msg}) async {
    if (msg != null) {
      setState(() {
        this._latestSystemMsg = msg;
      });
      return;
    }
    MessageApi.fetchLatestMessage(MessageCategory.system).then((msg) {
      setState(() {
        this._latestSystemMsg = msg;
      });
    });
  }

  // 查询的具体的互动消息内容
  Future<void> _fetchLatestInteractionMsg({AbstractMessage? msg}) async {
    if (msg != null) {
      setState(() {
        this._latestInteractionMsg = msg;
      });
      return;
    }
    MessageApi.fetchLatestMessage(MessageCategory.interaction).then((msg) {
      if (msg != null && msg.readStatus == ReadStatus.unRead) {
        setState(() {
          this._latestInteractionMsg = msg;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    LogUtil.e('notification build', tag: _tag);
//    print('notification' + (ModalRoute.of(context).isCurrent ? "当前页面" : "不是当前页面"));

    isDark = ThemeUtil.isDark(context);

    return Consumer<MsgProvider>(builder: (_, provider, __) {
      return Scaffold(
        backgroundColor: Colours.getTweetScaffoldColor(context),
        // appBar: const CustomAppBar(centerTitle: '我的消息', isBack: false),
        appBar: AppBar(
            backgroundColor: Colours.getTweetScaffoldColor(context),
            automaticallyImplyLeading: false,
            title: Text('我的消息',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colours.getBlackOrWhite(context))),
            centerTitle: true),
        body: SafeArea(
          top: false,
          child: SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              enablePullUp: false,
              // header: MaterialClassicHeader(
              //   color: Colors.amber,
              //   backgroundColor: isDark ? ColorConstant.MAIN_BG_DARK : ColorConstant.MAIN_BG,
              // ),
              header: WaterDropHeader(
                waterDropColor: isDark ? Color(0xff6E7B8B) : Color(0xffE6E6FA),
                complete: const Text('刷新完成'),
              ),
//            header: Utils.getDefaultRefreshHeader(),
              onRefresh: _fetchLatestMessageAndCount,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    // NotiIndexItem(
                    //   iconPath: iconSubPath,
                    //   iconPadding: 8.5,
                    //   iconColor: Color(0xff87CEFF),
                    //   title: "私信",
                    //   body: "暂无私信消息",
                    //   color: Color(0xffF0F8FF),
                    //   onTap: () => ToastUtil.showToast(context, "当前没有私信消息"),
                    // ),
                    NotiIndexItem(
                      iconPath: "noti/school",
                      title: "校园",
                      official: false,
                      body: "暂无新通知",
                      pointType: true,
                      onTap: () {
                        ToastUtil.showToast(context, "当前没有校园官方消息");
                        // NavigatorUtils.push(context, NotificationRouter.campusMain);
                      },
                      color: const Color(0xffFCF1F4),
                      iconColor: const Color(0xffFF69B4),
                      iconPadding: 8.5,
                    ),
                    // NotiIndexItem(
                    //   iconPath: circleNotiPath,
                    //   title: "圈子",
                    //   official: true,
                    //   body: _getCircleMsgBody(),
                    //   iconPadding: 8.5,
                    //   msgCnt: provider.circleTotal,
                    //   onTap: () {
                    //     ToastUtil.showToast(context, '圈子即将开放，敬请期待');
                    //     // NavigatorUtils.push(context, NotificationRouter.circleMain);
                    //   },
                    //   color: Colors.lightGreen[50]!,
                    //   iconColor: Colors.lightGreen,
                    // ),
                    NotiIndexItem(
                        iconPath: "noti/inter",
                        color: const Color(0xffEBFAF4),
                        iconColor: const Color(0xff00CED1),
                        iconPadding: 8,
                        title: "互动",
                        msgCnt: provider.tweetInterCnt,
                        body: _getInteractionBody(),
                        time: _latestInteractionMsg?.sentTime,
                        onTap: () {
                          _latestInteractionMsg = null;
                          provider.updateTweetInterCnt(0);
                          NavigatorUtils.push(context, NotificationRouter.interactiveMain);
                        }),
                    Gaps.vGap5,
                    NotiIndexItem(
                      iconPath: "noti/official",
                      color: const Color(0xffFEF7E7),
                      iconColor: const Color(0xffDAA520),
                      title: "Wall",
                      tagName: "官方",
                      msgCnt: provider.sysCnt,
                      body: _latestSystemMsg == null ? noMessage : _getSystemMsgBody(),
                      time: _latestSystemMsg?.sentTime,
                      pointType: false,
                      onTap: () {
                        provider.updateSysCnt(0);
                        NavigatorUtils.push(context, NotificationRouter.systemMain);
                      },
                    ),
                  ],
                ),
              )),
        ),
      );
    });
  }

  String _getInteractionBody() {
    if (_latestInteractionMsg == null) {
      return noMessage;
    } else {
      if (_latestInteractionMsg.messageType == MessageType.TWEET_PRAISE) {
        TweetPraiseMessage message = _latestInteractionMsg as TweetPraiseMessage;
        return "${message.praiser!.nick!} 赞了你";
      } else if (_latestInteractionMsg.messageType == MessageType.TWEET_REPLY) {
        TweetReplyMessage message = _latestInteractionMsg as TweetReplyMessage;
        String content = message.delete != null && message.delete! ? "该评论已删除" : message.replyContent!;
        return "${message.anonymous! ? '[匿名用户]' : message.replier!.nick} 回复了你: $content";
      } else if (_latestInteractionMsg.messageType == MessageType.TOPIC_REPLY) {
        TopicReplyMessage message = _latestInteractionMsg as TopicReplyMessage;
        String content = message.delete! ? "该评论已删除" : message.replyContent!;
        return "${message.replier!.nick!} 评论了你: $content}";
      } else {
        return noMessage;
      }
    }
  }

  String _getSystemMsgBody() {
    if (_latestSystemMsg == null) {
      return noMessage;
    } else {
      if (_latestSystemMsg.messageType == MessageType.PLAIN_SYSTEM) {
        PlainSystemMessage message = _latestInteractionMsg as PlainSystemMessage;
        return "${message.title ?? message.content}";
      } else if (_latestSystemMsg.messageType == MessageType.POPULAR) {
//        PopularMessage message = _latestSystemMsg as PopularMessage;
        return "恭喜，您发布的内容登上了热门排行榜";
      } else {
        return noMessage;
      }
    }
  }

  @override
  bool get wantKeepAlive => true;
}
