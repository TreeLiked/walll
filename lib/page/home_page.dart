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

  // menu float choice
  GlobalKey _menuKey = GlobalKey();

  bool isDark = false;

  int count = 1;

  late TabController _tabController;

  int _currentTabIndex = 0;
  bool _displayCreate = true;

  late BuildContext _myContext;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
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
        if (_displayCreate != _dc) {
          setState(() {
            _displayCreate = _dc;
          });
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
    List<BaseTweet> pbt =
        await (TweetApi.queryTweets(PageParam(page, pageSize: 10, orgId: Application.getOrgId)));
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
        appBar: PreferredSize(
          child: AppBar(
            elevation: 0,
            backgroundColor: isDark ? Colours.darkScaffoldColor : Colours.lightScaffoldColor,
          ),
          preferredSize: Size.zero,
        ),
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    // color: isDark ? ColorConstant.MAIN_BG_DARK : ThemeConstant.lightBG,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          left: prefix0.ScreenUtil().setWidth(10.0),
                          child: Consumer<AccountLocalProvider>(
                            builder: (_, model, __) {
                              var acc = model.account;
                              return InkWell(
                                child: AccountAvatar(avatarUrl: acc!.avatarUrl!, size: 35.0, cache: true)
                              );
                              // return IconButton(
                              //     iconSize: 35,
                              //     onPressed: () {
                              //       BottomSheetUtil.showBottomSheet(context, 0.7, PersonalCenter());
                              //       UMengUtil.userGoPage(UMengUtil.PAGE_PC);
                              //     },
                              //     icon: AccountAvatar(
                              //         avatarUrl: acc.avatarUrl, size: 50.0, whitePadding: true, cache: true));
                            },
                          ),
                        ),
                        Container(
                          width: double.maxFinite,
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            child: TabBar(
                              labelStyle: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w400, color: Colors.amber[600]),
                              unselectedLabelStyle:
                                  TextStyle(fontSize: 14, color: isDark ? Colors.white24 : Colors.black),
                              indicatorSize: TabBarIndicatorSize.label,
                              indicator: const UnderlineTabIndicator(
                                  insets: EdgeInsets.symmetric(horizontal: 10.0),
                                  borderSide: BorderSide(color: Colours.mainColor, width: 4.0)),
                              controller: _tabController,
                              labelColor: isDark ? Colors.white : Colors.black,
                              isScrollable: true,
                              onTap: (index) {
                                if (index == _currentTabIndex) {
                                  if (index == 0) {
                                    if (msgProvider.tweetNewCnt > 0) {
                                      // PageSharedWidget.tabIndexRefreshController.requestRefresh();
                                      Provider.of<MsgProvider>(context, listen: false).updateTweetNewCnt(0);
                                    }
                                    // PageSharedWidget.homepageScrollController.animateTo(0.0,
                                    //     duration: Duration(milliseconds: 1688), curve: Curves.easeInOutQuint);
                                    return;
                                  }
                                }
                                _tabController.animateTo(index);
                                setState(() {
                                  _currentTabIndex = index;
//                              _displayCreate = _currentTabIndex == 0;
                                });
                              },
                              tabs: const [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text('推荐',
                                      style: TextStyle(
                                          fontSize: 17, letterSpacing: 1.2, fontWeight: FontWeight.w500)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text('热榜',
                                      style: TextStyle(
                                          fontSize: 17, letterSpacing: 1.2, fontWeight: FontWeight.w500)),
                                )
                                // Tab(
                                //     child: Text('热门',
                                //         style: TextStyle(
                                //             color: _getTabColor(1),
                                //             fontWeight: FontWeight.w500,
                                //             letterSpacing: 1.1))),
                                // Tab(child: Text('圈子', style: pfStyle.copyWith(color: _getTabColor(2)))),
                              ],
                            ),
                          ),
                        ),
                        // Positioned(
                        //     right: prefix0.ScreenUtil().setWidth(10.0),
                        //     child: IconButton(
                        //       icon: Badge(
                        //           elevation: 0,
                        //           child: LoadAssetIcon(
                        //             "notification/bell",
                        //             color: Utils.badgeHasData(msgProvider.totalCnt)
                        //                 ? Colors.amber
                        //                 : isDark
                        //                     ? Colors.white54
                        //                     : Colors.black87,
                        //             width: 25.0,
                        //             height: 25.0,
                        //           ),
                        //           badgeColor: Colors.red[400],
                        //           padding: EdgeInsets.all(msgProvider.totalCnt >= 10 ? 2 : 5),
                        //           animationType: BadgeAnimationType.fade,
                        //           showBadge: Utils.badgeHasData(msgProvider.totalCnt),
                        //           badgeContent: Utils.getRpWidget(msgProvider.totalCnt)),
                        //       onPressed: () => NavigatorUtils.push(context, Routes.notification),
                        //     )),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        TweetIndexTabView(),
                        TweetIndexTabView(),
                        // CircleMainNew()
                      ],
                    ),
                  ),
                ],
              ),
              _displayCreate
                  ? Positioned(
                      left: stickLeft ? 3.9 : null,
                      right: stickLeft ? null : 20,
                      top: floatingOffset.dy,
                      child: Container(
                        width: 55,
                        height: 55,
                        child: Draggable(
                          feedback: FloatingActionButton(
                              child: Container(
                                  width: 55,
                                  height: 55,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(27.5),
                                      gradient: new LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: isDark
                                              ? ([Colors.black26, Colors.black45])
                                              : [Color(0xffFFFFFF), Color(0xffdfe9f3)])),
                                  child: Icon(Icons.add,
                                      size: 28.0, color: isDark ? Colors.amber[300] : Colors.grey)),
                              backgroundColor: isDark ? Colors.black45 : Color(0xffF8F8FF),
                              splashColor: Colors.white12,
                              elevation: 10.0,
                              onPressed: null),
                          child: FloatingActionButton(
                              // child: Icon(
                              //   Icons.add,
                              //   color: isDark ? Colors.amber[300] : Colors.black,
                              // ),
                              child: Container(
                                  width: 55,
                                  height: 55,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(27.5),
                                      gradient: new LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: isDark
                                              ? ([Colors.black26, Colors.black45])
                                              : [Color(0xffFFFFFF), Color(0xffdfe9f3)])),
                                  child: Icon(Icons.add,
                                      size: 28.0, color: isDark ? Colors.amber[300] : Colors.amber[700])),
                              // child: LoadAssetIcon(
                              //   "create",
                              //   color: isDark ? Colors.yellow : Colors.lightBlueAccent,
                              //   width: 23.0,
                              //   height: 23.0,
                              // ),
                              // backgroundColor: isDark ? Colors.black45 : Color(0xffF8F8FF),
                              elevation: 10.0,
                              // foregroundColor: Colors.yellow,

                              splashColor: Colors.white12,
                              onPressed: () => NavigatorUtils.push(
                                  context,
                                  Routes.tweetCreate +
                                      FluroConvertUtils.assembleArgs({
                                        "type": 0,
                                        "title": "发布内容",
                                        "hintText": "分享校园新鲜事",
                                        "circleId": "-1"
                                      }),
                                  transitionType: TransitionType.fadeIn)),

                          //拖动过程中，在原来位置停留的Widget，设定这个可以保留原本位置的残影，如果不需要可以直接设置为Container()
                          childWhenDragging: Container(),
                          //拖动结束后的Widget
                          onDragEnd: (details) {
                            double targetX = details.offset.dx;
                            double targetY = details.offset.dy - 50;
                            if (targetY >= Application.screenHeight! - 190 || targetY <= 20) {
                              targetY = Application.screenHeight! - 190;
                            }
                            setState(() {
                              stickLeft = targetX < middle;
                              floatingOffset = new Offset(0.0, targetY);
                            });
                          },
                        ),
                      ))
                  : Gaps.empty,
            ],
          ),
        ),
      );
    });
  }

  Color _getTabColor(int index) {
    if (_currentTabIndex == index) {
      return isDark ? Colors.white : Colors.black;
    }
    return isDark ? Colors.white38 : Colors.black54;
  }

