import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:wall/api/account_relation_api.dart';
import 'package:wall/api/tweet_api.dart';
import 'package:wall/application.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/constant/gap_constant.dart';
import 'package:wall/constant/shared_constant.dart';
import 'package:wall/constant/text_constant.dart';
import 'package:wall/model/biz/tweet/tweet.dart';
import 'package:wall/model/biz/tweet/tweet_reply.dart';
import 'package:wall/model/biz/tweet/tweet_type.dart';
import 'package:wall/model/response/result.dart';
import 'package:wall/page/tweet/tweet_detail_comment_tab.dart';
import 'package:wall/page/tweet/tweet_detail_praise_tab.dart';
import 'package:wall/provider/tweet_provider.dart';
import 'package:wall/util/bottom_sheet_util.dart';
import 'package:wall/util/common_util.dart';
import 'package:wall/util/custom_number_util.dart';
import 'package:wall/util/navigator_util.dart';
import 'package:wall/util/str_util.dart';
import 'package:wall/util/theme_util.dart';
import 'package:wall/util/toast_util.dart';
import 'package:wall/util/tweet_reply_util.dart';
import 'package:wall/util/umeng_util.dart';
import 'package:wall/widget/common/dialog/bottom_cancel_confirm.dart';
import 'package:wall/widget/common/sliver/sliver_header_delegate.dart';
import 'package:wall/widget/tweet/tweet_body_wrapper.dart';
import 'package:wall/widget/tweet/tweet_detail_bottom_comment_wrapper.dart';
import 'package:wall/widget/tweet/tweet_detail_item_header.dart';
import 'package:wall/widget/tweet/tweet_media_wrapper.dart';

class TweetDetailPage extends StatefulWidget {
  final int tweetId;
  late BaseTweet? tweet;

  // 是否从热门进入
  final bool fromHot;

  // 删除回调
  final Function? onDelete;

  // 是否右上角可以进行推文的操作，例如屏蔽等，除了首页目前都不可以操作
  final String source;

  TweetDetailPage({Key? key, required this.tweetId, this.tweet, this.onDelete, this.fromHot = false, this.source = "2"})
      : super(key: key);

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

  // 回复相关
  bool isDark = false;

  final GlobalKey<TweetDetailPraiseTabState> _praiseTabKey = GlobalKey();
  final GlobalKey<TweetDetailCommentTabState> _commentTabKey = GlobalKey();

  // 回复类型
  int _replyType = 1;
  String _hintText = TextCst.defaultTweetReplyHint;

  // 回复框焦点
  final FocusNode _focusNode = FocusNode();

