import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wall/api/tweet_api.dart';
import 'package:wall/config/routes/routes.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/constant/gap_constant.dart';
import 'package:wall/model/biz/tweet/tweet.dart';
import 'package:wall/model/biz/tweet/tweet_account.dart';
import 'package:wall/model/biz/tweet/tweet_type.dart';
import 'package:wall/page/tweet/tweet_detail_comment_tab.dart';
import 'package:wall/page/tweet/tweet_detail_praise_tab.dart';
import 'package:wall/page/tweet/tweet_index_hot_tab.dart';
import 'package:wall/util/custom_number_util.dart';
import 'package:wall/util/fluro_convert_utils.dart';
import 'package:wall/util/navigator_util.dart';
import 'package:wall/util/theme_util.dart';
import 'package:wall/util/toast_util.dart';
import 'package:wall/util/umeng_util.dart';
import 'package:wall/widget/common/real_rich_text.dart';
import 'package:wall/widget/common/sliver/sliver_header_delegate.dart';
import 'package:wall/widget/tweet/tweet_body_wrapper.dart';
import 'package:wall/widget/tweet/tweet_detail_item_header.dart';
import 'package:wall/widget/tweet/tweet_media_wrapper.dart';

class TweetDetailPage extends StatefulWidget {
  final int tweetId;
  late BaseTweet? tweet;

  // 是否从热门进入
  final bool fromHot;

  // 删除回调
  final Function? onDelete;

  TweetDetailPage({Key? key, required this.tweetId, this.tweet, this.onDelete, this.fromHot = false}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TweetDetailPageState();
  }
}

