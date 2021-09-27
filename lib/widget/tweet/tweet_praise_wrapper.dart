import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wall/api/tweet_api.dart';
import 'package:wall/constant/app_constant.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/constant/gap_constant.dart';
import 'package:wall/model/biz/account/account.dart';
import 'package:wall/model/biz/tweet/tweet.dart';
import 'package:wall/provider/account_local_provider.dart';
import 'package:wall/provider/tweet_provider.dart';
import 'package:wall/util/asset_util.dart';
import 'package:wall/util/navigator_util.dart';
import 'package:wall/util/theme_util.dart';

class TweetPraiseWrapper extends StatelessWidget {
  final BaseTweet tweet;
  final bool limit;
  final double fontSize;
  final bool prefixIcon;

  TweetPraiseWrapper(this.tweet,
      {this.limit = false, this.fontSize = 14.0, this.prefixIcon = true});

  @override
  Widget build(BuildContext context) {
    bool hasPraise = tweet.latestPraise != null && tweet.latestPraise!.isNotEmpty;
    if (!hasPraise) {
//      if (!prefixIcon) {
      return Gaps.empty;
//      }
    }
    // 最近点赞的人数

    List<Widget> items = [];

    List<InlineSpan> spans = [];
    if (prefixIcon) {
      spans.add(WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: const Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: const LoadAssetSvg("common/love_bold", width: 17, height: 17, color: Color(0xFFFF82A9)),
          )));
    }

    List<Account>? praiseList = tweet.latestPraise;
    int len = praiseList!.length;

    if (hasPraise) {
      for (int i = 0; i < len && i < AppCst.indexMaxDisplayPraiseSize; i++) {
        Account account = praiseList[i];
        spans.add(TextSpan(
            text: "${account.nick}" + (i != AppCst.indexMaxDisplayPraiseSize - 1 && i != len - 1 ? '、' : ' '),
            style: TextStyle(color: Colours.emphasizeFontColor, fontSize: 14),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // NavigatorUtils.goAccountProfile2(context, account);
              }));
      }
    }
    Widget widgetT = RichText(
      text: TextSpan(children: spans),
      softWrap: true,
    );
    if (hasPraise && len > AppCst.indexMaxDisplayPraiseSize) {
      int diff = len - AppCst.indexMaxDisplayPraiseSize;
      spans.add(TextSpan(
        text: " 等共$len人刚刚赞过",
        style: TextStyle(color: Colours.secondaryFontColor)
      ));
    }
    items.add(widgetT);

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        decoration: BoxDecoration(
          color: ThemeUtil.isDark(context)
                  ? Colours.borderColorFirstDark
                  : Colours.borderColorFirst,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Wrap(
            alignment: WrapAlignment.start, crossAxisAlignment: WrapCrossAlignment.center, children: items));
  }

  void updatePraise(BuildContext context) async {
    // if (tweet.latestPraise == null) {
    //   tweet.latestPraise = [];
    // }
    // final _tweetProvider = Provider.of<TweetProvider>(context, listen: false);
    // final _localAccProvider = Provider.of<AccountLocalProvider>(context, listen: false);
    // _tweetProvider.updatePraise(context, _localAccProvider.account!, tweet.id!, !tweet.loved!);
    // await TweetApi.operateTweet(tweet.id, 'PRAISE', tweet.loved);
    // if (tweet.loved!) {
    //   // Utils.showFavoriteAnimation(context, size: 20);
    //   Future.delayed(Duration(milliseconds: 1600)).then((_) => Navigator.pop(context));
    // }
  }
}
