import 'package:fluro/fluro.dart';
import 'package:wall/config/routes/router_init.dart';
import 'package:wall/page/account/account_about_page.dart';
import 'package:wall/page/account/account_other_setting_page.dart';
import 'package:wall/page/account/account_profile_edit_page.dart';
import 'package:wall/page/account/account_setting_page.dart';

class SettingRouter implements IRouterProvider {
  static String settingPage = "/setting";
  static String profileEditPage = "/setting/profileEdit";
  static String otherSettingPage = "/setting/other";
  static String aboutSettingPage = "/setting/about";

  @override
  void initRouter(FluroRouter router) {
    router.define(settingPage,
        handler: Handler(handlerFunc: (_, params) => const AccountSettingsPage()),
        transitionType: TransitionType.fadeIn);
    router.define(profileEditPage, handler: Handler(handlerFunc: (_, params) => const AccountProfileEditPage()));
    router.define(otherSettingPage, handler: Handler(handlerFunc: (_, params) => const AccountOtherSettingPage()));
    router.define(aboutSettingPage, handler: Handler(handlerFunc: (_, params) => const AccountAboutPage()));
  }
}
