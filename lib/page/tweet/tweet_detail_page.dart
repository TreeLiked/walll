import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:wall/api/tweet_api.dart';
import 'package:wall/config/routes/routes.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/constant/gap_constant.dart';
import 'package:wall/constant/text_constant.dart';
import 'package:wall/model/biz/common/gender.dart';
import 'package:wall/model/biz/tweet/tweet.dart';
import 'package:wall/model/biz/tweet/tweet_account.dart';
import 'package:wall/model/biz/tweet/tweet_reply.dart';
import 'package:wall/model/biz/tweet/tweet_type.dart';
import 'package:wall/util/fluro_convert_utils.dart';
import 'package:wall/util/navigator_util.dart';
import 'package:wall/util/theme_util.dart';
import 'package:wall/util/time_util.dart';
import 'package:wall/util/toast_util.dart';
import 'package:wall/util/umeng_util.dart';
import 'package:wall/widget/common/account_avatar.dart';
import 'package:wall/widget/tweet/tweet_body_wrapper.dart';
import 'package:wall/widget/tweet/tweet_detail_item_header.dart';
import 'package:wall/widget/tweet/tweet_interact_wrapper.dart';
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

class _TweetDetailPageState extends State<TweetDetailPage> with AutomaticKeepAliveClientMixin<TweetDetailPage> {
  late BuildContext _context;

  BaseTweet? tweet;
  Future? _getPraiseTask;

  Future? _getReplyTask;

  // 回复相关
  bool isDark = false;

  @override
  void initState() {
    super.initState();
    UMengUtil.userGoPage(widget.fromHot ? UMengUtil.pageTweetIndexDetailHot : UMengUtil.pageTweetIndexDetail);

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _fetchTweetIfNullAndFetchExtra();
    });
  }

  _fetchTweetIfNullAndFetchExtra() async {
    print(widget.tweet == null);
    print('----------------------');
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
          body: Column(
        children: <Widget>[
          Container(
            height: 80,
            alignment: Alignment.topCenter,
            child: const SpinKitDancingSquare(color: Colors.lightGreen, size: 20),
          )
        ],
      ));
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
            body: SingleChildScrollView(
                child: Container(
              decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(18))),
              padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0, bottom: 50.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildHeader(),
                  Gaps.vGap10,
                  TweetBodyWrapper(tweet!.body, height: 2.0, selectable: true),
                  TweetMediaWrapper(tweet: tweet!),
                  // widget.newLink
                  //     ? TweetLinkWrapper2(widget.tweet, _getLinkTask, fromHot: widget._fromHot)
                  //     : TweetLinkWrapper(tweet),
                  // Gaps.vGap8,
                  // _viewContainer(),
                  TweetInteractWrapper(tweet!),
                  Gaps.vGap15,
                  Divider(),
                  Gaps.vGap10,
                  // _praiseWrapper(context),
                  // TweetPraiseWrapper2(praiseAccounts),
                  // _replyWrapper(context),
                  // TweetReplyWrapper(tweet, replies, (TweetReply tr, String tarAccNick, String tarAccId) {
                  //   String hintText = "回复：$tarAccNick";
                  //   if (tweet.anonymous && tarAccId == tweet.account.id) {
                  //     hintText = "回复：作者";
                  //   }
                  //   showBottomSheetReplyContainer(2, false, hintText, (String value, bool anonymous) {
                  //     TweetReply reply = TRUtil.assembleReply(tweet, value, false, false,
                  //         parentId: tr.parentId, tarAccountId: tarAccId);
                  //     reply.sentTime = DateTime.now();
                  //     TRUtil.publicReply(context, reply,
                  //         (bool success, TweetReply newReply) => this.handleSendResult(success, newReply));
                  //   });
                  // }, () {
                  //   setState(() {
                  //     _getReplyTask = getTweetReply();
                  //   });
                  // }),
                ],
              ),
            ))),
      );
    }));
  }

  List<Widget> _sliverBuilder(BuildContext context, bool innerBoxIsScrolled) {
    Color c = Colours.getEmphasizedTextColor(context);
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
        // backgroundColor: widget._fromHot
        //     ? (isDark ? Colours.dark_bg_color : Color(0xfffDfDfD))
        //     : (isDark ? Colours.dark_bg_color : null),
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
            GestureDetector(onTap: () => Navigator.pop(context), child: Icon(Icons.arrow_back, color: c, size: 20)),
        // bottom: widget._fromHot
        //     ? PreferredSize(
        //   preferredSize: Size.fromHeight(60),
        //   child: Container(
        //       height: 60,
        //       child: Align(
        //         alignment: Alignment.center,
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           crossAxisAlignment: CrossAxisAlignment.center,
        //           children: <Widget>[
        //             RichText(
        //                 text: TextSpan(children: [
        //                   TextSpan(
        //                       text: '当前热门榜：',
        //                       style: TextStyle(
        //                           fontSize: Dimens.font_sp16,
        //                           color: ThemeUtils.isDark(context)
        //                               ? Colors.grey
        //                               : Colors.black)),
        //                   TextSpan(
        //                       text: 'No. ',
        //                       style: TextStyle(
        //                           fontSize: Dimens.font_sp16,
        //                           color: ThemeUtils.isDark(context)
        //                               ? Colors.grey
        //                               : Colors.black)),
        //                   TextSpan(
        //                       text: '${widget.hotRank}  ',
        //                       style: TextStyle(
        //                           fontSize: Dimens.font_sp16,
        //                           color: widget.hotRank < 5
        //                               ? Colors.redAccent
        //                               : (ThemeUtils.isDark(context)
        //                               ? Colors.grey
        //                               : Colors.black)))
        //                 ])),
        //             getFires(widget.hotRank),
        //           ],
        //         ),
        //       )),
        // )
        //     : null,
      )
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
