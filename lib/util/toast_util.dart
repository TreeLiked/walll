import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wall/application.dart';
import 'package:wall/constant/size_constant.dart';
import 'package:wall/constant/text_constant.dart';
import 'package:wall/util/navigator_util.dart';

import 'theme_util.dart';

class ToastUtil {
  static void showToastNew(String text,
      {Toast length = Toast.LENGTH_LONG, ToastGravity gravity = ToastGravity.CENTER}) {
    showToast(Application.context!, text, length: length, gravity: gravity);
  }

  static void showToast(BuildContext? context, String? text,
      {Toast length = Toast.LENGTH_LONG, ToastGravity gravity = ToastGravity.CENTER, bool goBack = false}) {
    bool dark = false;
    dark = ThemeUtil.isDark(context ?? Application.context!);

    Fluttertoast.showToast(
      msg: '    $text    ',
      fontSize: SizeCst.toastFontSize,
      gravity: gravity,
      toastLength: length,
      backgroundColor: dark ? Colors.black87 : Colors.black54,
      textColor: dark ? Colors.white : Colors.white,
    );
    if (goBack) {
      NavigatorUtils.goBack(context ?? Application.context!);
    }
  }

  static void showServiceExpToast(BuildContext context) {
    showToast(context, TextCst.serviceError, length: Toast.LENGTH_LONG);
  }
}
