import 'dart:core';
import 'dart:io';

import 'package:wall/util/http_util.dart';
import 'package:flustars/flustars.dart';
import 'package:wall/util/str_util.dart';
import 'package:device_info/device_info.dart';

import '../application.dart';
import 'api_category.dart';

class DeviceApi {
  static const String _tag = "DeviceApi";

  static void updateDeviceInfoByRegId(String? regId) async {
    if (StrUtil.isEmpty(regId)) {
      LogUtil.e("更新用户设备信息失败", tag: _tag);
      return;
    }
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      updateDeviceInfo(Application.getAccountId!, "IPHONE", "IOS", iosInfo.systemVersion, regId!);
      return;
    }
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      updateDeviceInfo(
          Application.getAccountId!, androidInfo.brand.toUpperCase(), "ANDROID", androidInfo.device, regId!);
    }
  }

  static void updateDeviceInfo(
      String accountId, String name, String platform, String model, String regId) async {
    String url = Api.updateDeviceInfo + "?name=$name&devicePlf=$platform&model=$model&deviceId=$regId";
    httpUtil.get(url);
  }

  static void removeDeviceInfo(String? accountId, String? regId) async {
    if (accountId == null || regId == null) {
      LogUtil.v("- - - 用户登出失败 - - -");
      return;
    }
    httpUtil.get(Api.removeDeviceInfo + "?deviceId=$regId").then((res) {
      LogUtil.v("- - - 用户登出 - - -");
    });
  }
}
