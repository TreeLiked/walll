import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
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
  late EasyRefreshController _easyRefreshController;
  late Function _getPushedTask;

  final List<BaseTweet> _accountTweets = [];
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
    _easyRefreshController = EasyRefreshController();
    _getPushedTask = _getTweets;
  }

  @override
  void dispose() {
    _easyRefreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body:
          CustomSliverFutureBuilder(futureFunc: _getPushedTask, builder: (context, data) => _buildBody(context, data)),
    );
  }

  _buildBody(BuildContext context, dynamic data) {
    return EasyRefresh(
        controller: _easyRefreshController,
        enableControlFinishLoad: true,
        // footer: Emp(backgroundColor: Colors.lightBlueAccent),
        footer: ClassicalFooter(
            textColor: Colors.grey,
            extent: 40.0,
            noMoreText: '- 我是有底线的 -',
            loadedText: '加载完成',
            loadFailedText: '加载失败',
            loadingText: '正在加载...',
            loadText: '上滑加载',
            loadReadyText: '释放加载',
            showInfo: false,
            enableHapticFeedback: true,
            enableInfiniteLoad: true),
        onLoad: _loadMoreData,
        child: !CollUtil.isListEmpty(_accountTweets)
            ? ListView.builder(
                itemCount: _accountTweets.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return TweetSelfItem(_accountTweets[index], indexInList: index);
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
    _easyRefreshController.finishLoad(success: true, noMore: CollUtil.isListEmpty(tweets));
  }

  @override
  bool get wantKeepAlive => true;
}
