import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wall/application.dart';
import 'package:wall/config/routes/setting_router.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/constant/gap_constant.dart';
import 'package:wall/model/biz/account/account.dart';
import 'package:wall/page/account/account_my_index_footprint.dart';
import 'package:wall/page/account/account_my_index_his_tweet.dart';
import 'package:wall/provider/account_local_provider.dart';
import 'package:wall/util/navigator_util.dart';
import 'package:wall/util/theme_util.dart';
import 'package:wall/widget/common/account_avatar_2.dart';
import 'package:wall/widget/common/container/center_row_text.dart';
import 'package:wall/widget/common/real_rich_text.dart';

class AccountMyIndex extends StatefulWidget {
  const AccountMyIndex({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AccountMyIndexState();
  }
}

class _AccountMyIndexState extends State<AccountMyIndex>
    with AutomaticKeepAliveClientMixin<AccountMyIndex>, SingleTickerProviderStateMixin {
  String _followCountStr = "18";
  String _fansCountStr = "3";

  bool _isDark = false;
  late TabController _tabController;

  late BuildContext _context;

  @override
  void initState() {
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
  }

  @override
  void deactivate() {
    if (mounted) {
      SystemChrome.setSystemUIOverlayStyle(
          ThemeUtil.isDark(_context) ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark);
    }
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _context = context;
    _isDark = ThemeUtil.isDark(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(body: Consumer<AccountLocalProvider>(builder: (context, provider, _) {
          Account user = provider.account!;
          return Stack(children: [
            CustomScrollView(
                //为了能使CustomScrollView拉到顶部时还能继续往下拉，必须让 physics 支持弹性效果
                // physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                physics: const NeverScrollableScrollPhysics(),
                slivers: [
                  SliverFlexibleHeader(
                      visibleExtent: 300, // 初始状态在列表中占用的布局高度
                      // 为了能根据下拉状态变化来定制显示的布局，我们通过一个 builder 来动态构建布局。
                      builder: (context, availableHeight) {
                        return Container(
                            width: double.infinity,
                            height: availableHeight,
                            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 20.0, right: 20.0),
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [Color(0xfffddb92), Color(0xFFd1fdff)])),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const SizedBox(width: 20, height: 0),
                                      Expanded(
                                          child: Container(
                                        alignment: Alignment.center,
                                        child: Text(user.nick!,
                                            style: const TextStyle(
                                                color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.w500)),
                                      )),
                                      SizedBox(
                                          width: 20,
                                          child: InkWell(
                                              onTap: () => NavigatorUtils.push(context, SettingRouter.settingPage),
                                              child: const Icon(Icons.settings, size: 20, color: Colors.white)))
                                    ],
                                  ),
                                  Gaps.vGap30,
                                  AccountAvatar2(avatarUrl: user.avatarUrl!, size: 70),
                                  Gaps.vGap15,
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 3.0),
                                    width: 60,
                                    alignment: Alignment.center,
                                    decoration:
                                        BoxDecoration(borderRadius: BorderRadius.circular(6.0), color: Colors.white),
                                    child: InkWell(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: const [
                                          Icon(Icons.edit, size: 13.0, color: Colors.black),
                                          Gaps.hGap2,
                                          Text('编辑', style: TextStyle(color: Colors.black, fontSize: 13.0))
                                        ],
                                      ),
                                    ),
                                  ),
                                  Gaps.vGap30,
                                  RealRichText([
                                    const TextSpan(text: '关注 ', style: TextStyle(fontSize: 12)),
                                    TextSpan(
                                        text: _followCountStr,
                                        style: const TextStyle(color: Colors.orange, fontSize: 14)),
                                    const TextSpan(text: '  '),
                                    const TextSpan(text: '粉丝 ', style: TextStyle(fontSize: 12)),
                                    TextSpan(
                                        text: _fansCountStr,
                                        style: const TextStyle(color: Colors.orange, fontSize: 14)),
                                  ])
                                ]));
                      })
                ]),
            Positioned(
                left: 0,
                right: 0,
                top: 280,
                bottom: 0,
                child: Container(
                    width: Application.screenWidth,
                    padding: const EdgeInsets.only(top: 15),
                    decoration: BoxDecoration(
                      color: Colours.getScaffoldColor(context),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    // height: Application.screenHeight!-300,
                    child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          width: Application.screenWidth,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CenterRowWidget(
                                    child: Text(user.signature ?? "",
                                        softWrap: true,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 13, color: Colours.secondaryFontColor))),
                                Gaps.vGap20,
                                TabBar(
                                    labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                    labelColor: Colours.getEmphasizedTextColor(context),
                                    unselectedLabelStyle: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w400),
                                    unselectedLabelColor: Colours.secondaryFontColor,
                                    indicatorSize: TabBarIndicatorSize.label,
                                    indicator: const UnderlineTabIndicator(
                                        insets: EdgeInsets.only(right: 15.0, left: 0.0),
                                        borderSide: BorderSide(color: Colors.orange, width: 3.0)),
                                    controller: _tabController,
                                    isScrollable: true,
                                    labelPadding: const EdgeInsets.only(right: 15),
                                    onTap: (index) {},
                                    tabs: const [
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 3.0),
                                        child: Text('动态'),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 3.0),
                                        child: Text('足迹'),
                                      )
                                    ]),
                                Gaps.vGap5
                              ])),
                      Expanded(
                          child: TabBarView(
                              controller: _tabController,
                              children: const [AccountHisTweetPage(), AccountFootPrintPage()]))
                    ])))
          ]);
        })));
  }

  SliverList buildSliverList() {
    return SliverList(
      ///懒加载代理
      delegate: SliverChildBuilderDelegate((BuildContext context, num index) {
        ///子Item的布局
        return Container(
          decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))),
          height: 44,
          margin: EdgeInsets.only(bottom: 10),
          child: Text("item- $index"),
        );
      }, childCount: 100), //子Item的个数
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _SliverFlexibleHeader extends SingleChildRenderObjectWidget {
  const _SliverFlexibleHeader({
    Key? key,
    required Widget child,
    this.visibleExtent = 0,
  }) : super(key: key, child: child);
  final double visibleExtent;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _FlexibleHeaderRenderSliver(visibleExtent);
  }

  @override
  void updateRenderObject(BuildContext context, _FlexibleHeaderRenderSliver renderObject) {
    renderObject..visibleExtent = visibleExtent;
  }
}

