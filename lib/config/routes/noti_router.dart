import 'package:fluro/fluro.dart';
import 'package:wall/config/routes/router_init.dart';
import 'package:wall/page/notification/interactive_main_page.dart';
import 'package:wall/page/notification/system_main_page.dart';

class NotificationRouter implements IRouterProvider {
  static String systemMain = "/notification/system";
  static String interactiveMain = "/notification/interactive";
  static String campusMain = "/notification/campus";

  @override
  void initRouter(FluroRouter router) {
    router.define(systemMain, handler: Handler(handlerFunc: (_, params) {
      return SystemNotificationMainPage();
    }));
    router.define(interactiveMain, handler: Handler(handlerFunc: (_, params) {
      return const InteractiveNotificationMainPage();
    }));
    router.define(campusMain, handler: Handler(handlerFunc: (_, params) {
      // return CampusNotificationMainPage();
    }));
    // router.define(accountManagerPage, handler: Handler(handlerFunc: (_, params) => AccountManagerPage()));
  }
}
