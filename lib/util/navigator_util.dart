import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:wall/config/routes/routes.dart';
import 'package:wall/model/biz/account/account.dart';
import 'package:wall/model/biz/tweet/tweet_account.dart';
import 'package:wall/page/home_page.dart';
import 'package:wall/util/fluro_convert_utils.dart';

import '../application.dart';

/// fluro的路由跳转工具类
class NavigatorUtils {
  static push(BuildContext context, String path,
      {bool replace = false, bool clearStack = false, TransitionType transitionType = TransitionType.native}) {
    FocusScope.of(context).unfocus();
    Application.router!.navigateTo(
      context,
      path,
      replace: replace,
      clearStack: clearStack,
      transition: transitionType,
    );
  }

  static pushResult(BuildContext context, String path, Function(Object) function,
      {bool replace = false, bool clearStack = false}) {
    FocusScope.of(context).unfocus();
    Application.router!
        .navigateTo(context, path, replace: replace, clearStack: clearStack, transition: TransitionType.native)
        .then((result) {
      if (result == null) {
        return;
      }
      function(result);
    });
  }

  /// 返回
  static void goBack(BuildContext context, {int len = 1}) {
    FocusScope.of(context).unfocus();
    while (len-- > 0) {
      Navigator.pop(context);
    }
  }

  /// 带参数返回
  static void goBackWithParams(BuildContext context, result) {
    FocusScope.of(context).unfocus();
    Navigator.pop(context, result);
  }

  // 跳到WebView页
  static goWebViewPage(BuildContext context, String title, String url, {String source = "0"}) {
    //fluro 不支持传中文,需转换

    if (url.contains("music.163.com")) {
      title = "网易云音乐";
    } else if (url.contains("y.qq.com")) {
      title = "QQ音乐";
    } else if (url.contains("kugou.com")) {
      title = "酷狗音乐";
    }

    push(context,
        '${Routes.webViewPage}?title=${Uri.encodeComponent(title)}&url=${Uri.encodeComponent(url)}&source=$source');
  }

  static void goAccountProfileByAcc(BuildContext context, Account account) {
    push(
        context,
        Routes.accountProfile +
            FluroConvertUtils.packConvertArgs(
                {'nick': account.nick!, 'accId': account.id!, 'avatarUrl': account.avatarUrl!}));
  }

  static void goAccountProfileByTweetAcc(BuildContext context, TweetAccount account) {
    push(
        context,
        Routes.accountProfile +
            FluroConvertUtils.packConvertArgs(
                {'nick': account.nick!, 'accId': account.id!, 'avatarUrl': account.avatarUrl!}));
  }

//
// static void goAccountProfile3(BuildContext context, CircleAccount account) {
//   if (account == null) {
//     return;
//   }
//   push(
//       context,
//       Routes.accountProfile +
//           Utils.packConvertArgs(
//               {'nick': account.nick, 'accId': account.id, 'avatarUrl': account.avatarUrl}));
// }
//
// static void goReportPage(BuildContext context, String type, String refId, String title) {
//   if (type == null || refId == null) {
//     return;
//   }
//   push(
//       context,
//       Routes.reportPage +
//           "?refId=" +
//           Uri.encodeComponent(refId) +
//           "&type=" +
//           type +
//           "&title=" +
//           Uri.encodeComponent(title));
// }

// static void goTweetDetail(BuildContext context, BaseTweet tweet) {
//   Navigator.push(
//     context,
//     MaterialPageRoute(builder: (context) => TweetDetail(tweet)),
//   );
// }
//
  static void goIndex(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
  }
}
