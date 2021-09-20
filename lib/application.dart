import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/biz/account/account.dart';


class Application {
  static FluroRouter? router;
  static GlobalKey<NavigatorState> key = GlobalKey();
  static SharedPreferences? sp;
  static String? _localAccountToken;

  static double? screenWidth;
  static double? screenHeight;

  static int? _ordId;
  static String? _orgName;

  static String? _accountId;
  static Account? _account;

  static String? _deviceId;

  static BuildContext? context;

  static String? get getAccountId {
    return _accountId;
  }

  static Account? get getAccount {
    return _account;
  }

  static int? get getOrgId {
    return _ordId;
  }

  static String? get getOrgName {
    return _orgName;
  }

  static initSp() async {
    sp = await SharedPreferences.getInstance();
  }

  static setupLocator() {
    // getIt.registerSingleton(NavigateService());
  }

  static void setAccount(Account? account) {
    _account = account;
  }
  static void setAccountId(String? accountId) {
    _accountId = accountId;
  }

  static void setOrgId(int orgId) {
    _ordId = orgId;
  }

  static void setOrgName(String name) {
    _orgName = name;
  }

  static void setDeviceId(String deviceId) {
    _deviceId = deviceId;
  }

  static String? get getDeviceId {
    return _deviceId;
  }

  static String? get getLocalAccountToken {
    return _localAccountToken;
  }

  static void setLocalAccountToken(String? token) {
    _localAccountToken = token;
  }


  static void calTweetImageWidth() {

  }

}
