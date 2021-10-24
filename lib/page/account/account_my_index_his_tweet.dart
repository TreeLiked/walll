import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wall/api/tweet_api.dart';
import 'package:wall/application.dart';
import 'package:wall/model/biz/common/page_param.dart';
import 'package:wall/model/biz/tweet/tweet.dart';
import 'package:wall/util/coll_util.dart';
import 'package:wall/widget/common/empty_view.dart';
import 'package:wall/widget/common/widget_sliver_future_builder.dart';
import 'package:wall/widget/tweet/tweet_self_item.dart';

class AccountHisTweetPage extends StatefulWidget {
  const AccountHisTweetPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AccountHisTweetPageState();
  }
}

class _AccountHisTweetPageState extends State<AccountHisTweetPage>
    with AutomaticKeepAliveClientMixin<AccountHisTweetPage>, SingleTickerProviderStateMixin {
  late RefreshController _refreshController;
  late Function _getPushedTask;

  List<BaseTweet> _accountTweets = [];
  int _currentPage = 1;

  Future<List<BaseTweet>> _getTweets(BuildContext context) async {
    List<BaseTweet> tweets = await TweetApi.querySelfTweets(
        PageParam(_currentPage, pageSize: 5), Application.getAccountId!,
        needAnonymous: true);
    if (CollUtil.isListNotEmpty(tweets)) {
      setState(() {
        _currentPage++;
        _accountTweets.addAll(tweets);
      });
    }
    return tweets;
  }

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    _getPushedTask = _getTweets;
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return
          CustomSliverFutureBuilder(futureFunc: _getPushedTask, builder: (context, data) => _buildBody(context, data));
  }

  _buildBody(BuildContext context, dynamic data) {
    return SmartRefresher(
        controller: _refreshController,
        enablePullUp: true,
        enablePullDown: true,
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
        footer: const ClassicFooter(
            loadingText: '正在加载更多...', canLoadingText: '释放以加载更多', noDataText: '- 我是有底线的 -', idleText: '继续上滑'),
        onRefresh: _refresh,
        onLoading: _loadMoreData,
        child: !CollUtil.isListEmpty(_accountTweets)
            ? ListView.builder(
                itemCount: _accountTweets.length,
                itemBuilder: (context, index) {
                  return TweetSelfItem(_accountTweets[index], indexInList: index, onDelete: (tweetId) {
                    setState(() {
                      _accountTweets.removeWhere((tweet) => tweet.id == tweetId);
                    });
                  });
                })
            : const Center(
                child: Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: EmptyView(
                      tip: '快去发布第一条动态吧 ~',
                    )),
              ));
  }

  Future<void> _loadMoreData() async {
    List<BaseTweet> tweets = await _getTweets(context);
    if (CollUtil.isListEmpty(tweets)) {
      _refreshController.loadNoData();
    } else {
      _refreshController.loadComplete();
    }
  }

  Future<void> _refresh() async {
    _currentPage = 1;
    List<BaseTweet> tweets =
        await TweetApi.querySelfTweets(PageParam(1, pageSize: 5), Application.getAccountId!, needAnonymous: true);
    if (CollUtil.isListNotEmpty(tweets)) {
      setState(() {
        _currentPage++;
        _accountTweets = [];
        _accountTweets.addAll(tweets);
      });
    } else {
      setState(() {
        _accountTweets = [];
      });
    }
    _refreshController.refreshCompleted();
  }

  @override
  bool get wantKeepAlive => true;
}
