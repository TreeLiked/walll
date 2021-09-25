/*
 * fluro
 * Created by Yakka
 * https://theyakka.com
 * 
 * Copyright (c) 2019 Yakka, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart' hide Router;
import 'package:wall/config/routes/route_handlers.dart';
import 'package:wall/config/routes/router_init.dart';
import 'package:wall/page/login/login_page.dart';
import 'package:wall/page/splash_page.dart';
import 'package:wall/widget/common/widget_not_found.dart';

import 'login_router.dart';

class Routes {
  static String index = "/";
  static String splash = "/splash";

  static String webViewPage = "/webview";

  // home index
  static String home = "/home";
  static String tweetCreate = "/home/tweetCreate";

  static String notification = "/home/notification";
  static String filter = "/home/filter";
  static String square = "/home/square";
  static String inputTextPage = "/iptxtPage";
  static String reportPage = "/reportPage";

  // various detail
  static String tweetDetail = "/home/tweetDetail";
  static String tweetTypeInfProPlf = "/home/tweetTypeInfProPlf";

//  static String cardToGallery = "/home/cardTogallery";
//  static String detailToGallery = "/home/card/detailTogallery";

  static String accountProfile = "/home/accountProfile";

  static String orgChoose = "/foo/orgChoose";

  static final List<IRouterProvider> _listRouter = [];

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      print("没有找到路由页面");
      return const WidgetNotFound();
    });

    // router.define(webViewPage, handler: Handler(handlerFunc: (_, params) {
    //   // TODO 这里跳转编码问题
    //   String title = params['title']?.first;
    //   String url = params['url']?.first;
    //   String source = params['source']?.first;
    //   return WebViewPage(title: title, url: url, source: source);
    // }));
    //
    router.define(splash, handler: Handler(handlerFunc: (_, params) {
      return SplashPage();
    }));
    //
    // router.define(tweetDetail, handler: Handler(handlerFunc: (_, params) {
    //   int tweetId = int.parse(params['tweetId'].first);
    //   return TweetDetail(null, tweetId: tweetId, hotRank: -1, newLink: true);
    // }));
    //
    // router.define(tweetTypeInfProPlf, handler: Handler(handlerFunc: (_, params) {
    //   int tweetId = int.parse(params['tweetId'].first);
    //   String type = params['tweetType'].first;
    //   return TweetTypeInfGroPlfPage(tweetId, type);
    // }));
    //

    // router.define(index, handler: indexHandler);
    router.define(home, handler: homeHandler);
    // router.define(square, handler: squareHandler, transitionType: TransitionType.fadeIn);
    //
    // router.define(create, handler: createHandler);
    // router.define(notification, handler: notificationHandler);
    router.define(accountProfile, handler: accountProfileHandler,transitionType: TransitionType.fadeIn);
    //
    // router.define(inputTextPage, handler: inputPageHandler);
    // router.define(reportPage, handler: reportHandler);

//    router.define(cardToGallery, handler: galleryViewHandler);
//    router.define(detailToGallery, handler: galleryViewHandler);

    // router.define(hot,
    //     handler: demoRouteHandler, transitionType: TransitionType.inFromLeft);
    // router.define(create, handler: demoFunctionHandler);
    // router.define(filter, handler: deepLinkHandler);

    _listRouter.clear();

    /// 各自路由由各自模块管理，统一在此添加初始化

    // _listRouter.add(SettingRouter());
    _listRouter.add(LoginRouter());
    // _listRouter.add(SquareRouter());
    // _listRouter.add(NotificationRouter());
    // _listRouter.add(CircleRouter());

    /// 初始化路由
    for (var routerProvider in _listRouter) {
      routerProvider.initRouter(router);
    }
  }
}
