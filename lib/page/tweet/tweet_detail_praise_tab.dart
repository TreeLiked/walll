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
import 'package:wall/model/biz/tweet/tweet_type.dart';
import 'package:wall/util/coll_util.dart';
import 'package:wall/util/navigator_util.dart';
import 'package:wall/widget/common/account_avatar.dart';

class TweetDetailPraiseTab extends StatefulWidget {
  final BaseTweet? _tweet;

  const TweetDetailPraiseTab(this._tweet, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TweetDetailPraiseTabState();
  }
}

class _TweetDetailPraiseTabState extends State<TweetDetailPraiseTab> {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  List<TweetAccount>? _praiseList;

  int _currentPage = 0;
  final int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      _loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget._tweet == null) {
      return Gaps.empty;
    }
    if (CollUtil.isListEmpty(_praiseList)) {
      return Scaffold(
          body: Container(
              height: 100,
              alignment: Alignment.topCenter,
              margin: const EdgeInsets.only(top: 60),
              child: _praiseList == null
                  ? SpinKitDualRing(color: TweetTypeUtil.parseType(widget._tweet!.type).color, size: 13, lineWidth: 2)
                  : const Text('点个赞支持一下吧～', style: TextStyle(color: Colours.secondaryFontColor, fontSize: 13.0))));
    }
    return Scaffold(
        body: SmartRefresher(
            controller: _refreshController,
            enablePullDown: false,
            enablePullUp: true,
            onLoading: _loadData,
            child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (ctx, index) {
                  return _renderPraiseItem(ctx, index, _praiseList![index]);
                },
                itemCount: _praiseList!.length),
            footer: const ClassicFooter(
              textStyle: TextStyle(color: Colors.grey, fontSize: 13),
              loadStyle: LoadStyle.ShowWhenLoading,
              loadingText: '正在加载...',
              canLoadingText: '释放以加载更多',
              noDataText: '- 到底了哦 -',
              idleText: '继续上滑',
            )));
  }

  _loadData() async {
    List<TweetAccount> list = await TweetApi.queryTweetPraise(++_currentPage, _pageSize, widget._tweet!.id!);
    if (CollUtil.isListEmpty(list)) {
      setState(() {
        _praiseList = [];
      });
      _refreshController.loadNoData();
      return;
    }
    setState(() {
      _praiseList ??= [];
      _praiseList!.addAll(list);
    });
    if (list.length < _pageSize) {
      _refreshController.loadNoData();
    } else {
      _refreshController.loadComplete();
    }
  }

  _renderPraiseItem(BuildContext context, int index, TweetAccount acc) {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(bottom: 20),
      child: ListTile(
          leading: AccountAvatar(
              size: 40,
              whitePadding: false,
              avatarUrl: acc.avatarUrl!,
              anonymous: false,
              cache: false,
              gender: Gender.parseGender(acc.gender),
              onTap: () => NavigatorUtils.goAccountProfileByTweetAcc(context, acc)),
          contentPadding: const EdgeInsets.only(right: 10.0),
          title: GestureDetector(
            onTap: () => NavigatorUtils.goAccountProfileByTweetAcc(context, acc),
            child: Text(acc.nick ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colours.getEmphasizedTextColor(context), fontSize: 14.0, fontWeight: FontWeight.w400)),
          ),
          subtitle: Text(acc.signature ?? "",
              style: const TextStyle(color: Colours.secondaryFontColor, fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis)),
    );
  }

  // outer call
  void iPraise(bool praise) {}
}
