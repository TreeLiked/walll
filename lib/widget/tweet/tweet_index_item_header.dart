import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wall/config/routes/routes.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/constant/size_constant.dart';
import 'package:wall/constant/text_constant.dart';
import 'package:wall/model/biz/common/gender.dart';
import 'package:wall/model/biz/tweet/tweet_account.dart';
import 'package:wall/util/fluro_convert_utils.dart';
import 'package:wall/util/navigator_util.dart';
import 'package:wall/util/str_util.dart';
import 'package:wall/widget/common/account_avatar.dart';

class TweetIndexItemHeader extends StatelessWidget {
  final TweetAccount account;
  final bool anonymous;
  final bool canClick;
  final DateTime tweetSent;
  final bool official;
  final bool myNickClickable;

  const TweetIndexItemHeader(this.account, this.anonymous, this.tweetSent,
      {this.canClick = true, this.official = false, this.myNickClickable = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(child: _profileContainer(context), margin: const EdgeInsets.only(right: 10.0)),
        Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    Expanded(child: _nickContainer(context)),
                    // TODO 标签
                    // official ? SimpleTag("官方") : Gaps.empty,
                    Expanded(
                        child: Container(alignment: Alignment.centerRight, child: _timeContainer(context)))
                  ],
                ),
                _signatureContainer(context),
              ],

              // Container(child: _timeContainer(context))
            ))
      ],
    );
  }

  void goAccountDetail(BuildContext context, TweetAccount account, bool up) {
    if (canClick) {
      NavigatorUtils.push(
          context,
          Routes.accountProfile +
              FluroConvertUtils.packConvertArgs(
                  {'nick': account.nick!, 'accId': account.id!, 'avatarUrl': account.avatarUrl!}));
    }
  }

  Widget _nickContainer(BuildContext context) {
    if (anonymous) {
      account.nick = TextCst.anonymousNick;
    }
    return anonymous
        ? Container(
            child: Text(
            TextCst.anonymousNick + (official ? "官方" : ""),
            style: const TextStyle(color: Colours.emphasizeFontColor, fontSize: 15.0)
          ))
        : GestureDetector(
            onTap: () => anonymous || !myNickClickable ? null : goAccountDetail(context, account, true),
            child: Container(
              child: Text(
                account.nick!,
                softWrap: false,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colours.textLinkColor, fontSize: SizeCst.normalFontSize, fontWeight: FontWeight.bold)
              ),
            ));
  }

  Widget _timeContainer(BuildContext context) {
    if (tweetSent == null) {
      return Container(height: 0);
    }
    return Text("时间");
    // return Text(
    //   TimeUtil.getShortTime(tweetSent) ?? "未知",
    //   maxLines: 2,
    //   softWrap: true,
    //   style: MyDefaultTextStyle.getTweetTimeStyle(context),
    // );
  }

  Widget _signatureContainer(BuildContext context) {
    String sig;
    if (anonymous || account == null || StrUtil.isEmpty(account.signature)) {
      sig = "这个用户很懒, 什么也没有留下";
    } else {
      sig = account.signature!;
    }
    return Text(sig, overflow: TextOverflow.ellipsis, maxLines: 1, softWrap: false);
  }

  Widget _profileContainer(BuildContext context) {
    Gender gender = anonymous ? Gender.unknown : Gender.parseGender(account.gender!);
    return AccountAvatar(
        anonymous: anonymous,
        onTap: () => anonymous || !myNickClickable ? null : goAccountDetail2(context, account, true),
        avatarUrl: account.avatarUrl!,
        gender: gender);
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

  // void goAccountDetail(BuildContext context, Account account, bool up) {
  //   // TODO 跳转详情
  //   // if ((up && upClickable) || (!up && downClickable)) {
  //   //   NavigatorUtils.push(
  //   //       context,
  //   //       Routes.accountProfile +
  //   //           Utils.packConvertArgs(
  //   //               {'nick': account.nick, 'accId': account.id, 'avatarUrl': account.avatarUrl}));
  //   // }
  // }

  void goAccountDetail2(BuildContext context, TweetAccount account, bool up) {
    NavigatorUtils.push(
        context,
        Routes.accountProfile +
            FluroConvertUtils.packConvertArgs(
                {'nick': account.nick!, 'accId': account.id!, 'avatarUrl': account.avatarUrl!}),
        transitionType: TransitionType.fadeIn);
  }
}
