import 'package:fluro/fluro.dart';
import 'package:wall/config/routes/router_init.dart';
import 'package:wall/page/login/login_page.dart';
import 'package:wall/page/register/register_account_info_set.dart';
import 'package:wall/page/register/register_org_sel.dart';

class LoginRouter implements IRouterProvider {
  static String loginIndex = "/login";
  static String registerAccSetPage = "/login/info";
  static String registerOrgSetPage = "/login/org";

  @override
  void initRouter(FluroRouter router) {
    router.define(loginIndex, handler: Handler(handlerFunc: (_, params) => const LoginPage()));

    router.define(registerAccSetPage,
        handler: Handler(handlerFunc: (_, params) => const RegisterAccSetPage()));

    router.define(registerOrgSetPage,
        handler: Handler(handlerFunc: (_, params) => const RegisterOrgSelPage()));
  }
}
