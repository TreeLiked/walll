import 'package:flutter/material.dart';
import 'package:wall/application.dart';
import 'package:wall/config/routes/routes.dart';
import 'package:wall/constant/asset_path_constant.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/constant/gap_constant.dart';
import 'package:wall/model/biz/account/account.dart';
import 'package:wall/model/biz/common/gender.dart';
import 'package:wall/model/biz/common/media.dart';
import 'package:wall/model/biz/tweet/tweet.dart';
import 'package:wall/model/biz/tweet/tweet_account.dart';
import 'package:wall/util/coll_util.dart';
import 'package:wall/util/fluro_convert_utils.dart';
import 'package:wall/util/navigator_util.dart';
import 'package:wall/util/str_util.dart';
import 'package:wall/util/theme_util.dart';
import 'package:wall/util/time_util.dart';
import 'package:wall/widget/common/account_avatar.dart';
import 'package:wall/widget/tweet/tweet_body_wrapper.dart';
import 'package:fluro/fluro.dart';
import 'package:wall/widget/tweet/tweet_index_item_header.dart';
import 'package:wall/widget/tweet/tweet_media_wrapper.dart';
import 'package:wall/widget/tweet/tweet_praise_wrapper.dart';

class TweetSelfItem extends StatelessWidget {
  final BaseTweet tweet;

  late BuildContext context;
  late bool isDark;

  late int indexInList;

  TweetSelfItem(
    this.tweet, {
    this.indexInList = -1,
  }) {}

  @override
  Widget build(BuildContext context) {
    this.context = context;
    isDark = ThemeUtil.isDark(context);
    return cardContainer2(context);
  }

  Widget cardContainer2(BuildContext context) {
    Widget wd = Container(
        padding: EdgeInsets.only(bottom: 0.0, top: indexInList == 0 ? 12.0 : 10.0, left: 10.0, right: 15.0),
        // color: isDark ? Colours.dark_bg_color : Colors.white,
        child: GestureDetector(
          onTap: () => _forwardDetail(context),
          behavior: HitTestBehavior.translucent,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                flex: 5,
                fit: FlexFit.loose,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildHeader(),
//                    TweetTypeWrapper(tweet.type),

                    // Gaps.vGap2,
                    TweetBodyWrapper(tweet.body, maxLine: 3, fontSize: 15, height: 1.6),
                    // TweetMediaWrapper(tweet.id!, medias: tweet.medias, tweet: tweet),
                    _buildMediaText(),
                    // displayLink ? TweetLinkWrapper(tweet) : Gaps.empty,
                    Gaps.vGap8,

                    // TweetPraiseWrapper(tweet, prefixIcon: true),
                    // TweetCampusWrapper(
                    //   tweet.id,
                    //   tweet.account.institute,
                    //   tweet.account.cla,
                    //   tweet.type,
                    //   tweet.anonymous,
                    //   displayType: displayType,
                    // ),
                    // displayExtra
                    //     ? TweetCardExtraWrapper(
                    //         displayPraise: displayPraise,
                    //         displayComment: displayComment,
                    //         tweet: tweet,
                    //         canPraise: canPraise,
                    //         onClickComment: onClickComment)
                    //     : Gaps.empty,
//                    displayComment && tweet.enableReply
//                        ? TweetCommentWrapper(
//                      tweet,
//                      displayReplyContainerCallback: displayReplyContainerCallback,
//                    )
//                        : Gaps.empty,
//                    displayComment ? Gaps.vGap25 : Gaps.vGap10,
                    _buildViewText(),
                    Gaps.line,
                    Gaps.vGap5
                  ],
                ),
              )
            ],
          ),
        ));
    return wd;
  }

  _buildHeader() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[Container(margin: const EdgeInsets.only(bottom: 5.0), child: _timeLeftContainer(context))],
    );
  }

  _buildMediaText() {
    if (CollUtil.isListEmpty(tweet.medias)) {
      return Gaps.empty;
    }
    var list = tweet.medias!.where((m) => m.mediaType == Media.typeImage).toList(growable: false);
    if (CollUtil.isListEmpty(list)) {
      return Gaps.empty;
    }
    if (StrUtil.isEmpty(tweet.body)) {
      return TweetMediaWrapper(tweet: tweet);
    }
    String str = "[图片]";
    if (list.length > 1) {
      str = "[图片] ..";
    }
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Text(str, style: const TextStyle(fontSize: 14.0)),
    );
  }

  _buildViewText() {
    return Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child:
            Text('浏览${tweet.views ?? 1}次', style: const TextStyle(fontSize: 14.0, color: Colours.secondaryFontColor)));
  }

  Widget _timeLeftContainer(BuildContext context) {
    var tweetSent = tweet.sentTime;
    if (tweetSent == null) {
      return Container(height: 0);
    }
    List<TextSpan> spans = [];

    if (TimeUtil.sameDayAndYearMonth(tweetSent)) {
      // 当天的内容
      spans.add(
        TextSpan(text: TimeUtil.getShortTime(tweetSent), style: const TextStyle(color: Colors.orange, fontSize: 15.0)),
      );
    } else {
      if (TimeUtil.sameYear(tweetSent)) {
        // 当年的内容
        spans.add(TextSpan(
            text: '${tweetSent.day}日',
            style: TextStyle(fontSize: 15.0, color: Colours.getEmphasizedTextColor(context))));
        spans.add(
          const TextSpan(text: ' | ', style: TextStyle(color: Colors.grey, fontSize: 15.0)),
        );
        spans.add(
          TextSpan(text: '${tweetSent.month}月', style: const TextStyle(color: Colors.grey, fontSize: 15.0)),
        );
      } else {
        // 今年之前的内容
        spans.add(TextSpan(
            text: '${tweetSent.month}月${tweetSent.day}日',
            style: TextStyle(fontSize: 15.0, color: Colours.getEmphasizedTextColor(context))));
        spans.add(
          const TextSpan(text: ' | ', style: TextStyle(color: Colors.grey, fontSize: 15.0)),
        );
        spans.add(TextSpan(
            text: '${tweetSent.year}年', style: const TextStyle(fontSize: 15.0, color: Colors.grey)));
      }
    }
    return RichText(
        text: TextSpan(
      style: TextStyle(color: isDark ? Colors.white54 : Colors.black87),
      children: spans,
    ));
  }

  void _forwardDetail(BuildContext context) {
    // TODO 跳转详情
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) => TweetDetail(
    //             this.tweet,
    //             newLink: !displayLink,
    //             onDelete: onDetailDelete,
    //           )),
    // );
  }

  void goAccountDetail(BuildContext context, Account account, bool up) {
    // TODO 跳转详情
    // if ((up && upClickable) || (!up && downClickable)) {
    //   NavigatorUtils.push(
    //       context,
    //       Routes.accountProfile +
    //           Utils.packConvertArgs(
    //               {'nick': account.nick, 'accId': account.id, 'avatarUrl': account.avatarUrl}));
    // }
  }

  void goAccountDetail2(BuildContext context, TweetAccount account, bool up) {
    NavigatorUtils.push(
        context,
        Routes.accountProfile +
            FluroConvertUtils.packConvertArgs(
                {'nick': account.nick!, 'accId': account.id!, 'avatarUrl': account.avatarUrl!}),
        transitionType: TransitionType.fadeIn);
  }
}
