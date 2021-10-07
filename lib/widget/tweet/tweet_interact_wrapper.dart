import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wall/api/tweet_api.dart';
import 'package:wall/constant/gap_constant.dart';
import 'package:wall/model/biz/tweet/tweet.dart';
import 'package:wall/model/biz/tweet/tweet_type.dart';
import 'package:wall/model/response/result.dart';
import 'package:wall/provider/account_local_provider.dart';
import 'package:wall/provider/tweet_provider.dart';
import 'package:wall/util/animation_util.dart';
import 'package:wall/util/asset_util.dart';
import 'package:wall/util/common_util.dart';
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
    const style = TextStyle(color: Colors.grey, fontSize: 16);
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // OptionItem(null, Text("${tweet.views == 0 ? 1 : calCount(tweet.views)}次浏览", style: style),
          //     prefix: Gaps.empty),
          // Text("浏览${tweet.views + 1}", style:  style.copyWith(fontSize: Dimens.font_sp12)),
          OptionItem(null, Text(tweet.praise == 0 ? '' : calCount(tweet.praise), style: style),
              prefix: LoadAssetSvg(
                tweet.loved! ? "common/praise_full" : "common/praise_empty",
                // key: _praiseIconKey,
                width: 22,
                height: 22,
                color: (tweet.loved!) ? TweetTypeUtil.parseType(tweet.type).color : Colors.grey,
              ),
              onTap: (offset) => canPraise ? updatePraise(context, offset) : HitTestBehavior.opaque),
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
    // if (tweet.loved!) {
    AnimationUtil.showFavoriteAnimation(context, offset,size: 300);
    Future.delayed(const Duration(milliseconds: 1500)).then((_) => Navigator.pop(context));
    // }
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
        ));
  }
}
