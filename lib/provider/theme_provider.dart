import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/constant/shared_constant.dart';
import 'package:wall/constant/size_constant.dart';

class ThemeProvider extends ChangeNotifier {
  static const Map<Themes, String> themes = {
    Themes.dark: "Dark",
    Themes.light: "Light",
    Themes.system: "System"
  };

  void syncTheme() {
    String? themeStr = SpUtil.getString(SharedCst.theme);
    themeStr = "Dark";
    notifyListeners();
    if (themeStr != null && themeStr != themes[Themes.system]) {
      notifyListeners();
    }
  }

  void setTheme(Themes theme) {
    SpUtil.putString(SharedCst.theme, themes[theme]!);
    notifyListeners();
  }

  getTheme({bool isDarkMode = false}) {
    String? theme = SpUtil.getString(SharedCst.theme);
    switch (theme) {
      case "Dark":
        isDarkMode = true;
        break;
      case "Light":
        isDarkMode = false;
        break;
      default:
        break;
    }

    return ThemeData(
        // errorColor: isDarkMode ? Colours.dark_red : Colours.red,
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        primaryColor: isDarkMode ? Colours.mainColorDark : Colours.mainColor,
        primaryIconTheme: IconThemeData(color: isDarkMode ? Colors.grey : Colors.black),
        // Tab指示器颜色
        indicatorColor: isDarkMode ? Colours.darkIndicatorColor : Colours.lightIndicatorColor,
        // 页面背景色
        scaffoldBackgroundColor: isDarkMode ? Colours.darkScaffoldColor : Colours.lightScaffoldColor,
        // 主要用于Material背景色
        canvasColor: isDarkMode ? Colours.darkScaffoldColor : Colours.lightScaffoldColor,

        // 文字选择色（输入框复制粘贴菜单）
        textTheme: TextTheme(
          // TextField输入文字颜色
          bodyText2: TextStyle(color: isDarkMode ? Colors.white : Colours.emphasizeFontColor, fontSize: SizeCst.normalFontSize),
          // Text文字样式
          // subtitle1: isDarkMode ? TextStyles.textDark : TextStyles.text,
          // subtitle2: isDarkMode ? TextStyles.textDarkGray12 : TextStyles.textGray12,
        ),
        inputDecorationTheme: InputDecorationTheme(
            // hintStyle: isDarkMode ? TextStyles.textHint14 : TextStyles.textDarkGray14,
            ),
        appBarTheme: AppBarTheme(
          elevation: 0.0,
          // color: isDarkMode ? ThemeConstant.darkBG : ThemeConstant.lightBG,
          // brightness: isDarkMode ? Brightness.dark : Brightness.light,
        ),
        primaryTextTheme: TextTheme(
            bodyText2: isDarkMode
                ? const TextStyle(color: Colors.grey, fontSize: 160, fontWeight: FontWeight.w400)
                : const TextStyle(color: Colors.black, fontSize: 160, fontWeight: FontWeight.w400)),
        dividerTheme: DividerThemeData(
            // color: isDarkMode ? Colours.dark_line : Colours.line, space: 0.6, thickness: 0.6
            ));
  }
}

enum Themes { dark, light, system }
