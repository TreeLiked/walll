import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wall/api/tweet_api.dart';
import 'package:wall/application.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/model/biz/common/page_param.dart';
import 'package:wall/model/biz/tweet/tweet.dart';
import 'package:wall/model/biz/tweet/tweet_type.dart';
import 'package:wall/provider/msg_provider.dart';
import 'package:wall/provider/tweet_provider.dart';
import 'package:wall/util/coll_util.dart';
import 'package:wall/widget/tweet/tweet_index_item.dart';
import 'package:wall/widget/tweet/tweet_no_data_view.dart';

class TweetCateTab extends StatefulWidget {
  final TweetTypeEntity typeEntity;

  const TweetCateTab({Key? key, required this.typeEntity}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TweetCateTabState();
  }
}

class _TweetCateTabState extends State<TweetCateTab> {
  final RefreshController _refreshController = RefreshController(initialRefresh: true);

//  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  // PersistentBottomSheetController _bottomSheetController;

  late TweetProvider tweetProvider;

  int _currentPage = 1;

  List<BaseTweet> tweets = [];

  Widget loadingIconStatic =
      const SizedBox(width: 25.0, height: 25.0, child: CupertinoActivityIndicator(animating: false));

  @override
  Widget build(BuildContext context) {
    tweetProvider = Provider.of<TweetProvider>(context, listen: false);
    return Scaffold(
        backgroundColor: Colours.getTweetScaffoldColor(context),
        body: SmartRefresher(
          enablePullUp: tweets.isNotEmpty,
          enablePullDown: true,
          primary: false,
          scrollController: ScrollController(),
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
          footer: const ClassicFooter(
            loadingText: '正在加载...',
            canLoadingText: '释放以加载更多',
            noDataText: '到底了哦',
            idleText: '继续上滑',
          ),
          child: tweets.isEmpty && !_refreshController.isRefresh
              ? TweetNoDataView(onTapReload: () {
                  _refreshController.resetNoData();
                  _refreshController.requestRefresh();
                })
              : ListView.builder(
                  primary: true,
                  itemCount: tweets.length,
                  addAutomaticKeepAlives: true,
                  itemBuilder: (context, index) {
                    return TweetIndexItem(tweets[index],
                        displayExtra: true,
                        displayPraise: true,
                        displayComment: true,
                        displayLink: true,
                        canPraise: true,
                        indexInList: index,
                        displayType: false,
                        source: "2");
                  }),
          onRefresh: () => _onRefresh(context),
          onLoading: _onLoading,
        ));
  }

  Future<void> _onRefresh(BuildContext context) async {
    _refreshController.resetNoData();
    _currentPage = 1;
    List<BaseTweet> temp = await getData(_currentPage);
    if (temp.isNotEmpty) {
      setState(() {
        tweets = temp;
      });
      _refreshController.refreshCompleted();
    } else {
      setState(() {
        tweets = [];
      });
      _refreshController.refreshFailed();
    }
  }

  // void initData() async {
  //   List<BaseTweet> temp = await getData(1);
  //   tweetProvider.update(temp, clear: true, append: false);
  //   _refreshController.refreshCompleted();
  // }

  Future<void> _onLoading() async {
    List<BaseTweet> temp = await getData(++_currentPage);
    if (CollUtil.isListEmpty(temp)) {
      _currentPage--;
      _refreshController.loadNoData();
    } else {
      setState(() {
        tweets.addAll(temp);
      });
      _refreshController.loadComplete();
    }
  }

  Future getData(int page) async {
    return await (TweetApi.queryTweets(
        PageParam(page, pageSize: 10, orgId: Application.getOrgId, types: [widget.typeEntity.name])));
  }
}
