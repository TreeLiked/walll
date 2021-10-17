import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wall/api/tweet_api.dart';
import 'package:wall/application.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/constant/gap_constant.dart';
import 'package:wall/model/biz/tweet/tweet.dart';
import 'package:wall/model/biz/tweet/tweet_type.dart';
import 'package:wall/model/response/result.dart';
import 'package:wall/provider/account_local_provider.dart';
import 'package:wall/provider/tweet_provider.dart';
import 'package:wall/util/animation_util.dart';
import 'package:wall/util/asset_util.dart';
import 'package:wall/util/custom_number_util.dart';
import 'package:wall/util/toast_util.dart';

class TweetInteractWrapper extends StatelessWidget {
  final BaseTweet tweet;
  final bool canPraise;
  final Function? onClickComment;

  // late Key _praiseIconKey ;

  TweetInteractWrapper(this.tweet, {Key? key, this.canPraise = true, this.onClickComment}) : super(key: key) {
    // _praiseIconKey = Key();
  }

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(color: Colours.tweetInterColor, fontSize: 13.5, fontWeight: FontWeight.bold);
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      width: Application.screenWidth!,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          OptionItem(null, Text("${tweet.views == 0 ? 1 : calCount(tweet.views)}", style: style),
              prefix: Text("浏览", style: style.copyWith(fontSize: 13))),
          tweet.enableReply!
              ? OptionItem(null, Text("${tweet.replyCount == 0 ? '' : tweet.replyCount}", style: style),
                  prefix: const LoadAssetSvg("common/comment", width: 18, height: 18, color: Colours.tweetInterColor),
                  onTap: () => onClickComment != null && tweet.enableReply!
                      ? onClickComment!(null, null, null)
                      : HitTestBehavior.opaque)
              : OptionItem(null, Text("评论关闭", style: style.copyWith(fontSize: 12.5)),
                  prefix: null, onTap: () => HitTestBehavior.opaque),
          OptionItem(null, Text(tweet.praise == 0 ? '' : calCount(tweet.praise), style: style),
              prefix: LoadAssetSvg(
                "common/praise_empty",
                width: 20,
                height: 20,
                color: (tweet.loved!) ? TweetTypeUtil.parseType(tweet.type).color : Colours.tweetInterColor,
              ),
              onTap: (offset) => canPraise ? updatePraise(context, offset) : HitTestBehavior.opaque),
        ],
      ),
    );
  }

  void updatePraise(BuildContext context, Offset offset) async {
    Result r = await TweetApi.operateTweet(tweet.id!, 'PRAISE', !tweet.loved!);
    if (!r.isSuccess) {
      ToastUtil.showToast(context, '操作过于频繁');
      return;
    }
    final _tweetProvider = Provider.of<TweetProvider>(context, listen: false);
    final _localAccProvider = Provider.of<AccountLocalProvider>(context, listen: false);
    _tweetProvider.updatePraise(context, _localAccProvider.account!, tweet.id!, !tweet.loved!);
    // RenderBox? renderBox = _praiseIconKey.currentContext!.findRenderObject() as RenderBox;
    // var offset = renderBox.localToGlobal(Offset.zero);
    // print(offset);
    if (tweet.loved!) {
      AnimationUtil.showFavoriteAnimation(context, offset, size: 300);
      Future.delayed(const Duration(milliseconds: 1600)).then((_) => Navigator.pop(context));
    }
  }

  String calCount(int? count) {
    return CustomNumberUtil.calCount(count!);
  }
}

class OptionItem extends StatelessWidget {
  final String? iconName;
  final Widget text;
  final Function? onTap;
  final Widget? prefix;

  const OptionItem(this.iconName, this.text, {Key? key, this.prefix, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        // onPanDown: (detail) {
        //   if (onTap == null) {
        //     return;
        //   }
        //   final RenderBox box = context.findRenderObject() as RenderBox; // 获取的对象为当前页面对象，PainterPage
        //   Offset globalPosition = box.localToGlobal(detail.globalPosition);
        //   onTap!(globalPosition);
        // },
        onTap: () {
          if (onTap == null) {
            return;
          }
          final RenderBox box = context.findRenderObject() as RenderBox; // 获取的对象为当前页面对象，PainterPage
          Offset globalPosition = box.localToGlobal(Offset.zero);
          onTap!(globalPosition);
        },
        child: Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
          iconName != null
              ? LoadAssetSvg(
                  iconName!,
                  width: 20.0,
                  height: 20.0,
                  color: Colors.grey,
                )
              : prefix ?? Gaps.empty,
          Gaps.hGap4,
          text
        ]));
  }
}
