import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wall/application.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/page/tweet/tweet_index_hot_tab.dart';
import 'package:wall/page/tweet/tweet_index_live_tab.dart';
import 'package:wall/provider/account_local_provider.dart';
import 'package:wall/provider/msg_provider.dart';
import 'package:wall/provider/tweet_provider.dart';
import 'package:wall/util/perm_util.dart';
import 'package:wall/util/theme_util.dart';
import 'package:wall/util/umeng_util.dart';

class TweetIndexPage extends StatefulWidget {
  final ScrollController scrollController;

  const TweetIndexPage({Key? key, required this.scrollController}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TweetIndexPageState();
  }
}

class _TweetIndexPageState extends State<TweetIndexPage>
    with AutomaticKeepAliveClientMixin<TweetIndexPage>, SingleTickerProviderStateMixin {
  bool isDark = false;

  late TabController _tabController;

  late BuildContext _myContext;

  int _currentNavIndex = 0;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(() {
      _handleNavChanged(_tabController.index);
    });

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

  @override
  void dispose() {
    super.dispose();
  }

  //设定Widget的偏移量
  Offset floatingOffset = Offset(20, Application.screenHeight! - 180);
  double middle = Application.screenWidth! / 2;
  bool stickLeft = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _myContext = context;
    isDark = ThemeUtil.isDark(context);

    return Consumer<MsgProvider>(builder: (_, msgProvider, __) {
      return Scaffold(
        backgroundColor: Colours.lightScaffoldColor,
          appBar: PreferredSize(
            child:
                AppBar(elevation: 0, backgroundColor: isDark ? Colours.darkScaffoldColor : Colours.lightScaffoldColor),
            preferredSize: Size.zero,
          ),
          body: SafeArea(
              bottom: false,
              child: Stack(children: <Widget>[
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          color: Colours.getScaffoldColor(context),
                          padding: const EdgeInsets.only(bottom: 5.0),
                          width: double.infinity,
                          child: Stack(children: <Widget>[
                            Container(
                                alignment: Alignment.centerLeft,
                                child: TabBar(
                                    labelStyle: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.amber[600],
                                        letterSpacing: 1.1),
                                    unselectedLabelStyle: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colours.secondaryFontColor,
                                        letterSpacing: 1.1),
                                    indicatorSize: TabBarIndicatorSize.label,
                                    indicator: const UnderlineTabIndicator(
                                        insets: EdgeInsets.symmetric(horizontal: 10.0),
                                        borderSide: BorderSide(color: Colours.mainColor, width: 2.5)),
                                    controller: _tabController,
                                    labelColor: Colours.getEmphasizedTextColor(context),
                                    isScrollable: true,
                                    labelPadding: const EdgeInsets.only(left: 10.0, right: 6.0),
                                    tabs: const [
                                      Padding(padding: EdgeInsets.only(bottom: 6.0), child: Text('最新')),
                                      Padding(padding: EdgeInsets.only(bottom: 6.0), child: Text('热门'))
                                    ]))
                          ])),
                      Expanded(
                          child: TabBarView(controller: _tabController, children: [
                        TweetIndexLiveTab(scrollController: widget.scrollController),
                        TweetIndexHotTab()
                      ]))
                    ])
              ])));
    });
  }

  void _handleNavChanged(index) {
    if (index != _currentNavIndex) {
      setState(() {
        _currentNavIndex = index;
      });
    } else {
      if (index == 0) {
        _goTopForTweet();
      }
    }
  }

  _goTopForTweet() {
    widget.scrollController.animateTo(.0, duration: const Duration(milliseconds: 1688), curve: Curves.easeInOutQuint);
  }

  @override
  bool get wantKeepAlive => true;
}
