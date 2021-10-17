import 'package:flutter/material.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/constant/gap_constant.dart';
import 'package:wall/model/biz/tweet/tweet.dart';
import 'package:wall/model/biz/tweet/tweet_type.dart';
import 'package:wall/util/asset_util.dart';
import 'package:wall/util/str_util.dart';
import 'package:wall/util/theme_util.dart';
import 'package:wall/widget/common/square_tag.dart';
import 'package:wall/widget/square_lined_tag.dart';

class TweetCampusWrapper extends StatelessWidget {
  final BaseTweet tweet;
  final bool displayCampus;

  const TweetCampusWrapper({Key? key, required this.tweet, this.displayCampus = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!displayCampus) {
      return Gaps.empty;
    }
    var ins = tweet.account!.institute;
    var cla = tweet.account!.cla;
    bool insEmpty = StrUtil.isEmpty(ins);
    bool claEmpty = StrUtil.isEmpty(cla);

    if (insEmpty && claEmpty) {
      return Gaps.empty;
    }
    String t = insEmpty ? cla! : (claEmpty ? ins! : '$ins，$cla');
    // var type = TweetTypeUtil.parseType(tweet.type);
    Color mc = TweetTypeUtil.parseType(tweet.type).color;
    return Container(
        margin: const EdgeInsets.only(top: 10.0),
        child: SquareTag(
          horizontalPadding: 8.0,
          verticalPadding: 5.0,
          roundRadius: 6.0,
          prefixIcon: Icon(Icons.camera, color: Colours.getBlackOrWhite(context), size: 14.0),
          child: Text(t,
              style:
                  TextStyle(color: Colours.getEmphasizedTextColor(context), fontSize: 11, fontWeight: FontWeight.w400)),
        ));
  }
}
