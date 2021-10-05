import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wall/util/bottom_sheet_util.dart';
import 'package:wall/util/common_util.dart';
import 'package:wall/widget/common/button/my_text_btn.dart';
import 'package:wall/widget/common/dialog/bottom_cancel_confirm.dart';
import 'package:wall/widget/common/dialog/simple_cancel_confirm_dialog.dart';

import 'navigator_util.dart';

class PermissionUtil {
  /// 校验申请获取 相册和相机权限
  static Future<bool> checkAndRequestPhotos(BuildContext context, {bool needCamera = false}) async {
    if (!await Permission.photos.isGranted) {
      if (await Permission.photos.isDenied) {
        return Permission.photos.request().isGranted;
      } else {
        openDialog(context, '无法访问照片', '您未开启"允许Wall访问照片和相机"选项，将无法发表内容，更换头像等');
      }
      return false;
    }
    if (needCamera && Platform.isAndroid) {
      if (!await Permission.camera.isGranted) {
        if (await Permission.camera.isDenied) {
          return Permission.camera.request().isGranted;
        } else {
          openDialog(context, '无法访问照片', '您未开启"允许Wall访问照片和相机"选项，将无法发表内容，更换头像等');
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
      if (await Permission.notification.isDenied) {
        return Permission.notification.request().isGranted;
      } else {
        int random = Random().nextInt(1000);
        if (random == 39) {
          return checkAndRequestNotification(context);
        }
        if (showTipIfDetermined) {
          int random2 = Random().nextInt(probability) + 1;
          if (random2 == 1) {
            openDialog(context, '未开启通知权限', '您未开启"允许Wall发送通知"选项，将收不到包括用户私信，点赞评论等的通知');
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
    print(await Permission.storage.status);
    print("---------------------------------");
    if (!hasPermission) {
      if (await Permission.storage.isDenied) {
        return Permission.storage.request().isGranted;
      } else {
        openDialog(context, '存储失败', '你未开启"允许Wall访问或保存照片"选项，将无法发表内容，更换头像或保存内容等');
        return false;
      }
    }
    return true;
  }

  static void openDialog(BuildContext context, title, content) {
    // Util.displayDialog(
    //     context,
    //     SimpleCancelConfirmDialog(
    //       title,
    //       content,
    //       MyTextButton(text: const Text("知道了"), enabled: true, onPressed: () => NavigatorUtils.goBack(context)),
    //       MyTextButton(text: const Text("去设置"), enabled: true, onPressed: () async => await openAppSettings()),
    //     ),
    //     barrierDismissible: false);
    BottomSheetUtil.showBottomSheet(
        context,
        0.4,
        BottomCancelConfirmDialog(
            content: content,
            title: title,
            confirmText: '去设置',
            onCancel: () => NavigatorUtils.goBack(context),
            onConfirm: () async => await openAppSettings()));
  }
}
