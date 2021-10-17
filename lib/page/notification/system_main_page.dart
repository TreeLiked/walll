import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wall/api/message_api.dart';
import 'package:wall/constant/gap_constant.dart';
import 'package:wall/model/biz/message/asbtract_message.dart';
import 'package:wall/util/theme_util.dart';
import 'package:wall/widget/common/custom_app_bar.dart';
import 'package:wall/widget/notification/system_msg_item.dart';

class SystemNotificationMainPage extends StatefulWidget {
  const SystemNotificationMainPage({Key? key}) : super(key: key);

  @override
  _SystemNotificationMainPageState createState() => _SystemNotificationMainPageState();
}

class _SystemNotificationMainPageState extends State<SystemNotificationMainPage> {
  bool isDark = false;

  final RefreshController _refreshController = RefreshController(initialRefresh: true);
  int currentPage = 1;
  int pageSize = 25;

  List<AbstractMessage>? sysMsgs;

  @override
  void initState() {
    super.initState();
  }

  void _fetchSystemMessages() async {
    currentPage = 1;
    List<AbstractMessage> msgs = await getData(1, pageSize);
    if (msgs.isEmpty) {
      _refreshController.refreshCompleted(resetFooterState: true);
      setState(() {
        sysMsgs = [];
      });
      return;
    }

    setState(() {
      if (sysMsgs != null) {
        sysMsgs!.clear();
      } else {
        sysMsgs = [];
      }
      sysMsgs!.addAll(msgs);
    });
    _refreshController.refreshCompleted(resetFooterState: true);
  }

  void _loadMore() async {
    List<AbstractMessage> msgs = await getData(++currentPage, pageSize);
    if (msgs.isEmpty) {
      _refreshController.loadNoData();
      return;
    }
    setState(() {
      sysMsgs ??= [];
      sysMsgs!.addAll(msgs);
    });
    _refreshController.loadComplete();
  }

  Future<List<AbstractMessage>> getData(int currentPage, int pageSize) async {
    return await MessageApi.querySystemMsg(currentPage, pageSize);
  }

  @override
  Widget build(BuildContext context) {
    isDark = ThemeUtil.isDark(context);
    return Scaffold(
//        backgroundColor: isDark ? Colours.dark_bg_color : Colours.bg_color,
        appBar: const CustomAppBar(title: "官方通知", isBack: true),
        body: SafeArea(
            top: false,
            child: SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                enablePullUp: true,
                header: const WaterDropHeader(waterDropColor: Colors.amber, complete: Text('刷新完成')),
                footer: const ClassicFooter(
                    loadingText: '正在加载更多消息...', canLoadingText: '释放以加载更多', noDataText: '没有更多消息了', idleText: '继续上滑'),
                onLoading: _loadMore,
                onRefresh: _fetchSystemMessages,
                child: sysMsgs == null
                    ? Gaps.empty
                    : sysMsgs!.isEmpty
                        ? Container(
                            alignment: Alignment.topCenter,
                            margin: const EdgeInsets.only(top: 50),
                            child: const Text('暂无消息'),
                          )
                        : ListView.builder(
                            itemCount: sysMsgs!.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return SystemMessageItem(sysMsgs![index]);
                            }))));
  }
}