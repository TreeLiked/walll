import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:fluro/fluro.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' as prefix0;
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:wall/api/tweet_api.dart';
import 'package:wall/application.dart';
import 'package:wall/config/routes/routes.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/constant/gap_constant.dart';
import 'package:wall/model/biz/common/page_param.dart';
import 'package:wall/model/biz/tweet/tweet.dart';
import 'package:wall/model/biz/tweet/tweet_reply.dart';
import 'package:wall/page/account/account_profile_index.dart';
import 'package:wall/page/tweet/tweet_index_hot_tab.dart';
import 'package:wall/page/tweet/tweet_index_live_tab.dart';
import 'package:wall/page/tweet/tweet_index_page.dart';
import 'package:wall/provider/account_local_provider.dart';
import 'package:wall/provider/msg_provider.dart';
import 'package:wall/provider/tweet_provider.dart';
import 'package:wall/util/asset_util.dart';
import 'package:wall/util/common_util.dart';
import 'package:wall/util/fluro_convert_utils.dart';
import 'package:wall/util/navigator_util.dart';
import 'package:wall/util/perm_util.dart';
import 'package:wall/util/theme_util.dart';
import 'package:wall/util/umeng_util.dart';
import 'package:wall/widget/common/account_avatar.dart';
import 'package:wall/widget/common/account_avatar_2.dart';

