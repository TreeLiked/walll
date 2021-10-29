import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wall/api/tweet_api.dart';
import 'package:wall/application.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/constant/gap_constant.dart';
import 'package:wall/model/biz/common/gender.dart';
import 'package:wall/model/biz/tweet/tweet.dart';
import 'package:wall/model/biz/tweet/tweet_reply.dart';
import 'package:wall/model/response/result.dart';
import 'package:wall/provider/tweet_provider.dart';
import 'package:wall/util/bottom_sheet_util.dart';
import 'package:wall/util/coll_util.dart';
import 'package:wall/util/common_util.dart';
import 'package:wall/util/navigator_util.dart';
import 'package:wall/util/time_util.dart';
import 'package:wall/util/toast_util.dart';
import 'package:wall/widget/common/account_avatar.dart';
import 'package:wall/widget/common/real_rich_text.dart';

class TweetDetailCommentTab extends StatefulWidget {
  final BaseTweet? _tweet;

  // 回调点击评论回复事件，参数TweetReply
  final Function? onTapReply;

  const TweetDetailCommentTab(this._tweet, {Key? key, this.onTapReply}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TweetDetailCommentTabState(_tweet);
  }
}

class TweetDetailCommentTabState extends State<TweetDetailCommentTab> {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  List<TweetReply>? _commentList;

