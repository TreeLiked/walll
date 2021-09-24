import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/constant/size_constant.dart';
import 'package:wall/util/str_util.dart';
import 'package:wall/util/theme_util.dart';

import 'coll_util.dart';
import 'navigator_util.dart';

class Util {
  static String packConvertArgs(Map<String, Object> args) {
    if (CollectionUtil.isMapEmpty(args)) {
      return "";
    }
    StringBuffer buffer = new StringBuffer("?");
    // args.forEach((k, v) => buffer.write(k + "=" + FluroConvertUtils.fluroCnParamsEncode(v.toString()) + "&"));
    String str = buffer.toString();
    str = str.substring(0, str.length - 1);

    return str;
  }

  static void displayDialog(
    BuildContext context,
    Widget dialog, {
    bool barrierDismissible = false,
  }) {
    showDialog(context: context, barrierDismissible: barrierDismissible, builder: (_) => dialog);
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
              width: ScreenUtil().setWidth(100),
              height: ScreenUtil().setWidth(100),
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
    list.add(SpinKitSpinningLines(color: Colours.actionClickable, size: size,itemCount: 3));
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
}
