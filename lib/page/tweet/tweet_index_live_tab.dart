import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wall/api/tweet_api.dart';
import 'package:wall/application.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/model/biz/common/page_param.dart';
import 'package:wall/model/biz/tweet/tweet.dart';
import 'package:wall/provider/msg_provider.dart';
import 'package:wall/provider/tweet_provider.dart';
import 'package:wall/util/coll_util.dart';
import 'package:wall/widget/tweet/tweet_index_item.dart';
import 'package:wall/widget/tweet/tweet_no_data_view.dart';

class TweetIndexLiveTab extends StatefulWidget {
  const TweetIndexLiveTab({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TweetIndexLiveTabState();
  }
}

class TweetIndexLiveTabState extends State<TweetIndexLiveTab> {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  late TweetProvider tweetProvider;

  int _currentPage = 1;

  final Widget loadingIconStatic =
      const SizedBox(width: 25.0, height: 25.0, child: CupertinoActivityIndicator(animating: false));

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    tweetProvider = Provider.of<TweetProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colours.getTweetScaffoldColor(context),
      body: Consumer<TweetProvider>(builder: (context, provider, _) {
        var tweets = provider.displayTweets;
        return SmartRefresher(
              enablePullUp: tweets != null && tweets.isNotEmpty,
              enablePullDown: true,
              primary: false,
              scrollController: _scrollController,
              controller: _refreshController,
              cacheExtent: 20,
              header: ClassicHeader(
                idleText: '',
                releaseText: '',
                refreshingText: '',
                completeText: '',
                refreshStyle: RefreshStyle.Follow,
                idleIcon: loadingIconStatic,
                releaseIcon: loadingIconStatic,
                completeDuration: Duration(milliseconds: 0),
                completeIcon: null,
              ),
              footer: ClassicFooter(
                loadingText: '正在加载...',
                canLoadingText: '释放以加载更多',
                noDataText: '到底了哦',
                idleText: '继续上滑',
              ),
              child: tweets == null
                  ? const Align(
                      alignment: Alignment.topCenter,
                      child: Padding(padding: EdgeInsets.only(top: 30.0), child: CupertinoActivityIndicator()))
                  : tweets.isEmpty
                      ? TweetNoDataView(onTapReload: () {
                          if (_refreshController != null) {
                            _refreshController.resetNoData();
                            _refreshController.requestRefresh();
                          }
                        })
                      : ListView.builder(
                          primary: true,
                          itemCount: tweets.length,
                          addAutomaticKeepAlives: true,
                          itemBuilder: (context, index) {
                            return TweetIndexItem(
                              tweets[index],
                              displayExtra: true,
                              displayPraise: true,
                              displayComment: true,
                              displayLink: true,
                              canPraise: true,
                              indexInList: index,
                              // onClickComment:
                              //     (TweetReply subReply, String targetNick, String targetAccountId) {
                              //   _bottomSheetController =
                              //       Scaffold.of(context).showBottomSheet((context) => Container(
                              //               child: TweetIndexCommentWrapper(
                              //             // 如果是子回复 ，reply不为空
                              //             replyType: subReply == null ? 1 : 2,
                              //             showAnonymous: subReply == null,
                              //             hintText: targetNick != null ? '回复: $targetNick' : '评论',
                              //             onSend: (String value, bool anonymous) async {
                              //               TweetReply reply = TRUtil.assembleReply(
                              //                   tweets[index], value, anonymous, true,
                              //                   subReply: subReply);
                              //
                              //               await TRUtil.publicReply(context, reply,
                              //                   (bool success, TweetReply newReply) {
                              //                 if (success) {
                              //                   closeReplyInput();
                              //                   final _tweetProvider = Provider.of<TweetProvider>(context, listen: false);
                              //                   _tweetProvider.updateReply(context, newReply);
                              //                 } else {
                              //                   ToastUtil.showToast(context, "评论失败，请稍后再试");
                              //                 }
                              //               });
                              //             },
                              //           )));
                              // },
                            );
                          }),
              onRefresh: () => _onRefresh(context),
              onLoading: _onLoading,
            );
      }),
    );
  }

  // void closeReplyInput() {
  //   if (_bottomSheetController != null) {
  //     _bottomSheetController.close();
  //   }
  // }

  Future<void> _onRefresh(BuildContext context) async {
    _refreshController.resetNoData();
    _currentPage = 1;
    List<BaseTweet> temp = await getData(_currentPage);
    tweetProvider.update(temp, clear: true, append: false);
    Provider.of<MsgProvider>(context, listen: false).updateTweetNewCnt(0);
    if (temp == null) {
      _refreshController.refreshFailed();
    } else {
      _refreshController.refreshCompleted();
    }
  }

  void initData() async {
    List<BaseTweet> temp = await getData(1);
    tweetProvider.update(temp, clear: true, append: false);
    _refreshController.refreshCompleted();
  }

  Future<void> _onLoading() async {
    List<BaseTweet> temp = await getData(++_currentPage);
    tweetProvider.update(temp, append: true, clear: false);
    if (CollUtil.isListEmpty(temp)) {
      _currentPage--;
      _refreshController.loadNoData();
    } else {
      _refreshController.loadComplete();
    }
  }

  Future getData(int page) async {
    return await (TweetApi.queryTweets(PageParam(page, pageSize: 10, orgId: Application.getOrgId)));
  }

  void goTop() {
    _scrollController.animateTo(.0, duration: const Duration(milliseconds: 1688), curve: Curves.easeInOutQuint);
  }
}
