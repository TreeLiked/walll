import 'package:extended_text/extended_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wall/api/tweet_api.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/constant/gap_constant.dart';
import 'package:wall/model/biz/common/gender.dart';
import 'package:wall/model/biz/tweet/tweet.dart';
import 'package:wall/model/biz/tweet/tweet_account.dart';
import 'package:wall/model/biz/tweet/tweet_reply.dart';
import 'package:wall/model/biz/tweet/tweet_type.dart';
import 'package:wall/util/coll_util.dart';
import 'package:wall/util/navigator_util.dart';
import 'package:wall/widget/common/account_avatar.dart';

class TweetDetailCommentTab extends StatefulWidget {
  final BaseTweet? _tweet;

  const TweetDetailCommentTab(this._tweet, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TweetDetailCommentTabState();
  }
}

class _TweetDetailCommentTabState extends State<TweetDetailCommentTab> {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  List<TweetReply>? _commentList;

  int _currentPage = 0;
  final int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      // _loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget._tweet == null) {
      return Gaps.empty;
    }
    _commentList = widget._tweet!.dirReplies;

    if (CollUtil.isListEmpty(_commentList)) {
      return Scaffold(
          body: Container(
              height: 100,
              alignment: Alignment.topCenter,
              margin: const EdgeInsets.only(top: 60),
              child:
                  // _commentList == null
                  //     ? SpinKitDualRing(color: TweetTypeUtil.parseType(widget._tweet!.type).color, size: 13, lineWidth: 2):
                  const Text('暂无评论', style: TextStyle(color: Colours.secondaryFontColor, fontSize: 13.0))));
    }
    return Scaffold(
        body: SmartRefresher(
            controller: _refreshController,
            enablePullDown: false,
            enablePullUp: false,
            // onLoading: _loadData,
            child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (ctx, index) {
                  return _renderReplyItem(ctx, index, _commentList![index]);
                },
                itemCount: _commentList!.length),
            footer: const ClassicFooter(
              textStyle: TextStyle(color: Colors.grey, fontSize: 13),
              loadStyle: LoadStyle.ShowWhenLoading,
              loadingText: '正在加载...',
              canLoadingText: '释放以加载更多',
              noDataText: '- 到底了哦 -',
              idleText: '继续上滑',
            )));
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

  _renderReplyItem(BuildContext context, int index, TweetReply reply) {
    return Container(
      margin: EdgeInsets.only(bottom: 20,top: index == 0 ? 20 :0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          reply.type == 2 && reply.tarAccount != null ? SizedBox(width: 48) : Gaps.empty,
          Container(
            margin: const EdgeInsets.only(right: 11.0),
            child: AccountAvatar(
                avatarUrl: reply.account!.avatarUrl!, size: 40, anonymous: reply.anonymous!, cache: false),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // _headContainer(),
                _buildReplyBody(context, reply),
                // Row(
                //   children: <Widget>[
                //     _timeContainer(),
                //     _delReplyContainer(),
                //   ],
                // ),
                Gaps.vGap4,
                Gaps.line,
              ],
            ),
          )
        ],
      ),
    );
  }

  _buildReplyBody(BuildContext context, TweetReply reply) {
    String? body = reply.body;
    if (body == null || body.isEmpty) {
      return Gaps.empty;
    }
    return GestureDetector(
//        onLongPress: () {
//          showModalBottomSheet(
//            context: context,
//            builder: (BuildContext context) {
//              return BottomSheetConfirm(
//                  title: '评论操作',
//                  optChoice: '举报',
//                  optColor: Colors.redAccent,
//                  onTapOpt: () => NavigatorUtils.goReportPage(
//                      context, ReportPage.REPORT_TWEET_REPLY, reply.id.toString(), "评论举报"));
//            },
//          );
//        },
        child: Container(
      margin: const EdgeInsets.only(top: 1.5),
      child: ExtendedText("$body",
          maxLines: 3,
          softWrap: true,
          textAlign: TextAlign.left,
          // specialTextSpanBuilder: MySpecialTextSpanBuilder(showAtBackground: false),
          onSpecialTextTap: (dynamic parameter) {},
          selectionEnabled: true,
          // overflowWidget: TextOverflowWidget(
          //   // fixedOffset: Offset(10.0, 0.0),
          //     child: Row(children: <Widget>[
          //       GestureDetector(
          //           child: Text(
          //             '..查看全部',
          //             style: pfStyle.copyWith(
          //               color: Colors.blue,
          //               fontSize: Dimens.font_sp14,
          //             ),
          //           ),
          //           onTap: () {
          //             BottomSheetUtil.showBottomSheetSingleTweetReplyDetail(
          //                 context, reply, reply.anonymous, tweetAnonymous && reply.account.id == tweetAccountId,
          //                 onTap: () => NavigatorUtils.goBack(context));
          //           })
          //     ])),
          style: TextStyle(fontSize: 14.5, color: Colours.getEmphasizedTextColor(context))),
    ));
  }

  // outer call
  void iPraise(bool praise) {}
}
