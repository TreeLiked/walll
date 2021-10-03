import 'dart:ui';

import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:wall/api/member_api.dart';
import 'package:wall/constant/app_constant.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/constant/gap_constant.dart';
import 'package:wall/constant/url_constant.dart';
import 'package:wall/model/biz/account/account_display_info.dart';
import 'package:wall/model/biz/common/gender.dart';
import 'package:wall/page/image_hero_page.dart';
import 'package:wall/util/asset_util.dart';
import 'package:wall/util/navigator_util.dart';
import 'package:wall/util/theme_util.dart';
import 'package:wall/util/umeng_util.dart';
import 'package:wall/widget/common/account_avatar.dart';
import 'package:wall/widget/common/account_avatar_2.dart';
import 'package:wall/widget/common/sticky_row_delegate.dart';

import '../../application.dart';

class AccountProfileIndex extends StatefulWidget {
  final String nick;
  final String avatarUrl;
  final String accountId;

  AccountProfileIndex(this.accountId, this.nick, this.avatarUrl);

  @override
  State<StatefulWidget> createState() {
    return _AccountProfileIndexState();
  }
}

class _AccountProfileIndexState extends State<AccountProfileIndex> {
  late Function _getProfileTask;
  late Function _onLoadHisTweet;

  String url = 'https://tva1.sinaimg.cn/large/008i3skNgy1gusyaltieej60u00u0q6202.jpg';

  AccountDisplayInfo? account;

  bool _initTweet = true;
  bool _initAccount = true;

  // EasyRefreshController _hisTweetController;
  bool display = false;

  // List<BaseTweet> _accountTweets;
  int _currentPage = 1;

  late bool isDark;

  Color lightBg = Colours.borderColorFirst;
  Color darkBg = Colours.darkScaffoldColor;

  @override
  void initState() {
    super.initState();
    // _loadProfileInfo();
    // _initRefresh();
    // _hisTweetController = EasyRefreshController();
    // _onLoadHisTweet = _loadMoreData;
    UMengUtil.userGoPage(UMengUtil.pageAccountProfile);
  }

  // void _loadProfileInfo() async {
  //   AccountDisplayInfo? account = await MemberApi.getAccountDisplayProfile(widget.accountId);
  //   setState(() {
  //     _initAccount = false;
  //     this.account = account;
  //   });
  // }
  //
  // Future<List<BaseTweet>> _getTweets() async {
  //   List<BaseTweet> tweets = await TweetApi.queryOtherTweets(
  //       PageParam(_currentPage, pageSize: 5), widget.accountId);
  //   return tweets;
  // }
  //
  // Future<void> _initRefresh() async {
  //   setState(() {
  //     _currentPage = 1;
  //   });
  //   List<BaseTweet> tweets = await _getTweets();
  //   if (!CollectionUtil.isListEmpty(tweets)) {
  //     _currentPage++;
  //     setState(() {
  //       if (_accountTweets == null) {
  //         _accountTweets = List();
  //       }
  //       this._initTweet = false;
  //       this._accountTweets.addAll(tweets);
  //     });
  //     _hisTweetController.finishRefresh(success: true, noMore: false);
  //   } else {
  //     setState(() {
  //       // if (_accountTweets == null) {
  //       //   _accountTweets = List();
  //       // }
  //       this._initTweet = false;
  //     });
  //     _hisTweetController.finishRefresh(success: true, noMore: true);
  //   }
  // }
  //
  // void _loadMoreData() async {
  //   List<BaseTweet> tweets = await _getTweets();
  //   if (!CollectionUtil.isListEmpty(tweets)) {
  //     _currentPage++;
  //     setState(() {
  //       this._accountTweets.addAll(tweets);
  //     });
  //     _hisTweetController.finishLoad(success: true, noMore: false);
  //   } else {
  //     _hisTweetController.finishLoad(success: true, noMore: true);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    isDark = ThemeUtil.isDark(context);

