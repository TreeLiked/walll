import 'package:fluro/fluro.dart';
import 'package:wall/config/routes/router_init.dart';
import 'package:wall/page/account/account_profile_edit_page.dart';
import 'package:wall/page/account/account_setting_page.dart';

class SettingRouter implements IRouterProvider {
  static String settingPage = "/setting";
  static String profileEditPage = "/setting/profileEdit";

  @override
  void initRouter(FluroRouter router) {
    router.define(settingPage,
        handler: Handler(handlerFunc: (_, params) => const AccountSettingsPage()), transitionType: TransitionType.fadeIn);

    router.define(profileEditPage,
        handler: Handler(handlerFunc: (_, params) => const AccountProfileEditPage()));
  }
}
