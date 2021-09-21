import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:iap_app/common-widget/text_clickable_iitem.dart';
import 'package:iap_app/routes/fluro_navigator.dart';
import 'package:iap_app/util/common_util.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtil {
  /// 校验申请获取 相册和相机权限
  static Future<bool> checkAndRequestPhotos(BuildContext context, {bool needCamera = false}) async {
    if (!await Permission.photos.isGranted) {
      if (await Permission.photos.isUndetermined) {
        return Permission.photos.request().isGranted;
      } else {
        Utils.showSimpleConfirmDialog(
            context,
            '无法访问照片',
            '你未开启"允许Wall访问照片和相机"选项，将无法发表内容，更换头像等',
            ClickableText('知道了', () {
              NavigatorUtils.goBack(context);
            }),
            ClickableText('去设置', () async {
              await openAppSettings();
            }),
            barrierDismissible: false);
      }
      return false;
    }
    if (needCamera && Platform.isAndroid) {
      if (!await Permission.camera.isGranted) {
        if (await Permission.camera.isUndetermined) {
          return Permission.camera.request().isGranted;
        } else {
          Utils.showSimpleConfirmDialog(
              context,
              '无法访问照片',
              '你未开启"允许Wall访问照片和相机"选项，将无法发表内容，更换头像等',
              ClickableText('知道了', () {
                NavigatorUtils.goBack(context);
              }),
              ClickableText('去设置', () async {
                await openAppSettings();
              }),
              barrierDismissible: false);
          return false;
        }
      }
    }
    return true;
  }

  /// 校验和申请通知权限，showTipIfDetermined => 是否在权限已经被拒绝的情况下显示提示
  static Future<bool> checkAndRequestNotification(BuildContext context,
      {bool showTipIfDetermined = false, int probability = 10}) async {
    bool hasPermission = await Permission.notification.isGranted;

    if (!hasPermission) {
      if (await Permission.notification.isUndetermined) {
        return Permission.notification.request().isGranted;
      } else {
        int random = Random().nextInt(1000);
        if (random == 39) {
          return checkAndRequestNotification(context);
        }
        if (showTipIfDetermined) {
          int random2 = Random().nextInt(probability) + 1;
          if (random2 == 1) {
            Utils.showSimpleConfirmDialog(
                context,
                '无法发送通知',
                '你未开启"允许Wall发送通知"选项，将收不到包括用户私信，点赞评论等的通知',
                ClickableText('知道了', () {
                  NavigatorUtils.goBack(context);
                }),
                ClickableText('去设置', () async {
                  await openAppSettings();
                }),
                barrierDismissible: false);
          }
        }
        return false;
      }
    }
    return true;
  }


  static Future<bool> checkAndRequestStorage(BuildContext context,
      {bool showTipIfDetermined = false, int probability = 10}) async {
    bool hasPermission = await Permission.storage.isGranted;
    if (!hasPermission) {
      if (await Permission.storage.isUndetermined) {
        return Permission.storage.request().isGranted;
      } else {
        Utils.showSimpleConfirmDialog(
            context,
            '无法访问',
            '你未开启"允许Wall访问或保存照片"选项，将无法发表内容，更换头像或保存内容等',
            ClickableText('知道了', () {
              NavigatorUtils.goBack(context);
            }),
            ClickableText('去设置', () async {
              await openAppSettings();
            }),
            barrierDismissible: false);
        return false;
      }
    }
    return true;
  }
}
