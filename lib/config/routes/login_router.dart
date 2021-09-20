import 'package:fluro/fluro.dart';
import 'package:wall/config/routes/router_init.dart';

class LoginRouter implements IRouterProvider {
  static String loginIndex = "/login";
  static String loginInfoPage = "/login/info";
  static String loginOrgPage = "/login/org";

  @override
  void initRouter(FluroRouter router) {
    router.define(loginIndex,
        handler: Handler(handlerFunc: (_, params) => null));

    // router.define(loginInfoPage,
    //     handler: Handler(handlerFunc: (_, params) => AccountInfoCPage()));
    //
    // router.define(loginOrgPage,
    //     handler: Handler(handlerFunc: (_, params) => OrgInfoCPage()));
  }
}
