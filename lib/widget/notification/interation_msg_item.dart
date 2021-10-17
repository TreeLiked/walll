import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:wall/api/message_api.dart';
import 'package:wall/config/routes/routes.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/constant/gap_constant.dart';
import 'package:wall/model/biz/account/account.dart';
import 'package:wall/model/biz/message/asbtract_message.dart';
import 'package:wall/model/biz/message/tweet_praise_message.dart';
import 'package:wall/model/biz/message/tweet_reply_message.dart';
import 'package:wall/page/tweet/tweet_detail_page.dart';
import 'package:wall/util/asset_util.dart';
import 'package:wall/util/navigator_util.dart';
import 'package:wall/util/theme_util.dart';
import 'package:wall/util/time_util.dart';
import 'package:wall/widget/common/account_avatar.dart';
import 'package:wall/widget/common/red_point.dart';

class InteractionMessageItem extends StatelessWidget {
  final AbstractMessage message;

  BuildContext? thisContext;
  bool isDark = false;

  InteractionMessageItem(this.message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    thisContext = context;
    isDark = ThemeUtil.isDark(context);

    Account? account;
    bool accountAnonymous = false;
    // 0 点赞， 1 回复
    int optType;
    // 如果是回复，则replyBody不为空
    String? replyBody;

    // 推文body | 话题标题
    String? body;
    // 推文封面，如果无body，显示封面
    String? cover;

    int refId;

    MessageType mstT = message.messageType;

    bool delete = message.delete != null && message.delete!;
    if (mstT == MessageType.TWEET_PRAISE) {
      // 推文点赞
      TweetPraiseMessage temp = message as TweetPraiseMessage;
      account = temp.praiser;
      optType = 0;
      body = temp.tweetBody;
      cover = temp.coverUrl;
      refId = temp.tweetId;
      accountAnonymous = false;
    } else if (mstT == MessageType.TWEET_REPLY) {
      // 推文回复
      TweetReplyMessage temp = message as TweetReplyMessage;
      account = temp.replier;
      optType = 1;
      replyBody = temp.replyContent;
      body = temp.tweetBody;
      cover = temp.coverUrl;
      refId = temp.tweetId;
      accountAnonymous = temp.anonymous!;
      if (!accountAnonymous) {
        // 是否是匿名推文，作者回复别人

      }
      // } else if (mstT == MessageType.TOPIC_REPLY) {
      //   // 话题回复
      //   TopicReplyMessage temp = message as TopicReplyMessage;
      //   account = temp.replier;
      //   optType = 1;
      //   replyBody = temp.replyContent;
      //   body = temp.topicBody;
      //   refId = temp.topicId;
      //   accountAnonymous = false;
    } else {
      return Gaps.empty;
    }
    if (account == null && !accountAnonymous) {
      return Gaps.empty;
    }

    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          message.readStatus = ReadStatus.read;
          MessageApi.readThisMessage(message.id);
          if (mstT == MessageType.TWEET_PRAISE || mstT == MessageType.TWEET_REPLY) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TweetDetailPage(tweetId: refId)),
            );
          } else if (mstT == MessageType.TOPIC_REPLY) {
            // NavigatorUtils.push(context, SquareRouter.topicDetail + "?topicId=$refId");
          }
        },
//        onLongPress: () {
//          showModalBottomSheet(
//            context: context,
//            builder: (BuildContext context) {
//              return BottomSheetConfirm(
//                title: '确认删除此条消息吗',
//                optChoice: '删除',
//                onTapOpt: () async {
//                  MessageApi.readAllInteractionMessage()
//                },
//              );
//            },
//          );
//        },
        child: Container(
            margin: const EdgeInsets.only(left: 15.0, bottom: 4.0, right: 15.0, top: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                        margin: const EdgeInsets.only(right: 10.0),
                        child: AccountAvatar(
                            cache: true,
                            size: 40.0,
                            avatarUrl: account!.avatarUrl!,
                            anonymous: accountAnonymous,
                            onTap: () => _handleGoAccount(context, account!)))
                  ],
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                              child: GestureDetector(
                            child: _buildNick(context, account, accountAnonymous),
                            onTap: () => _handleGoAccount(context, account!),
                          )),
                          Expanded(
                              child: Container(
                                  child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              RedPoint(message),
                              _buildTime(message.sentTime),
                            ],
                          )))
                        ],
                      ),
                      Gaps.vGap4,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          optType == 0
                              ? const LoadAssetSvg("common/praise_empty", width: 18, height: 18, color: Colors.red)
                              : Gaps.empty,
                          optType == 0
                              ? const Text(' 赞了你', style: TextStyle(fontSize: 13))
                              : Flexible(
                                  child: RichText(
                                      softWrap: true,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(children: [
                                        const TextSpan(
                                            text: ' 回复了你: ', style: TextStyle(color: Colors.blue, fontSize: 14)),
                                        TextSpan(
                                            text: delete ? '该评论已被删除' : '$replyBody',
                                            style: delete
                                                ? const TextStyle(color: Color(0xffaeb4bd), fontSize: 14)
                                                : TextStyle(
                                                    color: Colours.getEmphasizedTextColor(context), fontSize: 14))
                                      ])))
                        ],
                      ),
                      Gaps.vGap5,
                      Wrap(
                        children: <Widget>[
                          _buildBody(body, cover),
                        ],
                      ),
                      Gaps.vGap12,
                      Gaps.line
                    ],
                  ),
                ),
              ],
            )));
  }

  _buildNick(BuildContext context, Account account, bool anonymous) {
    return Container(
      child: Text(anonymous ? '匿名用户' : account.nick!,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 15, color: Colours.getBlackOrWhite(context))),
    );
  }

  _buildTime(DateTime dt) {
    return Container(
        margin: const EdgeInsets.only(left: 5.0),
        child: Text(TimeUtil.getShortTime(dt), style: const TextStyle(color: Colors.grey, fontSize: 13.5)));
  }

  _buildBody(String? refBody, String? cover) {
    if (refBody != null && refBody.trim() != "") {
      return Text(refBody,
          softWrap: true,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colours.secondaryFontColor, fontSize: 14));
    } else if (cover != null) {
      return const Text('[图片]',
          softWrap: true,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colours.secondaryFontColor, fontSize: 14));
      // return ImageContainer(
      //     url: cover, width: Application.screenWidth / 4, maxHeight: Application.screenHeight / 4);
    } else {
      return Gaps.empty;
    }
  }

  void _handleGoAccount(BuildContext context, Account account) {
    if (message.messageType == MessageType.TWEET_REPLY && (message as TweetReplyMessage).anonymous!) {
      return;
    }
    NavigatorUtils.goAccountProfileByAcc(context, account);
  }
}
