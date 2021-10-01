import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' as prefix0;
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wall/api/common_api.dart';
import 'package:wall/api/device_api.dart';
import 'package:wall/api/member_api.dart';
import 'package:wall/api/university_api.dart';
import 'package:wall/config/routes/login_router.dart';
import 'package:wall/config/routes/routes.dart';
import 'package:wall/constant/app_constant.dart';
import 'package:wall/constant/shared_constant.dart';
import 'package:wall/constant/size_constant.dart';
import 'package:wall/constant/text_constant.dart';
import 'package:wall/constant/url_constant.dart';
import 'package:wall/model/biz/account/account.dart';
import 'package:wall/model/biz/org/university.dart';
import 'package:wall/page/account/account_profile_index.dart';
import 'package:wall/page/home_page.dart';
import 'package:wall/provider/account_local_provider.dart';
import 'package:wall/provider/theme_provider.dart';
import 'package:wall/util/http_util.dart';
import 'package:wall/util/navigator_util.dart';
import 'package:wall/util/umeng_util.dart';

import '../application.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  int _status = 0;
  bool _hasAd = false;
  bool _displayAd = false;
  int _adLeftTime = 0;
  int _addTotalTime = 0;
  StreamSubscription? _adLeftTimeSub;

  static const String _tag = "SplashPage";

  bool _hasGuide = false;
  bool _displayGuide = false;
  Map<String, dynamic>? _adValueMap;

  int _currentGuideIndex = 0;

  // List<String> _guideList = ["app_start_1", "app_start_2", "app_start_3"];
  StreamSubscription? _subscription;

  // 默认该版本的引导页面数目
  int _guideLen = 3;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      // ignore: invalid_use_of_visible_for_testing_member
      // await Log.init();
      await SpUtil.getInstance();
      // 由于SpUtil未初始化，所以MaterialApp获取的为默认主题配置，这里同步一下。
      // Provider.of<ThemeProvider>(context, listen: false).setTheme(Themes.dark);
      Provider.of<ThemeProvider>(context, listen: false).syncTheme();
      // if (SpUtil.getBool(Constant.keyGuide, defValue: true)){
      //   /// 预先缓存图片，避免直接使用时因为首次加载造成闪动
      //   _guideList.forEach((image){
      //     precacheImage(ImageUtils.getAssetImage(image), context);
      //   });
      // }
      _checkGuideNeed();
      _initSplash();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _adLeftTimeSub?.cancel();
    super.dispose();
  }

  // void _checkOrDisplayAd() async {
  //   Map<String, dynamic> splashAd = await CommonApi.getSplashAd();
  //   if (splashAd != null && splashAd.isNotEmpty) {
  //     if (splashAd.containsKey("imageUrl")) {
  //       setState(() {
  //         _adValueMap = splashAd;
  //         _adLeftTime = splashAd["displayMs"] ~/ 1000;
  //         _addTotalTime = _adLeftTime;
  //         _hasAd = true;
  //         print(splashAd);
  //       });
  //     }
  //   }
  // }

  void _initSplash() {
    _subscription = TimerStream("", const Duration(milliseconds: 1000)).listen((_) async {
      String storageToken = SpUtil.getString(SharedCst.localAccountToken, defValue: '')!;

      LogUtil.v("- - - 执行登录 - - -, storageToken: $storageToken", tag: _tag);
      httpUtil.updateAuthToken(storageToken);
      httpUtil2.updateAuthToken(storageToken);

      Account? acc;
      if (storageToken == '' || (acc = await MemberApi.getMyAccount(storageToken)) == null) {
        LogUtil.v("- - - Token缺失或登录失败 - - -", tag: _tag);
        _goLogin();
        return;
      }

      University? university = await UniversityApi.queryUnis(storageToken);
      if (university == null) {
        LogUtil.d("- - - 用户异常, 没有获取到组织 - - -", tag: _tag);
        _goLogin();
        return;
      }
      LogUtil.v("- - - 登录成功, orgId: ${university.id!} 用户详情: ${acc!.toJson()} - - -", tag: _tag);

      httpUtil.updateAuthToken(storageToken);
      httpUtil2.updateAuthToken(storageToken);

      AccountLocalProvider accLocalProvider = Provider.of<AccountLocalProvider>(context, listen: false);
      accLocalProvider.setAccount(acc);

      Application.setAccountId(acc.id);
      Application.setAccount(acc);
      Application.setOrgId(university.id!);
      Application.setOrgName(university.name!);
      Application.setLocalAccountToken(storageToken);

      await SpUtil.putInt(SharedCst.orgId, university.id!);
      await SpUtil.putString(SharedCst.orgName, university.name!);

      DeviceApi.updateDeviceInfoByRegId(Application.getDeviceId);
      decideWhatToDo();
      _clearCacheIfNecessary();
    });
  }

  void decideWhatToDo() {
    if (_hasGuide) {
      setState(() {
        _displayGuide = true;
      });
      return;
    }
    if (_hasAd) {
      setState(() {
        _displayAd = true;
      });
      _delayAndForwardIndex((_adValueMap!["displayMs"] as int));
      return;
    }
    // 其他情况
    setState(() {
      _status = 1;
    });
  }

  void _delayAndForwardIndex(int ms) {
    _adLeftTimeSub = Stream.periodic(Duration(seconds: 1), (int i) {
      setState(() {
        _adLeftTime = _addTotalTime - i - 1;
        if (_adLeftTime < 1) {
          _status = 1;
          _displayAd = false;
        }
      });
    }).take(_addTotalTime).listen((event) {});
    TimerStream("", Duration(milliseconds: ms)).listen((_) async {
      setState(() {
        _status = 1;
        _displayAd = false;
      });
    });
  }

  Future<void> _checkGuideNeed() async {
    // setState(() {
    //   _hasGuide = true;
    // });
    String version = Platform.isIOS
        ? AppCst.versionRemarkIos.substring(0, AppCst.versionRemarkIos.lastIndexOf("."))
        : AppCst.versionRemarkAndroid.substring(0, AppCst.versionRemarkAndroid.lastIndexOf("."));
    String versionVal = SpUtil.getString(version, defValue: "0")!;
    LogUtil.e("获取引导版本字段, $versionVal, 当前版本号: $version");
    if (versionVal == "0") {
      await SpUtil.putString(version, "1");
      setState(() {
        _hasGuide = true;
      });
      return;
    } else {
      // 没有引导页面去找广告啊
      _checkOrDisplayAd();
    }
  }

  _goLogin() {
    NavigatorUtils.push(context, LoginRouter.loginIndex, replace: true);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    prefix0.ScreenUtil.init(BoxConstraints(maxWidth: width, maxHeight: height), designSize: MediaQuery.of(context).size);

    Application.screenWidth = width;
    Application.screenHeight = height;
    Application.context = context;

    LogUtil.e("ScreenWith: $width, ScreenHeight: $height");

    Widget w;
    if (_displayGuide) {
      w = Stack(
        children: [
          Swiper(
              itemBuilder: (BuildContext context, int index) {
                // return LoadAssetImage("guide/${index + 1}", width: double.infinity, height: double.infinity);
                // return CachedNetworkImage(
                //     imageUrl: _guideImages[index],
                //     width: double.infinity,
                //     fit: BoxFit.cover,
                //     placeholder: (context, _) => const CupertinoActivityIndicator(),
                //     height: double.infinity,
                //     fadeInCurve: Curves.linear);
                // TODO 111
                return Text("111");
              },
              onIndexChanged: (index) {
                setState(() {
                  _currentGuideIndex = index;
                });
              },
              loop: false,
              layout: SwiperLayout.DEFAULT,
              itemCount: _guideLen),
          Positioned(
            top: prefix0.ScreenUtil().setHeight(30) + prefix0.ScreenUtil().statusBarHeight,
            right: prefix0.ScreenUtil().setWidth(60),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Colors.black12,
              ),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
              child: GestureDetector(
                // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                child: Text(
                  _currentGuideIndex == _guideLen - 1 ? "完成" : "跳过",
                  style: TextStyle(fontSize: SizeCst.normalFontSize, color: Colors.black54),
                ),
                onTap: () {
                  setState(() {
                    _status = 1;
                    _displayAd = false;
                    _displayGuide = false;
                  });
                },
              ),
            ),
          ),
          Positioned(
            bottom: prefix0.ScreenUtil().setHeight(200),
            left: 0,
            child: Container(
              // height: 100,
              width: Application.screenWidth,
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black12,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _xiaoHuaKuai(_currentGuideIndex == 0),
                    _xiaoHuaKuai(_currentGuideIndex == 1),
                    _xiaoHuaKuai(_currentGuideIndex == 2),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      if (_displayAd && _adValueMap != null) {
        UMengUtil.userGoPage(UMengUtil.pageAd);
        w = Stack(
          children: [
            GestureDetector(
              child: CachedNetworkImage(
                imageUrl: _adValueMap!["imageUrl"],
                width: double.infinity,
                fit: BoxFit.cover,
                height: double.infinity,
                fadeInCurve: Curves.linear,
              ),
              onTap: () => NavigatorUtils.goWebViewPage(
                  context, _adValueMap!["jumpTitle"], _adValueMap!["jumpUrl"],
                  source: "1"),
            ),
            Positioned(
              top: prefix0.ScreenUtil().setHeight(30) + prefix0.ScreenUtil().statusBarHeight,
              right: prefix0.ScreenUtil().setWidth(30),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black38,
                ),
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                child: GestureDetector(
                  // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                  child: Text(
                    "广告剩余 $_adLeftTime s丨跳过",
                    style: const TextStyle(fontSize: SizeCst.smallFontSize, color: Colors.white70),
                  ),
                  onTap: () {
                    setState(() {
                      _status = 1;
                      _displayAd = false;
                    });
                  },
                ),
              ),
            )
          ],
        );
      } else {
        if (_status == 0) {
          w = CachedNetworkImage(
            imageUrl: UrlCst.appLaunchImg,
            width: double.infinity,
            fit: BoxFit.cover,
            height: double.infinity,
            fadeInCurve: Curves.linear,
          );
        } else {
          return const HomePage();
          // return AccountProfileIndex("eefff7ec10ec40eab8d7a99057139d17", "预售春天", "https://tva1.sinaimg.cn/large/008i3skNgy1gusyaltieej60u00u0q6202.jpg");
        }
      }
    }

    return Material(child: w);
    // child: OrgInfoCPage());
  }

  void _checkOrDisplayAd() async {
    Map<String, dynamic> splashAd = await CommonApi.getSplashAd();
    if (splashAd != null && splashAd.isNotEmpty) {
      if (splashAd.containsKey("imageUrl")) {
        setState(() {
          _adValueMap = splashAd;
          _adLeftTime = splashAd["displayMs"] ~/ 1000;
          _addTotalTime = _adLeftTime;
          _hasAd = true;
          print(splashAd);
        });
      }
    }
  }

  Widget _xiaoHuaKuai(bool currentThis) {
    return Container(
      color: currentThis ? Colors.lightBlue : Colors.white24,
      width: Application.screenWidth! * 0.1,
      height: 2.0,
    );
  }

  Future<void> _clearCacheIfNecessary() async {
    int? lastClearTs = SpUtil.getInt(SharedCst.lastCacheClearDate);
    if (lastClearTs == null) {
      await SpUtil.putInt(SharedCst.lastCacheClearDate, DateTime.now().millisecondsSinceEpoch);
      return;
    }
    if ((DateUtil.getNowDateMs() - lastClearTs) > 3 * 24 * 3600 * 1000) {
      // 超过三天没有清理缓存了
      PaintingBinding.instance!.imageCache?.clear();
      var defaultCacheManager = DefaultCacheManager();
      defaultCacheManager.emptyCache();
      await SpUtil.putInt(SharedCst.lastCacheClearDate, DateUtil.getNowDateMs());
    }
  }
}
