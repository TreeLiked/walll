import 'package:fluro/fluro.dart';
import 'package:wall/config/routes/router_init.dart';
import 'package:wall/page/account/account_setting_page.dart';

class SettingRouter implements IRouterProvider {
  static String settingPage = "/setting";

  @override
  void initRouter(FluroRouter router) {
    router.define(settingPage,
        handler: Handler(handlerFunc: (_, params) => AccountSettingsPage()), transitionType: TransitionType.fadeIn);
  }
}