    return Scaffold(
      body: Stack(children: [
        NestedScrollView(
            // physics: const BouncingScrollPhysics(),
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return [
                _mySliverAppBar(),
                SliverList(
                  ///懒加载代理
                  delegate: SliverChildBuilderDelegate((BuildContext context, num index) {
                    ///子Item的布局
                    return Container(
                      height: 44,
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text("item- $index"),
                    );
                  }, childCount: 100), //子Item的个数
                ),
                // SliverPersistentHeader(
                //     delegate: StickyRowDelegate(
                //   children: [Text('123')],
                //   height: 200,
                // )),
                // SliverFillRemaining(
                //     child: Container(
                //   width: double.infinity,
                //   color: isDark ? darkBg : lightBg,
                //   child: Column(
                //     mainAxisSize: MainAxisSize.max,
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     children: [
                //       Gaps.vGap60,
                //       Text(widget.nick,
                //           maxLines: 1,
                //           textAlign: TextAlign.center,
                //           overflow: TextOverflow.ellipsis,
                //           style: TextStyle(
                //               fontSize: 22.0,
                //               fontWeight: FontWeight.bold,
                //               color: Colours.emphasizeFontColor)),
                //       Gaps.vGap10,
                //       Text("计算机工程学院 软件161 23",
                //           style: TextStyle(fontSize: 14, color: Colours.secondaryFontColor)),
                //     ],
                //   ),
                // ))
              ];
            },
            // body: Gaps.empty,
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                    child: Container(
                  // margin: const EdgeInsets.only(top: 300.0),
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Gaps.vGap60,
                        Text(widget.nick,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 22.0, fontWeight: FontWeight.bold, color: Colours.emphasizeFontColor)),
                        Gaps.vGap10,
                        Text("计算机工程学院 软件161 23", style: TextStyle(fontSize: 14, color: Colours.secondaryFontColor)),
                      ]),
                  // AccountAvatar2(avatarUrl: widget.avatarUrl)
                  // child: ListView.builder(
                  //   itemBuilder: (BuildContext context, int index) {
                  //     return ListTile(
                  //       title: Text("标题$index"),
                  //     );
                  //   },
                  //   itemCount: 50,
                  // ),
                ))
              ],
            )),
        // Positioned(
        //     child: AccountAvatar2(
        //       avatarUrl: widget.avatarUrl,
        //       size: 80,
        //       gender: Gender.female,
        //       borderColor: isDark ? darkBg : lightBg,
        //       onTap: () => Navigator.of(context).push(MaterialPageRoute(
        //           builder: (context) {
        //             return ImageHeroPage(url: widget.avatarUrl);
        //           },
        //           fullscreenDialog: true)),
        //     ),
        //     left: (Application.screenWidth! - 84) / 2,
        //     top: 265)
      ]),
    );
  }

  _mySliverAppBar() {
    return SliverAppBar(
        expandedHeight: 250,
        pinned: false,
        snap: true,
        floating: true,
        collapsedHeight: 250,
        flexibleSpace: FlexibleSpaceBar(
          background: Stack(children: <Widget>[
            // Utils.showNetImage(
            //   widget.avatarUrl,
            //   width: double.infinity,
            //   height: double.infinity,
            //   fit: BoxFit.cover,
            // ),
            Image.network(
              widget.avatarUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaY: 0,
                sigmaX: 0,
              ),
              child: Container(
                decoration: BoxDecoration(color: Colors.black12),
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ]),
          // background:
          // centerTitle: true,
          // title: _getHeader(context),

          collapseMode: CollapseMode.none,
        ),
        actions: const [Icon(Icons.settings, color: Colors.white, size: 25), Gaps.hGap10],
        leading: InkWell(
            child: const Icon(Icons.close, color: Colors.white, size: 25),
            onTap: () => NavigatorUtils.goBack(context)));
  }

  _getHeader(context) {
    ///向上偏移 -30 位置
    return Transform.translate(
        filterQuality: FilterQuality.high,
        offset: Offset(0, 35),
        child: AccountAvatar2(avatarUrl: widget.avatarUrl, size: 50));

    ///圆形头像还可以 CircleAvatar， ClipOval等实现
  }
}
