import 'package:extended_text/extended_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wall/application.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/constant/gap_constant.dart';
import 'package:wall/util/navigator_util.dart';
import 'package:wall/util/theme_util.dart';

import 'common_util.dart';

class BottomSheetItem {
  final Icon icon;
  final String text;
  final callback;

  BottomSheetItem(this.icon, this.text, this.callback);
}

class BottomSheetUtil {
  // static void showBottmSheetView(
  //     BuildContext context, List<BottomSheetItem> items) {
  //   showDialog(
  //       context: context,
  //       barrierDismissible: true,
  //       builder: (BuildContext context) {
  //         return Scaffold(
  //           //创建透明层

  //           backgroundColor: Colors.transparent, //透明类型
  //           body: AnimatedContainer(
  //               alignment: Alignment.center,
  //               height: MediaQuery.of(context).size.height -
  //                   MediaQuery.of(context).viewInsets.bottom,
  //               duration: const Duration(milliseconds: 120),
  //               curve: Curves.easeInCubic,
  //               child: Stack(
  //                 children: <Widget>[
  //                   Positioned(
  //                     bottom: 0,
  //                     left: 0,
  //                     child: Container(
  //                         decoration: BoxDecoration(
  //                           // color: ThemeUtils.getDialogBackgroundColor(context),
  //                           color: Colors.white,
  //                           borderRadius: BorderRadius.circular((8.0)),
  //                         ),
  //                         // width: 280.0,
  //                         height: 100.0,
  //                         child: Column(
  //                           children: <Widget>[Text('jdasjkdsa')],
  //                         )),
  //                   )
  //                 ],
  //               )),
  //         );
  //       });
  // }
  static void showBottomSheetView(BuildContext context, List<BottomSheetItem> items) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (builder) {
          return StatefulBuilder(builder: (context1, state) {
            return Stack(
              children: <Widget>[
                Container(
                    // height: 350,
                    // constraints: BoxConstraints(maxHeight: 500),
                    decoration: BoxDecoration(
                        color: Colours.getScaffoldColor(context),
                        // color: ThemeUtil.isLight(context) ? const Color(0xffEBECED) : const Color(0xFF151515),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(14))),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Wrap(
                              alignment: WrapAlignment.start,
                              runAlignment: WrapAlignment.start,
                              runSpacing: 10.0,
                              children: _renderItems(context, items)),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                child: Container(
                                  margin: const EdgeInsets.only(top: 15),
                                  width: Application.screenWidth! * 0.95 - 30,
                                  child: CupertinoButton(
                                    padding: const EdgeInsets.all(0),
                                    onPressed: () => NavigatorUtils.goBack(context),
                                    child: const Text('取消', style: TextStyle(fontSize: 13.5)),
                                  ),
                                ),
                              )
                            ],
                          ),
                          // Expanded(
                          //   child: Container(
                          //       child: Wrap(
                          //     spacing: 2,
                          //     alignment: WrapAlignment.start,
                          //     runAlignment: WrapAlignment.spaceEvenly,
                          //     runSpacing: 5,
                          //     children: <Widget>[],
                          //   )),
                          // )
                        ],
                      ),
                    )),
              ],
            );
          });
        });
  }

  static void showBottomSheet(BuildContext context, double heightFactor, Widget content,
      {bool topLine = true, Widget? topWidget}) {
    bool isDark = ThemeUtil.isDark(context);
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (builder) {
          return StatefulBuilder(builder: (context1, state) {
            return Stack(
              children: <Widget>[
                Container(
                    height: Application.screenHeight! * heightFactor,
                    decoration: BoxDecoration(
                        color: Colours.getScaffoldColor(context),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(14))),
                    child: Stack(
                      children: <Widget>[
                        topLine
                            ? Positioned(
                                left: (Application.screenWidth! - 50) / 2,
                                top: 10.0,
                                child: Container(
                                    height: 5.0,
                                    width: 50.0,
                                    decoration: BoxDecoration(
                                        color: const Color(0xffaeb4bd), borderRadius: BorderRadius.circular(73.0))),
                              )
                            : (topWidget ?? Gaps.empty),
                        SafeArea(
                            top: false,
                            child: Container(
                              margin: EdgeInsets.only(top: topLine ? 20.0 : (topWidget == null ? 10.0 : 50.0)),
                              child: SingleChildScrollView(
                                child: content,
                              ),
                            ))
                      ],
                    ))
              ],
            );
          });
        });
  }

  static List<Widget> _renderItems(BuildContext context, List<BottomSheetItem> items) {
    return items.map((f) => _renderSingleItem(context, f)).toList();
  }

  static Widget _renderSingleItem(BuildContext context, BottomSheetItem item) {
    return InkWell(
        onTap: () => item.callback(),
        child: Container(
            margin: const EdgeInsets.only(right: 15),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: ThemeUtil.isLight(context) ? Colors.white : const Color(0xFF262626),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: item.icon),
              Gaps.vGap10,
              Text(item.text, style: TextStyle(fontSize: 12, color: Colours.getEmphasizedTextColor(context)))
            ])));
  }
}
