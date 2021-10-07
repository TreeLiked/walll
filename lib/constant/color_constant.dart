import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wall/util/theme_util.dart';

/// 颜色常量
class Colours {
  static const Color mainColor = Color(0xFF8AE1FC);
  static const Color mainColorDark = Color(0xFF48B8D0);

  // 可点击的action btn
  static const Color actionClickable = Color(0xFF4facfe);

  static const Color textLinkColor = Color(0xFF1E90FF);

  static const Color emphasizeFontColor = Color(0xFF000000);
  static const Color emphasizeFontColorDark = Color(0xFFEFF1F3);

  static const Color normalFontColor = Color(0xFF606266);
  static const Color secondaryFontColor = Color(0xFF909399);
  static const Color holderFontColor = Color(0xFFC0C4CC);

  static const Color borderColorFirst = Color(0xFFF2F6FC);

  // static const Color borderColorFirstDark = Color(0xFFF2F6FC);
  static const Color borderColorSecond = Color(0xFFDCDFE6);
  static const Color borderColorFirstDark = Color(0xff202122);

  static const Color lightScaffoldColor = Color(0xFFFFFFFF);
  static const Color darkScaffoldColor = Color(0xFF121212);

  static const Color lighterGrey = Color(0xFFFAF9FA);

  static const Color lightIndicatorColor = Colors.amber;
  static const Color darkIndicatorColor = Colors.amber;

  static const Color maleMainColor = Color(0xFF7F95D1);
  static const Color feMaleMainColor = Color(0xFFFF82A9);

  static const Color greyIcon = Color(0xFFD5D6D7);
  static const Color greyText = Color(0xFFA5A6A7);

  static Color getMainColor(BuildContext context) {
    return ThemeUtil.isDark(context) ? mainColorDark : mainColor;
  }

  static Color getScaffoldColor(BuildContext context) {
    return ThemeUtil.isDark(context) ? darkScaffoldColor : lightScaffoldColor;
  }

  static Color getEmphasizedTextColor(BuildContext context) {
    return ThemeUtil.isDark(context) ? emphasizeFontColorDark : emphasizeFontColor;
  }

  static Color getFirstBorderColor(BuildContext context) {
    return ThemeUtil.isDark(context) ? borderColorFirstDark : borderColorFirst;
  }
}