class _FlexibleHeaderRenderSliver extends RenderSliverSingleBoxAdapter {
  _FlexibleHeaderRenderSliver(double visibleExtent) : _visibleExtent = visibleExtent;

  double _lastOverScroll = 0;
  double _lastScrollOffset = 0;
  late double _visibleExtent = 0;

  set visibleExtent(double value) {
    // 可视长度发生变化，更新状态并重新布局
    if (_visibleExtent != value) {
      _lastOverScroll = 0;
      _visibleExtent = value;
      markNeedsLayout();
    }
  }

  @override
  void performLayout() {
    // 滑动距离大于_visibleExtent时则表示子节点已经在屏幕之外了
    if (child == null || (constraints.scrollOffset > _visibleExtent)) {
      geometry = SliverGeometry(scrollExtent: _visibleExtent);
      return;
    }

    // 测试overlap,下拉过程中overlap会一直变化.
    double overScroll = constraints.overlap < 0 ? constraints.overlap.abs() : 0;
    var scrollOffset = constraints.scrollOffset;

    // 在Viewport中顶部的可视空间为该 Sliver 可绘制的最大区域。
    // 1. 如果Sliver已经滑出可视区域则 constraints.scrollOffset 会大于 _visibleExtent，
    //    这种情况我们在一开始就判断过了。
    // 2. 如果我们下拉超出了边界，此时 overScroll>0，scrollOffset 值为0，所以最终的绘制区域为
    //    _visibleExtent + overScroll.
    double paintExtent = _visibleExtent + overScroll - constraints.scrollOffset;
    // 绘制高度不超过最大可绘制空间
    paintExtent = min(paintExtent, constraints.remainingPaintExtent);

    //对子组件进行布局，关于 layout 详细过程我们将在本书后面布局原理相关章节详细介绍，现在只需知道
    //子组件通过 LayoutBuilder可以拿到这里我们传递的约束对象（ExtraInfoBoxConstraints）
    child!.layout(
      constraints.asBoxConstraints(maxExtent: paintExtent),
      parentUsesSize: false,
    );

    //最大为_visibleExtent，最小为 0
    double layoutExtent = min(_visibleExtent, paintExtent);

    //设置geometry，Viewport 在布局时会用到
    geometry = SliverGeometry(
      scrollExtent: layoutExtent,
      paintOrigin: -overScroll,
      paintExtent: paintExtent,
      maxPaintExtent: paintExtent,
      layoutExtent: layoutExtent,
    );
  }
}

typedef SliverFlexibleHeaderBuilder = Widget Function(
  BuildContext context,
  double maxExtent,
  // ScrollDirection direction,
);

class SliverFlexibleHeader extends StatelessWidget {
  const SliverFlexibleHeader({
    Key? key,
    this.visibleExtent = 0,
    required this.builder,
  }) : super(key: key);

  final SliverFlexibleHeaderBuilder builder;
  final double visibleExtent;

  @override
  Widget build(BuildContext context) {
    return _SliverFlexibleHeader(
      visibleExtent: visibleExtent,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return builder(context, constraints.maxHeight);
        },
      ),
    );
  }
}
