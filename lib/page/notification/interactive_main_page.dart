import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wall/api/message_api.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/constant/gap_constant.dart';
import 'package:wall/model/biz/message/asbtract_message.dart';
import 'package:wall/model/response/result.dart';
import 'package:wall/util/coll_util.dart';
import 'package:wall/util/common_util.dart';
import 'package:wall/util/navigator_util.dart';
import 'package:wall/util/theme_util.dart';
import 'package:wall/util/toast_util.dart';
import 'package:wall/widget/common/button/long_flat_btn.dart';
import 'package:wall/widget/common/button/my_text_btn.dart';
import 'package:wall/widget/common/custom_app_bar.dart';
import 'package:wall/widget/notification/interation_msg_item.dart';

class InteractiveNotificationMainPage extends StatefulWidget {
  const InteractiveNotificationMainPage({Key? key}) : super(key: key);

  @override
  _InteractiveNotificationMainPageState createState() => _InteractiveNotificationMainPageState();
}

class _InteractiveNotificationMainPageState extends State<InteractiveNotificationMainPage>
    with AutomaticKeepAliveClientMixin<InteractiveNotificationMainPage> {
  bool isDark = false;

  List<AbstractMessage>? msgs;

  final RefreshController _refreshController = RefreshController(initialRefresh: true);

  int currentPage = 1;
  int pageSize = 25;

  @override
  void initState() {
    super.initState();
  }

  void _fetchInteractiveMessages() async {
    currentPage = 1;
    List<AbstractMessage> msgList = await getData(1, pageSize);
    if (msgList.isEmpty) {
      setState(() {
        msgs = [];
      });
      _refreshController.refreshCompleted(resetFooterState: true);
      return;
    }
    setState(() {
      if (msgs != null) {
        msgs!.clear();
      } else {
        msgs = [];
      }
      msgs!.addAll(msgList);
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
      this.msgs ??= [];
      this.msgs!.addAll(msgs);
    });
    _refreshController.loadComplete();
  }

  Future<List<AbstractMessage>> getData(int currentPage, int pageSize) async {
    return await MessageApi.queryInteractionMsg(currentPage, pageSize);
  }

  void _readAll() async {
    if (msgs == null || msgs!.isEmpty) {
      ToastUtil.showToast(context, '暂无消息');
      return;
    }
    Util.showDefaultLoadingWithBounds(context);
    Result r = await MessageApi.readAllInteractionMessage(pop: false);
    NavigatorUtils.goBack(context);
    if (r.isSuccess) {
      _refreshController.requestRefresh();
    } else {
      ToastUtil.showToast(context, r.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    isDark = ThemeUtil.isDark(context);
    return Scaffold(
//        backgroundColor: isDark ? Colours.dark_bg_color : Colours.bg_color,
        appBar: CustomAppBar(
          title: "互动消息",
          isBack: true,
          actionName: '全部已读',
          actionColor: Colors.amber,
          actionOnPressed: CollUtil.isListEmpty(msgs) ? null : _readAll,
        ),
        body: SafeArea(
            top: false,
            child: SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                enablePullUp: true,
                header: const WaterDropHeader(waterDropColor: Colours.mainColor, complete: Text('刷新完成')),
                footer: const ClassicFooter(
                    loadingText: '正在加载更多消息...', canLoadingText: '释放以加载更多', noDataText: '没有更多消息了', idleText: '继续上滑'),
                onLoading: _loadMore,
                onRefresh: _fetchInteractiveMessages,
                child: msgs == null
                    ? Gaps.empty
                    : msgs!.isEmpty
                        ? Container(
                            alignment: Alignment.topCenter,
                            margin: const EdgeInsets.only(top: 50),
                            child: const Text('暂无消息'),
                          )
                        : ListView.builder(
                            itemCount: msgs!.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return InteractionMessageItem(msgs![index]);
                            }))));
  }

  @override
  bool get wantKeepAlive => false;
}