class _TweetDetailPageState extends State<TweetDetailPage>
    with AutomaticKeepAliveClientMixin<TweetDetailPage>, SingleTickerProviderStateMixin {
  late BuildContext _context;

  BaseTweet? tweet;

  late TabController _praiseCommentTabController;
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  Future? _getPraiseTask;

  Future? _getReplyTask;

  // 回复相关
  bool isDark = false;

  final GlobalKey _praiseTabKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _praiseCommentTabController = TabController(vsync: this, length: 2);
    UMengUtil.userGoPage(widget.fromHot ? UMengUtil.pageTweetIndexDetailHot : UMengUtil.pageTweetIndexDetail);

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _fetchTweetIfNullAndFetchExtra();
    });
  }

  _fetchTweetIfNullAndFetchExtra() async {
    BaseTweet? bt = widget.tweet ?? (await TweetApi.queryTweetById(widget.tweetId, pop: false));
    if (bt == null) {
      ToastUtil.showToast(context, '内容不存在或已经被删除');
      NavigatorUtils.goBack(context);
      return;
    }
    // setState(() {
    //   tweet = widget.tweet;
    // });
    _refresh(() => tweet = bt);
  }

  Widget _buildHeader() {
    bool anonymous = tweet!.anonymous!;
    return TweetDetailItemHeader(tweet!);
    // return Row(
    //   mainAxisSize: MainAxisSize.max,
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: <Widget>[
    //     // 头像
    //     Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: <Widget>[
    //         GestureDetector(
    //             onTap: _forwardAccountProfile,
    //             child: AccountAvatar(
    //                 avatarUrl: tweet!.account!.avatarUrl!,
    //                 size: 40,
    //                 cache: true,
    //                 anonymous: tweet!.anonymous!,
    //                 gender: Gender.parseGenderByTweetAccount(tweet!.account)))
    //       ],
    //     ),
    //     Gaps.hGap8,
    //     Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       mainAxisSize: MainAxisSize.max,
    //       children: <Widget>[
    //         RichText(
    //             softWrap: true,
    //             text: TextSpan(children: [
    //               TextSpan(
    //                   recognizer: TapGestureRecognizer()..onTap = _forwardAccountProfile,
    //                   text: anonymous ? TextCst.anonymousNick : tweet!.account!.nick ?? "",
    //                   style: TextStyle(
    //                       color: Colours.getEmphasizedTextColor(context), fontSize: 15.0, fontWeight: FontWeight.bold))
    //             ])),
    //         Gaps.vGap5,
    //         Text(TimeUtil.getShortTime(tweet!.sentTime!),
    //             style: const TextStyle(fontSize: 13.5, color: Colours.secondaryFontColor))
    //       ],
    //     ),
    //   ],
    // );
  }

  // _forwardAccountProfile(bool up, Account account, {bool forceForbid = false}) {
  //   if (((up && !widget.tweet.anonymous) || !up) && !forceForbid) {
  //     NavigatorUtils.push(
  //         context,
  //         Routes.accountProfile +
  //             Utils.packConvertArgs({'nick': account.nick, 'accId': account.id, 'avatarUrl': account.avatarUrl}));
  //   }
  // }
  //
  _forwardAccountProfile() {
    if (tweet == null || tweet!.account == null || (tweet!.anonymous ?? true)) {
      return;
    }
    TweetAccount account = tweet!.account!;

    NavigatorUtils.push(
        context,
        Routes.accountProfile +
            FluroConvertUtils.packConvertArgs(
                {'nick': account.nick!, 'accId': account.id!, 'avatarUrl': account.avatarUrl!}));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    isDark = ThemeUtil.isDark(context);
    _context = context;

    if (tweet == null) {
      return Scaffold(
          body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => _sliverBuilderEmpty(context, innerBoxIsScrolled),
              body: Column(children: [
                Container(
                  height: 80,
                  alignment: Alignment.topCenter,
                  child: const SpinKitDancingSquare(color: Colors.lightGreen, size: 20),
                )
              ])));
    }

    return Scaffold(
        // backgroundColor: !isDark
        //     ? (widget._fromHot ? Color(0xffe9e9e9) : null)
        //     : (widget._fromHot ? Color(0xff2c2c2c) : Colours.dark_bg_color),
        // backgroundColor: !isDark ? null : Colours.dark_bg_color,
        body: Builder(builder: (context) {
      return Listener(
//                behavior: HitTestBehavior.opaque,
//                onPanDown: (_) {
//                  hideReplyContainer();
//                  hideBottomSheetReplyContainer();
//                },
        onPointerDown: (_) {
          // hideBottomSheetReplyContainer();
        },
        child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => _sliverBuilder(context, innerBoxIsScrolled),
            body: Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 30),
              child: TabBarView(
                  controller: _praiseCommentTabController,
                  children: [TweetDetailCommentTab(tweet!), TweetDetailPraiseTab(tweet!, key: _praiseTabKey)]),
            )
            // body: SafeArea(
            //   top: false,
            //   child: SmartRefresher(
            //     footer: const ClassicFooter(
            //       loadingText: '正在加载...',
            //       canLoadingText: '释放以加载更多',
            //       noDataText: '到底了哦',
            //       idleText: '继续上滑',
            //     ),
            //     controller: _refreshController,
            //     enablePullDown: false,
            //     enablePullUp: true,
            //     onLoading: _loadPraiseOrComment,
            //     child:  Container(
            //           decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(18))),
            //           padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
            //           height: Application.screenHeight,
            //           child: Column(
            //               mainAxisSize: MainAxisSize.max,
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: <Widget>[
            //               _buildHeader(),
            //           TweetBodyWrapper(tweet!.body, height: 2.0, selectable: true),
            //           TweetMediaWrapper(tweet: tweet!),
            //           // widget.newLink
            //           //     ? TweetLinkWrapper2(widget.tweet, _getLinkTask, fromHot: widget._fromHot)
            //           //     : TweetLinkWrapper(tweet),
            //           // Gaps.vGap8,
            //           // _viewContainer(),
            //           TweetInteractWrapper(tweet!),
            //
            //            Expanded(child:TabBarView(controller: _praiseCommentTabController, children: [
            //               TweetIndexHotTab(),
            //               TweetIndexHotTab()
            //             ])),
            //             // _praiseWrapper(context),
            //             // TweetPraiseWrapper2(praiseAccounts),
            //             // _replyWrapper(context),
            //             // TweetReplyWrapper(tweet, replies, (TweetReply tr, String tarAccNick, String tarAccId) {
            //             //   String hintText = "回复：$tarAccNick";
            //             //   if (tweet.anonymous && tarAccId == tweet.account.id) {
            //             //     hintText = "回复：作者";
            //             //   }
            //             //   showBottomSheetReplyContainer(2, false, hintText, (String value, bool anonymous) {
            //             //     TweetReply reply = TRUtil.assembleReply(tweet, value, false, false,
            //             //         parentId: tr.parentId, tarAccountId: tarAccId);
            //             //     reply.sentTime = DateTime.now();
            //             //     TRUtil.publicReply(context, reply,
            //             //         (bool success, TweetReply newReply) => this.handleSendResult(success, newReply));
            //             //   });
            //             // }, () {
            //             //   setState(() {
            //             //     _getReplyTask = getTweetReply();
            //             //   });
            //             // }),
            //             ],
            //           ),
            //         ),
            //   ),
            // )
            ),
      );
    }));
  }

  void _loadPraiseOrComment() {
    print('21321312312');
    _refreshController.loadComplete();
  }

  List<Widget> _sliverBuilder(BuildContext context, bool innerBoxIsScrolled) {
    Color c = Colours.getEmphasizedTextColor(context);
    // 针对 点赞、回复数量container宽度的计算
    int praiseCntStrLen = CustomNumberUtil.calStrCountForNumber(tweet!.praise!);
    int replyCntStrLen = CustomNumberUtil.calStrCountForNumber(tweet!.replyCount!);
    int indicatorStrLen = _praiseCommentTabController.index == 0 ? replyCntStrLen : praiseCntStrLen;

    return <Widget>[
      SliverAppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.more_horiz, color: c, size: 20),
              onPressed: () {
                // BottomSheetUtil.showBottomSheetView(context, _getSheetItems());
              },
            )
          ],
          backgroundColor: Colours.getScaffoldColor(context),
          centerTitle: true,
          //标题居中
          title: Text(
            '动态详情',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: c),
          ),
          elevation: 0.2,
          floating: true,
          pinned: true,
          snap: false,
          leading:
              GestureDetector(onTap: () => Navigator.pop(context), child: Icon(Icons.arrow_back, color: c, size: 20))),
      SliverToBoxAdapter(
          child: Container(
              padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                _buildHeader(),
                TweetBodyWrapper(tweet!.body, height: 2.0, selectable: true),
                TweetMediaWrapper(tweet: tweet!),
                Gaps.line
              ]))),
      SliverOverlapAbsorber(
        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        sliver: SliverPersistentHeader(
            pinned: true,
            delegate: SliverHeaderDelegate(
                maxHeight: 60,
                minHeight: 60,
                changeSize: true,
                vSync: this,
                snapConfig: FloatingHeaderSnapConfiguration(
                  curve: Curves.bounceInOut,
                  duration: const Duration(milliseconds: 10),
                ),
                builder: (BuildContext context, double shrinkOffset, bool overlapsContent) {
                  ///根据数值计算偏差
                  var lr = 10 - shrinkOffset / 60 * 10;
                  return SizedBox.expand(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 20, left: 0, right: lr, top: 0),
                      child: Container(
                          alignment: Alignment.centerLeft,
                          width: double.infinity,
                          color: Colours.getScaffoldColor(context),
                          child: TabBar(
                              labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                              unselectedLabelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                              indicatorSize: TabBarIndicatorSize.label,
                              indicator: UnderlineTabIndicator(
                                  insets: const EdgeInsets.only(left: 5, right: 25),
                                  borderSide:
                                      BorderSide(color: TweetTypeUtil.parseType(tweet!.type).color, width: 2.0)),
                              controller: _praiseCommentTabController,
                              labelColor: Colours.getEmphasizedTextColor(context),
                              unselectedLabelColor: Colours.secondaryFontColor,
                              isScrollable: true,
                              labelPadding: const EdgeInsets.only(left: 10.0, right: 6.0),
                              tabs: [
                                Container(
                                    padding: const EdgeInsets.only(bottom: 3.0),
                                    width: 40 + 5 * replyCntStrLen.toDouble(),
                                    child: Stack(children: [
                                      const Text('评论'),
                                      Positioned(
                                          top: 1,
                                          right: 0,
                                          child: Text(CustomNumberUtil.calCount(tweet!.replyCount!, zeroEmpty: true),
                                              style: const TextStyle(color: Colors.grey, fontSize: 11)))
                                    ])),
                                Container(
                                    padding: const EdgeInsets.only(bottom: 3.0),
                                    width: 40 + 5 * praiseCntStrLen.toDouble(),
                                    child: Stack(children: [
                                      const Text('点赞'),
                                      Positioned(
                                          top: 1,
                                          right: 0,
                                          child: Text(CustomNumberUtil.calCount(tweet!.praise!, zeroEmpty: true),
                                              style: const TextStyle(color: Colors.grey, fontSize: 11)))
                                    ]))
                              ])),
                    ),
                  );
                })),
      )
    ];
  }

  List<Widget> _sliverBuilderEmpty(BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      SliverAppBar(
          backgroundColor: Colours.getScaffoldColor(context),
          centerTitle: true,
          leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.arrow_back, color: Colours.getEmphasizedTextColor(context), size: 20)),
          //标题居中
          title: Text('动态详情',
              style:
                  TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colours.getEmphasizedTextColor(context))),
          elevation: 0.2,
          floating: true,
          pinned: true,
          snap: false)
    ];
  }

  @override
  bool get wantKeepAlive => true;

  _refresh(Function f) {
    setState(() {
      f();
    });
  }
}
