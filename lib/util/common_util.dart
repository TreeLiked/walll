import 'dart:io';
import 'dart:typed_data';

import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' as su;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wall/api/device_api.dart';
import 'package:wall/application.dart';
import 'package:wall/config/routes/login_router.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/constant/size_constant.dart';
import 'package:wall/util/http_util.dart';
import 'package:wall/util/perm_util.dart';
import 'package:wall/util/str_util.dart';
import 'package:wall/util/theme_util.dart';
import 'package:wall/util/toast_util.dart';
import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'coll_util.dart';
import 'navigator_util.dart';

class Util {

  static void copyTextToClipBoard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  static void showDefaultLoading(BuildContext context, {double size = 30, Function? call}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SpinKitThreeBounce(color: Colors.white, size: size);
          // return CupertinoActivityIndicator();
//        const CupertinoActivityIndicator()
//          );
//          return SpinKitChasingDots(color: Color(0xff3489ff), size: size);
        });
    if (call != null) {
      call();
      NavigatorUtils.goBack(context);
    }
  }

  static void closeLoading(BuildContext context) {
    NavigatorUtils.goBack(context);
  }

  static void showDefaultLoadingWithBounds(BuildContext context, {double size = 25, String text = ""}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Material(
            type: MaterialType.transparency,
            child: Center(
                child: SizedBox(
              width: su.ScreenUtil().setWidth(100),
              height: su.ScreenUtil().setWidth(100),
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: ThemeUtil.isDark(context) ? Colors.black54 : Colors.black54,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 3.0),
                  alignment: Alignment.center,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: _renderLoadingList(context, size, text))),
            )),
          );
        });
  }

  static List<Widget> _renderLoadingList(BuildContext context, double size, String text) {
    List<Widget> list = [];
    list.add(SpinKitSpinningLines(color: Colours.actionClickable, size: size, itemCount: 3));
    if (!StrUtil.isEmpty(text)) {
      list.add(Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(text,
              softWrap: true,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: SizeCst.normalFontSize))));
    }
    return list;
  }

  static String getBadgeText(int count, {int maxCount = 99}) {
    if (count <= 0) {
      return "";
    }
    if (count > maxCount) {
      return '$maxCount+';
    }
    return '$count';
  }

  static Text getRpWidget(int cnt, {int maxCount = 99, Color textColor = Colors.white, double fontSize = 12.0}) {
    return Text(getBadgeText(cnt, maxCount: maxCount), style: TextStyle(color: textColor, fontSize: fontSize));
  }

  static bool badgeHasData(int data) {
    return data > 0;
  }

  static Future<void> saveImage(BuildContext context, String url) async {
    showDefaultLoadingWithBounds(context, text: "正在保存");
    bool saveResult = false;
    try {
      bool hasPermission = await PermissionUtil.checkAndRequestStorage(context);
      if (hasPermission) {
        saveResult = await Util.downloadAndSaveImageFromUrl(url);
      }
    } catch (e, stack) {
      saveResult = false;
      LogUtil.d(e);
    } finally {
      Navigator.pop(context);
      if (saveResult) {
        ToastUtil.showToast(context, '已保存到手机相册');
      } else {
        ToastUtil.showToast(context, '保存失败');
      }
    }
  }

  static Future<bool> downloadAndSaveImageFromUrl(String url) async {
    var response = await Dio().get(url, options: Options(responseType: ResponseType.bytes));
    try {
      var result = await ImageGallerySaver.saveImage(Uint8List.fromList(response.data), quality: 100);
      if (Platform.isAndroid) {
        return !StrUtil.isEmpty(result) && result.toString().startsWith("file");
      } else if (Platform.isIOS) {
        return true == result['isSuccess'];
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
      // ToastUtil.showToast(Application.context, e.toString());
    }
    return false;
  }

  static void loginOut(BuildContext context) async {
    Util.showDefaultLoading(context);

    if (Application.getDeviceId != null) {
      DeviceApi.removeDeviceInfo(Application.getAccountId, Application.getDeviceId);
    }
    Application.setLocalAccountToken(null);

    Application.setAccount(null);
    Application.setAccountId(null);

    await SpUtil.clear();
    // MessageUtil.close();

    // Provider.of<MsgProvider>(context, listen: false).clear();

    httpUtil.clearAuthToken();
    httpUtil2.clearAuthToken();
    NavigatorUtils.goBack(context);
    NavigatorUtils.push(context, LoginRouter.loginIndex, clearStack: true);
  }

  static String getEnumValue(a, {bool toUpperCase = true}) {
    String val = a.toString().substring(a.toString().indexOf('.') + 1);
    return toUpperCase ? val.toUpperCase() : val;
  }
}

Future<T?>? showElasticDialog<T>({
  required BuildContext context,
  bool barrierDismissible = true,
  required WidgetBuilder builder,
}) {
  final ThemeData theme = Theme.of(context);
  return showGeneralDialog(
    context: context,
    pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
      final Widget pageChild = Builder(builder: builder);
      return SafeArea(
        child: Builder(builder: (BuildContext context) {
          return pageChild;
        }),
      );
    },
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 550),
    transitionBuilder: _buildDialogTransitions,
  );
}

Widget _buildDialogTransitions(
    BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
  return FadeTransition(
    opacity: CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
    ),
    child: SlideTransition(
      position: Tween<Offset>(begin: const Offset(0.0, 0.3), end: Offset.zero).animate(CurvedAnimation(
        parent: animation,
        curve: animation.status != AnimationStatus.forward ? Curves.easeOutBack : const ElasticOutCurve(0.85),
      )),
      child: child,
    ),
  );
}