  // 子回复的目标账户
  String? _replyTarAccountId;
  int? _replyParentId;

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
    _refresh(() {
      tweet = bt;
    });
    // _commentTabKey.currentState!.outerCallRefresh(null, reloadReply: true);

  }

  Widget _buildHeader() {
    return TweetDetailItemHeader(tweet!);
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
                    child: const SpinKitDancingSquare(color: Colors.lightGreen, size: 20))
              ])));
    }

    return Scaffold(
        // backgroundColor: !isDark
        //     ? (widget._fromHot ? Color(0xffe9e9e9) : null)
        //     : (widget._fromHot ? Color(0xff2c2c2c) : Colours.dark_bg_color),
        // backgroundColor: !isDark ? null : Colours.dark_bg_color,
        body: Stack(children: [
      Listener(
        onPointerDown: (_) => _resetReply(),
        onPointerMove: (_) => _resetReply(),
        child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => _sliverBuilder(context, innerBoxIsScrolled),
            body: Padding(
                padding: EdgeInsets.only(left: 10.0, top: 40, bottom: 60 + MediaQuery.of(context).padding.bottom),
                child: TabBarView(controller: _praiseCommentTabController, children: [
                  TweetDetailCommentTab(tweet!, key: _commentTabKey, onTapReply: (TweetReply reply) {
                    setState(() {
                      _hintText = '回复${reply.account!.nick}';
                      _replyType = 2;
                      _replyTarAccountId = reply.account!.id;
                      // 应该使用子回复的parentId
                      _replyParentId = reply.type == 1 ? reply.id : reply.parentId;
                      _focusNode.requestFocus();
                    });
                  }),
                  TweetDetailPraiseTab(tweet!, key: _praiseTabKey)
                ]))),
      ),
      Positioned(
          left: 0,
          bottom: 0,
          child: TweetDetailBottomCommentWrapper(
              hintText: _hintText, valueCallback: (commentStr) => _onSendReply(commentStr), focusNode: _focusNode))
    ]));
  }

  void _resetReply() {
    setState(() {
      _hintText = TextCst.defaultTweetReplyHint;
      _replyType = 1;
      _focusNode.unfocus();
    });
  }

  void _onSendReply(String body) async {
    if (StrUtil.isEmpty(body)) {
      _focusNode.unfocus();
      return;
    }
    var assembleReply = TRUtil.assembleReply(tweet!, body, false, _replyType == 1,
        parentId: _replyParentId, tarAccountId: _replyTarAccountId);
    TRUtil.publicReply(_context, assembleReply, (successFlag, data) {
      if (successFlag) {
        _focusNode.unfocus();
        if (widget.source == "1") {
          Provider.of<TweetProvider>(context, listen: false).updateReply(_context, data);
          _commentTabKey.currentState!.outerCallRefresh(data, reloadReply: false);
        } else {
          _commentTabKey.currentState!.outerCallRefresh(data, reloadReply: true);
        }
      } else {
        _focusNode.requestFocus();
        ToastUtil.showToast(_context, data);
      }
    });
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
            widget.source == "1"
                ? IconButton(
                    icon: Icon(Icons.more_horiz, color: c, size: 20),
                    onPressed: () {
                      bool myTweet = Application.getAccountId! == tweet!.account!.id;
                      if (myTweet) {
                        return;
                      }
                      BottomSheetUtil.showBottomSheetView(context, [
                        BottomSheetItem(const Icon(Icons.do_not_disturb_alt, color: Colors.blueGrey), '屏蔽此内容', () {
                          NavigatorUtils.goBack(context);
                          _showShieldedBottomSheet(context);
                        }),
                        BottomSheetItem(const Icon(Icons.do_not_disturb_on, color: Colors.orangeAccent), '屏蔽此人', () {
                          NavigatorUtils.goBack(context);
                          _showShieldedAccountBottomSheet(context);
                        })
                      ]);
                    },
                  )
                : Gaps.empty
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

  _showShieldedAccountBottomSheet(BuildContext _context) async {
    BottomSheetUtil.showBottomSheet(
        _context,
        0.3,
        BottomLeftRightDialog(
            title: '确认屏蔽此用户',
            content: '屏蔽后此用户的所有内容将对您不可见，此操作暂时无法恢复',
            rightText: '确认',
            onClickLeft: () => NavigatorUtils.goBack(_context),
            rightBgColor: Colors.orangeAccent,
            onClickRight: () async {
              Util.showDefaultLoadingWithBounds(_context);
              Result r = await AccountRelaApi.unlikeAccount(tweet!.account!.id.toString());
              NavigatorUtils.goBack(_context, len: 2);
              if (r.isSuccess) {
                final _tweetProvider = Provider.of<TweetProvider>(_context, listen: false);
                _tweetProvider.delete(tweet!.id!);
                NavigatorUtils.goBack(_context, len: 1);
              } else {
                ToastUtil.showToast(_context, "用户屏蔽失败");
              }
            }));
  }

  _showShieldedBottomSheet(BuildContext _context) async {
    BottomSheetUtil.showBottomSheet(
        _context,
        0.3,
        BottomLeftRightDialog(
            title: '',
            content: '屏蔽此条内容，屏蔽后我们将会减少类似推荐',
            rightText: '确认',
            onClickLeft: () => NavigatorUtils.goBack(_context),
            rightBgColor: Colors.blueGrey,
            onClickRight: () async {
              Util.showDefaultLoadingWithBounds(_context);
              List<String> unlikeList = SpUtil.getStringList(SharedCst.unLikeTweetIds, defValue: []) ?? [];

              unlikeList.add(tweet!.id.toString());
              await SpUtil.putStringList(SharedCst.unLikeTweetIds, unlikeList);

              final _tweetProvider = Provider.of<TweetProvider>(_context, listen: false);
              _tweetProvider.delete(tweet!.id!);
              NavigatorUtils.goBack(_context, len: 3);
            }));
  }
}
