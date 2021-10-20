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
import 'package:wall/page/notification/notification_index_page.dart';
import 'package:wall/page/tweet/tweet_cate_page.dart';
import 'package:wall/page/tweet/tweet_cate_tab.dart';
import 'package:wall/page/tweet/tweet_index_hot_tab.dart';
import 'package:wall/page/tweet/tweet_index_live_tab.dart';
import 'package:wall/page/tweet/tweet_index_page.dart';
import 'package:wall/provider/account_local_provider.dart';
import 'package:wall/provider/msg_provider.dart';
import 'package:wall/provider/tweet_provider.dart';
import 'package:wall/util/asset_util.dart';
import 'package:wall/util/common_util.dart';
import 'package:wall/util/fluro_convert_utils.dart';
import 'package:wall/util/message_util.dart';
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

  late BuildContext _myContext;

  int _currentNavIndex = 0;
  final List<Widget> _bottomNavPages = [];
  late PageController _pageController;

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

  final GlobalKey<TweetIndexPageState> tweetIndexKey = GlobalKey();

  @override
  void initState() {
    _bottomNavPages.add(TweetIndexPage(key: tweetIndexKey));
    _bottomNavPages.add(const TweetCatePage());
    _bottomNavPages.add(const NotificationIndexPage());
    _bottomNavPages.add(const AccountMyIndexPage());
    _pageController = PageController(initialPage: _currentNavIndex);
    super.initState();

    UMengUtil.userGoPage(UMengUtil.pageTweetIndex);

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      Future.delayed(const Duration(seconds: 3)).then((value) {
        initMessageTotalCnt();
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
    MessageUtil.queryMessageCntTotal(_myContext);
  }

  @override
  void dispose() {
    super.dispose();
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
          backgroundColor: Colours.lightScaffoldColor,
          floatingActionButton: _currentNavIndex == 0 || _currentNavIndex == 1
              ? FloatingActionButton(
                  child: Container(
                      width: 55,
                      height: 55,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: Icon(Icons.add, size: 28.0, color: isDark ? Colors.white : Colors.black)),
                  backgroundColor: Colours.getScaffoldColor(context),
                  elevation: 20.0,
                  highlightElevation: 10.0,
                  isExtended: true,
                  enableFeedback: true,
                  onPressed: () =>
                      NavigatorUtils.push(context, Routes.tweetCreate, transitionType: TransitionType.inFromBottom))
              : null,
          body: PageView(
              children: _bottomNavPages, controller: _pageController, physics: const NeverScrollableScrollPhysics()),
          resizeToAvoidBottomInset: false,
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          bottomNavigationBar: MediaQuery.removePadding(
              context: context,
              child: Consumer<MsgProvider>(builder: (_, msgProvider, __) {
                return BottomNavigationBar(
                    iconSize: 30,
                    type: BottomNavigationBarType.fixed,
                    elevation: 0,
                    enableFeedback: true,
                    selectedLabelStyle: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                    fixedColor: Colours.getEmphasizedTextColor(context),
                    unselectedLabelStyle: const TextStyle(fontSize: 11.5),
                    unselectedItemColor: Colours.greyText,
                    items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                          icon: _getIcon("nav_index", false, 0, msgProvider),
                          label: '首页',
                          activeIcon: _getIcon("nav_index", true, 0, msgProvider)),
                      BottomNavigationBarItem(
                          icon: _getIcon("nav_cate", false, 1, msgProvider),
                          label: '分类',
                          activeIcon: _getIcon("nav_cate", true, 1, msgProvider)),
                      // BottomNavigationBarItem(
                      //     icon: isDark ? _getCreateWidgetDark() : createWidgetLight,
                      //     label: '',
                      //     activeIcon: isDark ? _getCreateWidgetDark() : createWidgetLight),
                      BottomNavigationBarItem(
                          icon: _getIcon("nav_noti", false, 2, msgProvider),
                          label: '消息',
                          activeIcon: _getIcon("nav_noti", true, 2, msgProvider)),
                      BottomNavigationBarItem(
                          icon: _getIcon("nav_my", false, 3, msgProvider),
                          label: '我的',
                          activeIcon: _getIcon("nav_my", true, 3, msgProvider)),
                    ],
                    currentIndex: _currentNavIndex,
                    onTap: (index) => _handleNavChanged(context, index));
              })));
    });
  }

  Widget _getIcon(String oriName, bool isSel, int index, MsgProvider provider) {
    if (index == 1 || index == 3) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 3.0),
        child: LoadAssetSvg(
            "nav/$oriName",
            width: 25,
            color: isSel ? Colours.getEmphasizedTextColor(_myContext) : Colors.grey,
            height: 25),
      );
    } else if (index == 0) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 3.0),
        child: LoadAssetSvg(
            "nav/$oriName",
            width: 25,
            color: isSel ? Colours.getEmphasizedTextColor(_myContext) : Colors.grey,
            height: 25),
      );
    } else if (index == 2) {
      return Badge(
          elevation: 1,
          shape: BadgeShape.circle,
          showBadge: Util.badgeHasData(provider.totalCnt),
          badgeColor: Colors.red,
          animationType: BadgeAnimationType.fade,
          badgeContent: Util.getRpWidget(provider.totalCnt, fontSize: 8.0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 3.0),
            child: LoadAssetSvg("nav/$oriName",
                width: 25, color: isSel ? Colours.getEmphasizedTextColor(_myContext) : Colors.grey, height: 25),
          ));
    }
    return Gaps.empty;
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
    if (index != _currentNavIndex) {
      setState(() {
        _currentNavIndex = index;
        _pageController.jumpToPage(index);
      });
    } else {
      if (index == 0) {
        if (tweetIndexKey.currentState != null) {
          tweetIndexKey.currentState!.goTopForTweet(null);
        }
      }
    }
  }

  @override
  bool get wantKeepAlive => true;
}
