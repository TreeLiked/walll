import 'package:umeng_analytics_plugin/umeng_analytics_plugin.dart';

class UMengUtil {
  static const String pageTweetIndex = "推文首页";
  static const String pageTweetIndexHot = "推文热门页";
  static const String pageTweetIndexCreate = "推文创建页";
  static const String pageTweetIndexDetail = "推文详情页";
  static const String pageTweetIndexDetailHot = "推文热门详情页";

  static const String pageAccountProfile = "用户资料页面";
  static const String pageNotifyIndex = "通知首页";
  static const String pageAd = "广告页面";
  static const String pagePc = "个人资料页面";

  static Future<void> initUMengAnalytics() async {
    await UmengAnalyticsPlugin.init(
      androidKey: '5f6df059906ad8111714de33',
      iosKey: '5f6c82e880455950e496a742',
    );
  }

  static void userGoPage(String pageName) {
    UmengAnalyticsPlugin.pageStart(pageName);
  }

  static void userLeavePage(String pageName) {
    UmengAnalyticsPlugin.pageEnd(pageName);
  }
}
