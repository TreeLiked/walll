import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:wall/api/message_api.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/constant/gap_constant.dart';
import 'package:wall/model/biz/message/asbtract_message.dart';
import 'package:wall/model/biz/message/plain_system_message.dart';
import 'package:wall/model/biz/message/popular_message.dart';
import 'package:wall/page/tweet/tweet_detail_page.dart';
import 'package:wall/util/navigator_util.dart';
import 'package:wall/util/theme_util.dart';
import 'package:wall/util/time_util.dart';
import 'package:wall/widget/common/red_point.dart';
class SystemMessageItem extends StatelessWidget {
  final AbstractMessage? message;

  BuildContext? thisContext;
  bool isDark = false;

  SystemMessageItem(this.message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    thisContext = context;
    isDark = ThemeUtil.isDark(context);
    if (message == null) {
      return Gaps.empty;
    }

    MessageType mstT = message!.messageType;
    if (mstT == MessageType.PLAIN_SYSTEM) {
      // 系统消息
      PlainSystemMessage temp = message as PlainSystemMessage;
      return _buildPlainSystemMessage(context, temp);
    } else if (mstT == MessageType.POPULAR) {
      // 上热门消息
      PopularMessage temp = message as PopularMessage;
      return _buildPopularSystemMessage(context, temp);
    } else {
      return Gaps.empty;
    }
  }

  Widget _buildPlainSystemMessage(BuildContext context, PlainSystemMessage msg) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          message!.readStatus = ReadStatus.read;
          if (msg.hasLink! && msg.linkUrl != null) {
            NavigatorUtils.goWebViewPage(context, msg.title!, msg.linkUrl!);
          }
        },
        child: Container(
              margin: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _dateTimeContainer(context, msg.sentTime),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: Text(
                        msg.title ?? "系统通知",
                        style: TextStyle(color: Colours.getEmphasizedTextColor(context), fontWeight: FontWeight.bold),
                      )),
                      msg.hasLink! && msg.linkUrl != null ? Icon(Icons.arrow_back_ios) : Gaps.empty
                    ],
                  ),
                  Gaps.vGap8,
                  Gaps.line,
                  msg.hasCover! && msg.coverUrl != null
                      ? Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(
                            maxHeight: 180
                          ),
                          child: ClipRRect(
                            child: FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: msg.coverUrl!,
                              fit: BoxFit.cover
                            ),
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                          ),
                        )
                      : Gaps.empty,
                  Gaps.vGap8,
                  Text(msg.content ?? '', style: TextStyle(color: Colours.getEmphasizedTextColor(context),fontSize:
                  15)),
                ],
              )),
        );
  }

  _dateTimeContainer(BuildContext context, DateTime? date) {
    return date != null
        ? Container(
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.only(bottom: 10),
            child: Text(TimeUtil.getShortTime(date), style: const TextStyle(fontSize: 13,color: Colors.grey)),
          )
        : Gaps.empty;
  }

  Widget _buildPopularSystemMessage(BuildContext context, PopularMessage msg) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () async {
          message!.readStatus = ReadStatus.read;
          MessageApi.readThisMessage(message!.id);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TweetDetailPage(tweetId: msg.tweetId),
                maintainState: true),
          );
        },
        child:  Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.only(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _dateTimeContainer(context, msg.sentTime),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "恭喜，您的发布上热门 !",
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    msg.readStatus == ReadStatus.unRead
                        ? RedPoint(
                            msg,
                            color: Color(0xff00CED1),
                          )
                        : Gaps.empty,
                    // Images.arrowRight,
                  ],
                ),
                Gaps.vGap8,
                Gaps.line,
                Gaps.vGap8,
                _buildBody(msg.tweetBody, msg.coverUrl),
              ],
            ),
          ),
        );
  }


  _buildBody(String? refBody, String? cover) {
    if (refBody != null && refBody.trim() != "") {
      return Container(
        child: Text('$refBody',
            softWrap: true,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colours.secondaryFontColor, fontSize: 15)),
      );
    } else if (cover != null) {
      return Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxHeight: 180,
          ),
          child: ClipRRect(
            child: CachedNetworkImage(
              imageUrl: cover,
              fit: BoxFit.cover,
            ),
            borderRadius: const BorderRadius.all(const Radius.circular(10)),
          ));
    } else {
      return Gaps.empty;
    }
  }

}
