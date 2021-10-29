import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:wall/config/routes/routes.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/constant/gap_constant.dart';
import 'package:wall/constant/text_constant.dart';
import 'package:wall/model/biz/common/gender.dart';
import 'package:wall/model/biz/tweet/tweet.dart';
import 'package:wall/model/biz/tweet/tweet_account.dart';
import 'package:wall/model/biz/tweet/tweet_type.dart';
import 'package:wall/util/asset_util.dart';
import 'package:wall/util/fluro_convert_utils.dart';
import 'package:wall/util/navigator_util.dart';
import 'package:wall/util/str_util.dart';
import 'package:wall/util/theme_util.dart';
import 'package:wall/util/time_util.dart';
import 'package:wall/widget/common/account_avatar.dart';
import 'package:wall/widget/common/real_rich_text.dart';
import 'package:wall/widget/common/square_tag.dart';

class TweetIndexItemHeader extends StatelessWidget {
  final BaseTweet tweet;
  late TweetAccount account;
  late bool anonymous;
  late DateTime tweetSent;

  final bool canClick;
  final bool official;
  final bool myNickClickable;
  final bool displayCampus;
  final bool displayType;

  TweetIndexItemHeader(this.tweet,
      {Key? key,
      this.canClick = true,
      this.official = false,
      this.myNickClickable = true,
      this.displayCampus = true,
      this.displayType = true})
      : super(key: key) {
    account = tweet.account!;
    anonymous = tweet.anonymous!;
    tweetSent = tweet.sentTime!;
  }

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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: _nickContainer(context)),
                displayType ? _typeContainer(context) : Gaps.empty
                // TODO
                // official ? SimpleTag("官方") : Gaps.empty,
                // Expanded(child: Container(alignment: Alignment.centerRight, child: _timeContainer(context)))
              ],
            ),
            _typeTimeWrapper(context)
          ],
        ))
      ],
    );
  }


  Widget _nickContainer(BuildContext context) {
    if (anonymous) {
      account.nick = TextCst.anonymousNick;
    }
    return RealRichText([
      TextSpan(
          text: account.nick!,
          style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold, color: Colours.getEmphasizedTextColor(context)),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              if (anonymous || !myNickClickable) {
                return;
              }
              NavigatorUtils.goAccountProfileByTweetAcc(context, account);
            }),
    ]);
  }

  Widget _typeContainer(BuildContext context) {
    var type = TweetTypeUtil.parseType(tweet.type);
    return SquareTag(
        horizontalPadding: 6.0,
        verticalPadding: 2.0,
        roundRadius: 5.5,
        prefixIcon: LoadAssetSvg("common/topic", width: 13, height: 13, color: type.color),
        child: Text(type.zhTag,
            style: TextStyle(
                fontSize: 13,
                color: ThemeUtil.isDark(context) ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold)));
  }

  Widget _typeTimeWrapper(BuildContext context) {
    return Text(TimeUtil.getShortTime(tweetSent),
        style: const TextStyle(fontSize: 14, color: Colours.secondaryFontColor));
  }

  Widget _signatureContainer(BuildContext context) {
    String sig;
    if (anonymous || StrUtil.isEmpty(account.signature)) {
      sig = "这个用户很懒, 什么也没有留下";
    } else {
      sig = account.signature!;
    }
    return Text(sig,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        softWrap: false,
        style: const TextStyle(color: Colours.secondaryFontColor, fontSize: 13.5));
  }

  Widget _profileContainer(BuildContext context) {
    Gender gender = anonymous ? Gender.unknown : Gender.parseGender(account.gender!);
    return AccountAvatar(
        anonymous: anonymous,
        onTap: () => anonymous || !myNickClickable ? null : NavigatorUtils.goAccountProfileByTweetAcc(context, account),
        avatarUrl: account.avatarUrl!,
        size: 45,
        gender: gender);
  }
}