//   List<Widget> _sliverBuilder(BuildContext context, bool innerBoxIsScrolled) {
//     return <Widget>[
//       SliverAppBar(
//         centerTitle: true,
//         backgroundColor: isDark ? Colours.dark_bg_color : Color(0xfff4f5f6),
//         //标题居中
//
//         title: GestureDetector(
//             child: Text(
//               Application.getOrgName ?? TextConstant.TEXT_UN_CATCH_ERROR,
//               style: TextStyle(fontSize: Dimens.font_sp15, fontWeight: FontWeight.w400),
//             ),
//             onTap: () => PageSharedWidget.homepageScrollController
//                 .animateTo(.0, duration: Duration(milliseconds: 1688), curve: Curves.easeInOutQuint)),
//         elevation: 0.3,
//         actions: <Widget>[
//           IconButton(
//             icon: Icon(Icons.blur_on),
//             onPressed: () {
//               NavigatorUtils.push(context, Routes.square, transitionType: TransitionType.fadeIn);
//             },
//           ),
//           IconButton(
//               key: _menuKey,
//               icon: Icon(Icons.add),
//               onPressed: _showAddMenu,
//               color: ThemeUtils.getIconColor(context)),
//         ],
//
//         expandedHeight: 0,
//         // expandedHeight: SizeConstant.HP_COVER_HEIGHT,
//         // backgroundColor: GlobalConfig.DEFAULT_BAR_BACK_COLOR,
//         // backgroundColor: Colors.transparent,
//         floating: false,
//         pinned: true,
//         snap: false,
// //         flexibleSpace: FlexibleSpaceBar(
// //             background: CachedNetworkImage(
// //           imageUrl:
// //               'https://tva1.sinaimg.cn/large/00831rSTgy1gdf8bz0p5xj31hc0u0n01.jpgs',
// //           fit: BoxFit.cover,
// //         )),
//       ),
//     ];
//   }

  // _showAddMenu() {
  //   final RenderBox button = _menuKey.currentContext.findRenderObject();
  //   final RenderBox overlay = Overlay.of(context).context.findRenderObject();
  //   var a =
  //       button.localToGlobal(Offset(button.size.width - 8.0, button.size.height - 12.0), ancestor: overlay);
  //   var b = button.localToGlobal(button.size.bottomLeft(Offset(0, -12.0)), ancestor: overlay);
  //   final RelativeRect position = RelativeRect.fromRect(
  //     Rect.fromPoints(a, b),
  //     Offset.zero & overlay.size,
  //   );
  //   final Color backgroundColor = ThemeUtils.getBackgroundColor(context);
  //   final Color _iconColor = ThemeUtils.getIconColor(context);
  //   showPopupWindow(
  //       context: context,
  //       fullWidth: false,
  //       isShowBg: true,
  //       position: position,
  //       elevation: 0.0,
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.end,
  //         children: <Widget>[
  //           Padding(
  //             padding: const EdgeInsets.only(right: 12.0),
  //             child: LoadAssetIcon(
  //               "jt",
  //               width: 8.0,
  //               height: 4.0,
  //               color: ThemeUtils.getDarkColor(context, Colours.dark_bg_color),
  //             ),
  //           ),
  //           SizedBox(
  //             width: 120.0,
  //             height: 40.0,
  //             child: FlatButton.icon(
  //                 textColor: Theme.of(context).textTheme.headline6.color,
  //                 color: backgroundColor,
  //                 onPressed: () {
  //                   NavigatorUtils.goBack(context);
  //                   _forwardFilterPage();
  //                 },
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius:
  //                       BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
  //                 ),
  //                 icon: LoadAssetIcon(
  //                   "filter",
  //                   width: 16.0,
  //                   height: 16.0,
  //                   color: _iconColor,
  //                 ),
  //                 label: const Text("筛 选")),
  //           ),
  //           // Container(
  //           //   width: 120.0,
  //           //   height: 0.6,
  //           //   color: Colours.line,
  //           //   padding: EdgeInsets.symmetric(horizontal: 0),
  //           // ),
  //           // Gaps.vGap4,
  //           SizedBox(
  //             width: 120.0,
  //             height: 40.0,
  //             child: FlatButton.icon(
  //                 textColor: Theme.of(context).textTheme.headline6.color,
  //                 onPressed: () {
  //                   NavigatorUtils.goBack(context);
  //
  //                   NavigatorUtils.push(context, Routes.create, transitionType: TransitionType.fadeIn);
  //                   // NavigatorUtils.push(context, Routes.create,
  //                   //     transitionType: TransitionType.fadeIn);
  //                 },
  //                 color: backgroundColor,
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.only(
  //                       bottomLeft: const Radius.circular(8.0), bottomRight: const Radius.circular(8.0)),
  //                 ),
  //                 icon: LoadAssetIcon(
  //                   "create",
  //                   width: 16.0,
  //                   height: 16.0,
  //                   color: _iconColor,
  //                 ),
  //                 label: const Text("发 布")),
  //           ),
  //         ],
  //       ));
  // }

  @override
  bool get wantKeepAlive => true;
}
