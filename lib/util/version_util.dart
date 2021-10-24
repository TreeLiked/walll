import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:wall/api/version_control.dart';
import 'package:wall/constant/app_constant.dart';
import 'package:wall/model/biz/version/pub_v.dart';
import 'package:wall/model/response/result.dart';
import 'package:wall/util/toast_util.dart';
import 'package:wall/widget/setting/app_update_dialog.dart';

import '../application.dart';

class VersionUtils {
  static const MethodChannel _channel = const MethodChannel('version');

  /// 应用安装
  static void install(String path) {
    InstallPlugin.installApk(path, AppCst.androidAppId);
  }

  /// AppStore跳转
  static void jumpAppStore() {
//    _channel.invokeMethod("jumpAppStore");
    InstallPlugin.gotoAppStore("https://itunes.apple.com/cn/app/id1497247380");
  }

  static void showUpdateDialog(BuildContext context, VersionBO version, bool forceUpdate) {
    showDialog(
        context: context,
        barrierDismissible: !forceUpdate,
        builder: (BuildContext context) {
          return AppUpdateDialog(version, forceUpdate);
        });
  }

  static Future<Result<VersionBO>> checkUpdate({BuildContext? context}) async {
    return await VersionApi.fetchLatestVersion();
  }

  static void displayUpdateDialog(Result<VersionBO>? result, {BuildContext? context, bool slient = false}) {
    if (result != null) {
      if (!result.isSuccess) {
        // 当前版本不可用，必须更新
        if (result.data != null) {
          VersionUtils.showUpdateDialog(context ?? Application.context!, result.data!, true);
        } else {
          if (!slient) {
            ToastUtil.showToast(context, "新版本");
          }
        }
      } else {
        // 当前版本可以继续使用
        if (result.data != null) {
          // 有新的版本可以升级
          VersionUtils.showUpdateDialog(context ?? Application.context!, result.data!, false);
        } else {
          if (!slient) {
            ToastUtil.showToast(context, '恭喜您已经是最新版本');
          }
          return;
        }
        // 最新版本
      }
    }
  }
}