import 'account/account_my_index.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage>, SingleTickerProviderStateMixin {
  static const String _tag = "_HomePageState";

  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  // final commentWrapperKey = GlobalKey<HomeCommentWrapperState>();

  int _currentPage = 1;

  late AccountLocalProvider accountLocalProvider;
  late TweetProvider tweetProvider;

  // weather first build
  bool firstBuild = true;

  // touch position, for display or hide bottomNavigatorBar
  double startY = -1;
  double lastY = -1;

  bool isDark = false;

  late TabController _tabController;

  late BuildContext _myContext;

  int _currentNavIndex = 0;

  final List<Widget> _bottomNavPages = [];

  final Widget createWidgetLight = Transform.translate(
      offset: const Offset(0, 5),
      child: Container(
          padding: const EdgeInsets.all(7.0),
          width: 35,
          height: 35,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              gradient: const LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [Color(0xFFFFFFFF), Color(0xFF00f2fe), Color(0xFFFFFFFF)])),
          child: const LoadAssetSvg("nav/nav_create", width: 35, height: 35, color: Colors.white)));

  late ScrollController _tweetIndexController;

  @override
  void initState() {
    _tweetIndexController = ScrollController();

    _bottomNavPages.add(TweetIndexPage(scrollController: _tweetIndexController));
    _bottomNavPages.add(TweetIndexHotTab());
    _bottomNavPages.add(TweetIndexHotTab());
    _bottomNavPages.add(TweetIndexHotTab());
    _bottomNavPages.add(AccountMyIndex());

    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(() {
      if (_tabController.index.toDouble() == _tabController.animation!.value) {
        bool _dc = true;
        switch (_tabController.index) {
          case 0:
            _dc = true;
            break;
          case 1:
            _dc = true;
            break;
          case 2:
            _dc = false;
            break;
        }
      }
    });

    initMessageTotalCnt();

    UMengUtil.userGoPage(UMengUtil.pageTweetIndex);

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      Future.delayed(const Duration(seconds: 3)).then((value) {
        PermissionUtil.checkAndRequestNotification(context, showTipIfDetermined: true, probability: 39);
      });
    });

    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   Map<String, String> headers = {
    //     SharedConstant.AUTH_HEADER_VALUE: Application.getLocalAccountToken,
    //     SharedConstant.ORG_ID_HEADER_VALUE: Application.getOrgId.toString()
    //   };
    //   MessageUtil.setStompClient = StompClient(
    //       config: StompConfig(
    //           // url: 'ws://192.168.31.235:8088/wallServer',
    //           url: Api.API_BASE_WS,
    //           onConnect: (client, frame) {
    //             LogUtil.e('------------wall server connecting------------', tag: _tag);
    //             // 个人频道订阅
    //             client.subscribe(
    //                 destination: '/user/queue/myself',
    //                 headers: headers,
    //                 callback: (resp) {
    //                   Map<String, dynamic> jsonData = json.decode(resp.body);
    //                   ImDTO dto = ImDTO.fromJson(jsonData);
    //                   MessageUtil.handleInstantMessage(dto, context: context);
    //                 });
    //             // 大学内频道订阅
    //             client.subscribe(
    //                 destination: '/topic/org' + Application.getOrgId.toString(),
    //                 headers: headers,
    //                 callback: (resp) {
    //                   Map<String, dynamic> jsonData = json.decode(resp.body);
    //                   ImDTO dto = ImDTO.fromJson(jsonData);
    //                   MessageUtil.handleInstantMessage(dto, context: context);
    //                 });
    //           },
    //           onWebSocketError: (dynamic error) => ToastUtil.showToast(context, "连接服务器失败"),
    //           stompConnectHeaders: headers,
    //           webSocketConnectHeaders: headers));
    //   MessageUtil.stompClient.activate();

    // final channel = await IOWebSocketChannel.connect(Api.API_BASE_WS,
    //     headers: headers);
    //
    // // channel.sink.add('received!');
    // // channel.sink.addStream(Stream.value(""));
    //
    // channel.stream.listen((message) {
    //   print("接收到---" + message);
    //   // channel.sink.close(status.goingAway);
    // });
    // });
  }

  void initMessageTotalCnt() async {
    // MessageUtil.queryMessageCntTotal(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _onRefresh(BuildContext context) async {
    print('On refresh');
    _refreshController.resetNoData();
    _currentPage = 1;
    List<BaseTweet> temp = await getData(_currentPage);
    tweetProvider.update(temp, clear: true, append: false);
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

  Future getData(int page) async {
    List<BaseTweet> pbt = await (TweetApi.queryTweets(PageParam(page, pageSize: 10, orgId: Application.getOrgId)));
    return pbt;
  }

  /*
   * 显示回复框
   */
  void showReplyContainer(TweetReply tr, String destAccountNick, String destAccountId) {
    // commentWrapperKey.currentState.showReplyContainer(tr, destAccountNick, destAccountId);
  }

  /*
   * 监测滑动手势，隐藏回复框
   */
  void hideReplyContainer() {
    // commentWrapperKey.currentState.hideReplyContainer();
  }

  //设定Widget的偏移量
  Offset floatingOffset = Offset(20, Application.screenHeight! - 180);
  double middle = Application.screenWidth! / 2;
  bool stickLeft = false;

  @override
  Widget build(BuildContext context) {
    _myContext = context;
    super.build(context);
    isDark = ThemeUtil.isDark(context);

    accountLocalProvider = Provider.of<AccountLocalProvider>(context, listen: false);
    if (firstBuild) {
      initData();
      tweetProvider = Provider.of<TweetProvider>(context, listen: false);
    }
    firstBuild = false;

    return Consumer<MsgProvider>(builder: (_, msgProvider, __) {
      return Scaffold(
        // appBar: PreferredSize(
        //   child: AppBar(elevation: 0, backgroundColor: isDark ? Colours.darkScaffoldColor : Colours.lightScaffoldColor),
        //   preferredSize: Size.zero,
        // ),
        // body: SafeArea(
        //     bottom: false,
        //     child: Stack(children: <Widget>[
        //       Column(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           crossAxisAlignment: CrossAxisAlignment.center,
        //           children: <Widget>[
        //             Container(
        //               // height: 100,
        //               padding: const EdgeInsets.only(bottom: 5.0),
        //               width: double.infinity,
        //               // color: isDark ? ColorConstant.MAIN_BG_DARK : ThemeConstant.lightBG,
        //               child: Stack(
        //                 children: <Widget>[
        //                   Positioned(
        //                     left: prefix0.ScreenUtil().setWidth(10.0),
        //                     child: Consumer<AccountLocalProvider>(
        //                       builder: (_, model, __) {
        //                         var acc = model.account;
        //                         return InkWell(
        //                             child: AccountAvatar(avatarUrl: acc!.avatarUrl!, size: 35.0, cache: true));
        //                         // return IconButton(
        //                         //     iconSize: 35,
        //                         //     onPressed: () {
        //                         //       BottomSheetUtil.showBottomSheet(context, 0.7, PersonalCenter());
        //                         //       UMengUtil.userGoPage(UMengUtil.PAGE_PC);
        //                         //     },
        //                         //     icon: AccountAvatar(
        //                         //         avatarUrl: acc.avatarUrl, size: 50.0, whitePadding: true, cache: true));
        //                       },
        //                     ),
        //                   ),
        //                   Container(
        //                     width: double.maxFinite,
        //                     alignment: Alignment.center,
        //                     child: Padding(
        //                       padding: EdgeInsets.symmetric(horizontal: 0),
        //                       child: TabBar(
        //                         labelStyle:
        //                             TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.amber[600]),
        //                         unselectedLabelStyle:
        //                             TextStyle(fontSize: 14, color: isDark ? Colors.white24 : Colors.black),
        //                         indicatorSize: TabBarIndicatorSize.label,
        //                         indicator: const UnderlineTabIndicator(
        //                             insets: EdgeInsets.symmetric(horizontal: 10.0),
        //                             borderSide: BorderSide(color: Colours.mainColor, width: 4.0)),
        //                         controller: _tabController,
        //                         labelColor: isDark ? Colors.white : Colors.black,
        //                         isScrollable: true,
        //                         onTap: (index) {
        //
        //                         },
        //                         tabs: const [
        //                           Padding(
        //                             padding: const EdgeInsets.only(bottom: 8.0),
        //                             child: Text('推荐',
        //                                 style:
        //                                     TextStyle(fontSize: 17, letterSpacing: 1.2, fontWeight: FontWeight.w500)),
        //                           ),
        //                           Padding(
        //                             padding: const EdgeInsets.only(bottom: 8.0),
        //                             child: Text('热榜',
        //                                 style:
        //                                     TextStyle(fontSize: 17, letterSpacing: 1.2, fontWeight: FontWeight.w500)),
        //                           )
        //                           // Tab(
        //                           //     child: Text('热门',
        //                           //         style: TextStyle(
        //                           //             color: _getTabColor(1),
        //                           //             fontWeight: FontWeight.w500,
        //                           //             letterSpacing: 1.1))),
        //                           // Tab(child: Text('圈子', style: pfStyle.copyWith(color: _getTabColor(2)))),
        //                         ],
        //                       ),
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //             Expanded(
        //                 child: TabBarView(controller: _tabController, children: [
        //               TweetIndexLiveTab(),
        //               TweetIndexLiveTab(),
        //               // CircleMainNew()
        //             ]))
        //           ])
        //     ])),
        body: _bottomNavPages[_currentNavIndex],
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: MediaQuery.removePadding(
          context: context,
          // height: 83,
          // padding: EdgeInsets.all(0.0),
          child: BottomNavigationBar(
              iconSize: 30,
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              enableFeedback: true,
              selectedLabelStyle: const TextStyle(fontSize: 11.5),
              fixedColor: Colours.getEmphasizedTextColor(context),
              unselectedLabelStyle: const TextStyle(fontSize: 11.5),
              unselectedItemColor: Colours.greyText,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: _getIcon("nav_index", false), label: '首页', activeIcon: _getIcon("nav_index", true)),
                BottomNavigationBarItem(
                    icon: _getIcon("nav_cate", false), label: '分类', activeIcon: _getIcon("nav_cate", true)),
                BottomNavigationBarItem(
                    icon: isDark ? _getCreateWidgetDark() : createWidgetLight,
                    label: '',
                    activeIcon: isDark ? _getCreateWidgetDark() : createWidgetLight),
                BottomNavigationBarItem(
                    icon: _getIcon("nav_noti", false), label: '消息', activeIcon: _getIcon("nav_noti", true)),
                BottomNavigationBarItem(
                    icon: _getIcon("nav_my", false), label: '我的', activeIcon: _getIcon("nav_my", true)),
              ],
              currentIndex: _currentNavIndex,
              onTap: (index) => _handleNavChanged(context, index)),
        ),
      );
    });
  }

  Widget _getIcon(String oriName, bool isSel) {
    return LoadAssetSvg(
        "nav/$oriName${isSel ? '_sel' : isDark ? '_unsel_dark' : '_unsel'}",
        width: 30,
        height: 30);
  }

  Widget _getCreateWidgetDark() {
    return Transform.translate(
        offset: const Offset(0, 5),
        child: Container(
            padding: const EdgeInsets.all(7.0),
            width: 35,
            height: 35,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                gradient: const LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [Colors.white, Color(0xFF8AE1FC), Colors.white])),
            child: const LoadAssetSvg("nav/nav_create", width: 35, height: 35, color: Colors.white)));
  }

  void _handleNavChanged(BuildContext context, int index) {
    if (index == 2) {
      NavigatorUtils.push(context, Routes.tweetCreate,transitionType: TransitionType.inFromBottom);
      return;
    }
    if (index != _currentNavIndex) {
      setState(() {
        _currentNavIndex = index;
      });
    }
    if (index == 0) {
      _tweetIndexController.animateTo(.0, duration: const Duration(milliseconds: 1688), curve: Curves.easeInOutQuint);
    }
  }

  @override
  bool get wantKeepAlive => true;
}
