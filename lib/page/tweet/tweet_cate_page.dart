import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wall/application.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/model/biz/tweet/tweet_type.dart';
import 'package:wall/page/tweet/tweet_cate_tab.dart';
import 'package:wall/page/tweet/tweet_index_hot_tab.dart';
import 'package:wall/page/tweet/tweet_index_live_tab.dart';
import 'package:wall/provider/account_local_provider.dart';
import 'package:wall/provider/msg_provider.dart';
import 'package:wall/provider/tweet_provider.dart';
import 'package:wall/util/perm_util.dart';
import 'package:wall/util/theme_util.dart';
import 'package:wall/util/umeng_util.dart';

class TweetCatePage extends StatefulWidget {
  const TweetCatePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TweetCatePageState();
  }
}

class _TweetCatePageState extends State<TweetCatePage>
    with AutomaticKeepAliveClientMixin<TweetCatePage>, SingleTickerProviderStateMixin {
  bool isDark = false;

  late TabController _tabController;

  late BuildContext _myContext;

  int _currentNavIndex = 0;

  late final List<TweetTypeEntity> typeEntityList;

  _TweetCatePageState() {
    typeEntityList = TweetTypeUtil.getPushableTweetTypeMap().values.toList();
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, length: typeEntityList.length);
    _tabController.addListener(() {
      setState(() {
        _currentNavIndex = _tabController.index;
      });
    });

    UMengUtil.userGoPage(UMengUtil.pageTweetIndex);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _myContext = context;
    isDark = ThemeUtil.isDark(context);

    return Consumer<MsgProvider>(builder: (_, msgProvider, __) {
      return Scaffold(
          appBar: PreferredSize(
            child: AppBar(
                elevation: 0,
                backgroundColor: isDark ? Colours.darkScaffoldColor : Colours.lightScaffoldColor,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.only(top: kToolbarHeight),
                  child: _buildTabBar(context),
                )),
            preferredSize: const Size.fromHeight(50),
          ),
          body: _buildTabView());
    });
  }

  _buildTabBar(BuildContext context) {
    return TabBar(
        labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.amber[600], letterSpacing: 1.1),
        unselectedLabelStyle: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.bold, color: Colours.secondaryFontColor, letterSpacing: 1.1),
        indicatorSize: TabBarIndicatorSize.label,
        indicator: UnderlineTabIndicator(
            insets: const EdgeInsets.only(left: 6.0, right: 6.0, bottom: 7.0),
            borderSide: BorderSide(color: typeEntityList[_currentNavIndex].color, width: 2.5)),
        labelColor: Colours.getEmphasizedTextColor(context),
        isScrollable: true,
        labelPadding: const EdgeInsets.only(left: 10.0, right: 10.0,top: 0, bottom: 10),
        controller: _tabController,
        tabs: typeEntityList.map((e) => _buildSingleTab(e)).toList());
  }

  Widget _buildSingleTab(TweetTypeEntity entity) {
    return Tab(text: entity.zhTag);
  }

  _buildTabView() {
    return TabBarView(
      controller: _tabController,
      children: typeEntityList.map((e) => _buildSingleTabView(e)).toList(),
    );
  }

  Widget _buildSingleTabView(TweetTypeEntity entity) {
    return TweetCateTab(typeEntity: entity);
  }

  @override
  bool get wantKeepAlive => true;
}
