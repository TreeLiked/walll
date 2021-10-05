import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wall/api/tweet_api.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/constant/gap_constant.dart';
import 'package:wall/model/biz/tweet/tweet.dart';
import 'package:wall/model/biz/tweet/tweet_type.dart';
import 'package:wall/provider/account_local_provider.dart';
import 'package:wall/provider/tweet_provider.dart';
import 'package:wall/util/asset_util.dart';
import 'package:wall/util/custom_number_util.dart';

class TweetInteractWrapper extends StatelessWidget {
  final BaseTweet tweet;
  final bool canPraise;
  final Function? onClickComment;

  const TweetInteractWrapper(this.tweet, {Key? key, this.canPraise = true, this.onClickComment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(color: Colors.grey, fontSize: 16);
    print(tweet.loved.toString() + "----------build----------");
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // OptionItem(null, Text("${tweet.views == 0 ? 1 : calCount(tweet.views)}次浏览", style: style),
          //     prefix: Gaps.empty),
          // Text("浏览${tweet.views + 1}", style:  style.copyWith(fontSize: Dimens.font_sp12)),
          OptionItem(null, Text(tweet.praise == 0 ? '' : calCount(tweet.praise), style: style),
              prefix: LoadAssetSvg(
                tweet.loved! ? "common/praise_full" : "common/praise_empty",
                width: 22,
                height: 22,
                color: tweet.loved! ? TweetTypeUtil.parseType(tweet.type).color : Colors.grey,
              ),
              onTap: () => canPraise ? updatePraise(context) : HitTestBehavior.opaque),

          Gaps.hGap30,
          tweet.enableReply!
              ? OptionItem(null,
                  Text(tweet.enableReply! ? "${tweet.replyCount == 0 ? '' : tweet.replyCount}" : "评论关闭", style: style),
                  prefix: const LoadAssetSvg("common/comment", width: 21, height: 21, color: Colors.grey),
                  onTap: () => onClickComment == null ? HitTestBehavior.opaque : onClickComment!(null, null, null))
              : Text("评论关闭", style: style.copyWith(color: const Color(0xffCDAD00), fontSize: 13.5))
//          OptionItem("tweet/comment",
//              Text(tweet.enableReply ? "${tweet.replyCount == 0 ? '' : tweet.replyCount}" : "评论关闭")),
        ],
      ),
    );
  }

  void updatePraise(BuildContext context) async {
    final _tweetProvider = Provider.of<TweetProvider>(context, listen: false);
    final _localAccProvider = Provider.of<AccountLocalProvider>(context, listen: false);
    _tweetProvider.updatePraise(context, _localAccProvider.account!, tweet.id!, !tweet.loved!);
    await TweetApi.operateTweet(tweet.id!, 'PRAISE', !tweet.loved!);
    if (tweet.loved!) {
      // Util.showFavoriteAnimation(context, size: 20);
      // Future.delayed(Duration(milliseconds: 1600)).then((_) => Navigator.pop(context));
    }
  }

  String calCount(int? count) {
    return CustomNumberUtil.calCount(count!);
  }
}

class OptionItem extends StatelessWidget {
  final String? iconName;
  final Widget text;
  final GestureTapCallback? onTap;
  Widget? prefix;

  OptionItem(this.iconName, this.text, {Key? key, this.prefix, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          iconName != null
              ? LoadAssetSvg(
                  iconName!,
                  width: 20.0,
                  height: 20.0,
                  color: Colors.grey,
                )
              : prefix!,
          Gaps.hGap4,
          text,
        ],
      ),
      onTap: onTap,
    );
  }
}
