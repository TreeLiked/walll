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
import 'package:wall/util/time_util.dart';
import 'package:wall/widget/common/account_avatar.dart';
import 'package:wall/widget/common/real_rich_text.dart';

class TweetDetailItemHeader extends StatelessWidget {
  final BaseTweet tweet;

  late TweetAccount account;
  late bool anonymous;
  late DateTime sentTime;
  final bool official;

  TweetDetailItemHeader(this.tweet, {Key? key, this.official = false}) : super(key: key) {
    account = tweet.account!;
    anonymous = tweet.anonymous!;
    sentTime = tweet.sentTime!;
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
              children: [
                Expanded(child: _nickContainer(context)),
                // TODO 标签
                // official ? SimpleTag("官方") : Gaps.empty,
                // Expanded(child: Container(alignment: Alignment.centerRight, child: _timeContainer(context)))
              ],
            ),
            Gaps.vGap3,
            // _signatureContainer(context),
            Row(children: [_typeContainer(context), Gaps.hGap5, _timeContainer(context)])
          ],
        ))
      ],
    );
  }

  Widget _nickContainer(BuildContext context) {
    if (anonymous) {
      account.nick = TextCst.anonymousNick;
    }
    Gender g = Gender.parseGender(account.gender);
    return Row(
      children: [
        RealRichText([
          TextSpan(
              text: account.nick!,
              style: TextStyle(
                  fontSize: 15.5, fontWeight: FontWeight.w500, color: Colours.getEmphasizedTextColor(context)),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  if (anonymous) {
                    return;
                  }
                  NavigatorUtils.goAccountProfileByTweetAcc(context, account);
                }),
          // TextSpan(
          //   text: ' · ' + TimeUtil.getShortTime(tweetSent),
          //   style: const TextStyle(fontSize: 14, color: Colours.secondaryFontColor),
          // )
        ]),
        Gaps.hGap5,
        anonymous || !g.hasGender
            ? Gaps.empty
            : Container(
                padding: const EdgeInsets.all(3),
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                    color: g == Gender.male ? Colours.maleMainColor : Colours.feMaleMainColor, shape: BoxShape.circle),
                child: LoadAssetSvg(g == Gender.male ? 'crm/male_signal' : 'crm/female_signal',
                    width: 20, height: 20, color: Colors.white),
              ),
      ],
    );
  }

  Widget _timeContainer(BuildContext context) {
    return Text('・' + TimeUtil.getShortTime(sentTime),
        style: const TextStyle(fontSize: 14, color: Colours.secondaryFontColor));
  }

  Widget _profileContainer(BuildContext context) {
    return AccountAvatar(
        displayGender: false,
        anonymous: anonymous,
        onTap: () => anonymous ? null : NavigatorUtils.goAccountProfileByTweetAcc(context, account),
        avatarUrl: account.avatarUrl!,
        size: 45);
  }

  Widget _typeContainer(BuildContext context) {
    TweetTypeEntity en = TweetTypeUtil.parseType(tweet.type);
    String zhTag = en.zhTag;
    return Text('# $zhTag', style: TextStyle(fontSize: 14, color: en.color, fontWeight: FontWeight.w500));
  }
}