  final TextStyle replyNickStyle =
      const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w500, color: Colours.secondaryFontColor);

  TweetDetailCommentTabState(BaseTweet? tweet) {
    if (tweet != null) {
      _commentList = tweet.dirReplies;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      // _loadData();
      // _refreshController.requestRefresh();
      _refreshComment(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget._tweet == null) {
      return Gaps.empty;
    }

    // if (CollUtil.isListEmpty(_commentList)) {
    //   return Scaffold(
    //       body: Container(
    //           height: 100,
    //           alignment: Alignment.topCenter,
    //           margin: const EdgeInsets.only(top: 60),
    //           child:
    //               // _commentList == null
    //               //     ? SpinKitDualRing(color: TweetTypeUtil.parseType(widget._tweet!.type).color, size: 13, lineWidth: 2):
    //               const Text('暂无评论', style: TextStyle(color: Colours.secondaryFontColor, fontSize: 13.0))));
    // }
    return SmartRefresher(
        controller: _refreshController,
        enablePullDown: false,
        enablePullUp: false,
        onRefresh: () => _refreshComment(true),
        header: ClassicHeader(
            iconPos: IconPosition.top,
            refreshingText: '正在刷新',
            releaseText: '释放以刷新',
            idleText: '继续下滑',
            failedText: '刷新失败',
            completeText: '刷新完成',
            outerBuilder: (child) {
              return SizedBox(width: 80.0, child: Center(child: child));
            }),
        // onLoading: _loadData,
        child: CollUtil.isListEmpty(_commentList)
            ? Container(
                height: 100,
                alignment: Alignment.topCenter,
                margin: const EdgeInsets.only(top: 60),
                child:
                    // _commentList == null
                    //     ? SpinKitDualRing(color: TweetTypeUtil.parseType(widget._tweet!.type).color, size: 13, lineWidth: 2):
                    const Text('暂无评论', style: TextStyle(color: Colours.secondaryFontColor, fontSize: 13.0)))
            : ListView.builder(
                shrinkWrap: true,
                itemBuilder: (ctx, index) {
                  return _renderReplyItem(ctx, index, _commentList![index], false);
                },
                itemCount: _commentList!.length),
        footer: const ClassicFooter(
          textStyle: TextStyle(color: Colors.grey, fontSize: 13),
          loadStyle: LoadStyle.ShowWhenLoading,
          loadingText: '正在加载...',
          canLoadingText: '释放以加载更多',
          noDataText: '- 到底了哦 -',
          idleText: '继续上滑',
        ));
  }

  void _refreshComment(bool autoFinishRefresh) async {
    List<TweetReply> data = await TweetApi.queryTweetReply(widget._tweet!.id!, true);
    setState(() {
      _commentList = data;
      if (widget._tweet != null) {
        widget._tweet!.dirReplies = _commentList;
      }
      if (autoFinishRefresh) {
        _refreshController.refreshCompleted();
      }
    });
  }

  // _loadData() async {
  //   List<TweetAccount> list = await TweetApi.queryTweetPraise(++_currentPage, _pageSize, widget._tweet!.id!);
  //   if (CollUtil.isListEmpty(list)) {
  //     setState(() {
  //       _praiseList = [];
  //     });
  //     _refreshController.loadNoData();
  //     return;
  //   }
  //   setState(() {
  //     _praiseList ??= [];
  //     _praiseList!.addAll(list);
  //   });
  //   if (list.length < _pageSize) {
  //     _refreshController.loadNoData();
  //   } else {
  //     _refreshController.loadComplete();
  //   }
  // }

  void outerCallRefresh(TweetReply? tweetReply, {bool reloadReply = false}) {
    if (reloadReply) {
      _refreshComment(false);
    }
  }

  Widget _renderReplyItem(BuildContext context, int index, TweetReply reply, bool subRender) {
    if (reply.anonymous != null && reply.anonymous!) {
      return Gaps.empty;
    }
    return LayoutBuilder(builder: (context, size) {
      return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (widget.onTapReply != null) {
              widget.onTapReply!(reply);
            }
          },
          onLongPress: () {
            List<BottomSheetItem> options = [];
            if (Application.getAccountId == reply.account!.id ||
                Application.getAccountId == widget._tweet!.account!.id) {
              options.add(BottomSheetItem(
                  const Icon(Icons.clear, color: Colors.red), '删除评论', () => _handleDeleteReply(context, reply)));
            }
            options.add(BottomSheetItem(const Icon(Icons.copy_rounded, color: Colors.amber), '复制内容', () async {
              await Clipboard.setData(ClipboardData(text: reply.body));
              ToastUtil.showToast(context, '已复制到粘贴板', goBack: true);
            }));
            BottomSheetUtil.showBottomSheetView(context, options);
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 0, top: subRender ? 5 : (index == 0 ? 5 : 5), right: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(right: 15.0),
                  child: AccountAvatar(
                      gender: Gender.parseGender(reply.account!.gender),
                      avatarUrl: reply.account!.avatarUrl!,
                      size: 40,
                      anonymous: reply.anonymous!,
                      onTap: () => NavigatorUtils.goAccountProfileByAcc(context, reply.account!),
                      cache: true),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildReplyHeader(context, reply, subRender),
                      _buildTimeWrapper(context, reply),
                      _buildReplyBody(context, reply, size),
                      // CollUtil.isListEmpty(reply.children)
                      //     ? Gaps.empty
                      //     : Padding(
                      //         padding: const EdgeInsets.only(top: 5),
                      //         child: Row(
                      //             mainAxisSize: MainAxisSize.min,
                      //             crossAxisAlignment: CrossAxisAlignment.center,
                      //             children: [
                      //               Text('查看${reply.children!.length}条回复',
                      //                   style: const TextStyle(color: Colors.blueAccent, fontSize: 14)),
                      //               const Icon(Icons.keyboard_arrow_right, size: 14, color: Colors.blueAccent)
                      //             ])),
                      subRender ? Gaps.empty : Gaps.line,
                      _buildSubReplyList(context, reply),
                    ],
                  ),
                )
              ],
            ),
          ));
    });
  }

  _buildReplyHeader(BuildContext context, TweetReply reply, bool subRender) {
    if (!subRender) {
      return Text(reply.account!.nick!, style: replyNickStyle);
    }

    bool replyAuthor = reply.tarAccount!.id == widget._tweet!.account!.id;
    return RealRichText([
      TextSpan(text: reply.account!.nick!, style: replyNickStyle),
      TextSpan(text: ' 回复 ', style: replyNickStyle),
      TextSpan(text: replyAuthor ? '作者' : reply.tarAccount!.nick, style: replyNickStyle)
    ]);
  }

  _buildTimeWrapper(BuildContext context, TweetReply reply) {
    return Padding(
        padding: const EdgeInsets.only(top: 3.0),
        child: Text(TimeUtil.getShortTime(reply.sentTime!),
            style: const TextStyle(color: Colours.secondaryFontColor, fontWeight: FontWeight.w500, fontSize: 11.5)));
  }

  _buildReplyBody(BuildContext context, TweetReply reply, BoxConstraints size) {
    String? body = reply.body;
    if (body == null || body.isEmpty) {
      return Gaps.empty;
    }
    var replyBodyStyle =
        TextStyle(fontSize: 14.5, color: Colours.getEmphasizedTextColor(context), fontWeight: FontWeight.w400);
    // 判断是否溢出

    TextSpan t = TextSpan(text: body, style: replyBodyStyle);
    final tp = TextPainter(text: t, maxLines: 3, textDirection: TextDirection.ltr);
    tp.layout(maxWidth: size.maxWidth);

    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        // showModalBottomSheet(
        //   context: context,
        //   builder: (BuildContext context) {
        //     return BottomSheetConfirm(
        //         title: '评论操作',
        //         optChoice: '举报',
        //         optColor: Colors.redAccent,
        //         onTapOpt: () =>
        //             NavigatorUtils.goReportPage(context, ReportPage.REPORT_TWEET_REPLY, reply.id.toString(), "评论举报"));
        //   },
        // );
        child: Container(
            margin: const EdgeInsets.only(top: 5),
            child: tp.didExceedMaxLines
                ? ExpandableNotifier(
                    child: Expandable(
                    collapsed: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(body, maxLines: 3, overflow: TextOverflow.ellipsis, style: replyBodyStyle),
                      ExpandableButton(
                          child: Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Row(children: const [
                                Text('展开全部', style: TextStyle(color: Colors.grey, fontSize: 14)),
                                Icon(Icons.arrow_drop_down_outlined, color: Colors.grey)
                              ])))
                    ]),
                    expanded: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(body, maxLines: 999, overflow: TextOverflow.ellipsis, style: replyBodyStyle),
                      ExpandableButton(
                          child: Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Row(children: const [
                                Text('收起', style: TextStyle(color: Colors.grey, fontSize: 14)),
                                Icon(Icons.arrow_drop_up_outlined, color: Colors.grey)
                              ])))
                    ]),
                  ))
                : Text(body, style: replyBodyStyle)
            // child: ExtendedText(body,
            //     maxLines: 3,
            //     softWrap: true,
            //     textAlign: TextAlign.left,
            //     specialTextSpanBuilder: MySpecialTextSpanBuilder(showAtBackground: false),
            // onSpecialTextTap: (dynamic parameter) {},
            // selectionEnabled: false,
            // overflowWidget: TextOverflowWidget(
            //     fixedOffset: Offset(10.0, 0.0),
            // child: Row(children: <Widget>[
            // GestureDetector(
            //     child: const Text('全部', style: TextStyle(color: Colors.grey, fontSize: 14)),
            //     onTap: () {
            //       BottomSheetUtil.showBottomSheetSingleTweetReplyDetail(
            //           context, reply, reply.anonymous, tweetAnonymous && reply.account.id == tweetAccountId,
            //           onTap: () => NavigatorUtils.goBack(context));
            // })
            // ])),
            // style: TextStyle(fontSize: 14.5, color: Colours.getEmphasizedTextColor(context))),
            ));
  }

  _buildSubReplyList(BuildContext context, TweetReply reply) {
    var subReplyList = reply.children;
    if (CollUtil.isListEmpty(subReplyList)) {
      return Gaps.empty;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: subReplyList!.map((e) => _renderReplyItem(context, -1, e, true)).toList(),
    );
  }

  // outer call
  void iPraise(bool praise) {}

  void _handleDeleteReply(BuildContext context, TweetReply reply) async {
    Util.showDefaultLoadingWithBounds(context);
    Result res = await TweetApi.delTweetReply(reply.id!);
    if (!res.isSuccess) {
      ToastUtil.showToast(context, '删除失败');
      NavigatorUtils.goBack(context, len: 2);
      return;
    }
    Provider.of<TweetProvider>(context, listen: false)
        .deleteReply(widget._tweet!.id!, reply.parentId!, reply.id!, reply.type!);
    NavigatorUtils.goBack(context, len: 2);
  }
}
