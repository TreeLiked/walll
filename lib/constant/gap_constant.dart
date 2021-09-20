import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wall/constant/color_constant.dart';

class Gaps {
  /// 水平间隔
  static const Widget hGap2 = SizedBox(width: 2.0);
  static const Widget hGap4 = SizedBox(width: 4.0);
  static const Widget hGap5 = SizedBox(width: 5.0);
  static const Widget hGap8 = SizedBox(width: 8.0);
  static const Widget hGap10 = SizedBox(width: 10.0);
  static const Widget hGap12 = SizedBox(width: 12.0);
  static const Widget hGap15 = SizedBox(width: 15.0);
  static const Widget hGap16 = SizedBox(width: 16.0);
  static const Widget hGap20 = SizedBox(width: 20.0);
  static const Widget hGap30 = SizedBox(width: 30.0);

  /// 垂直间隔
  static const Widget vGap4 = SizedBox(height: 4.0);
  static const Widget vGap2 = SizedBox(height: 2.0);
  static const Widget vGap5 = SizedBox(height: 5.0);
  static const Widget vGap8 = SizedBox(height: 8.0);
  static const Widget vGap10 = SizedBox(height: 10.0);
  static const Widget vGap12 = SizedBox(height: 12.0);
  static const Widget vGap15 = SizedBox(height: 15.0);
  static const Widget vGap16 = SizedBox(height: 16.0);
  static const Widget vGap30 = SizedBox(height: 30.0);
  static const Widget vGap20 = SizedBox(height: 20.0);
  static const Widget vGap25 = SizedBox(height: 25.0);
  static const Widget vGap50 = SizedBox(height: 50.0);

  static Widget line = const Divider();

  static Widget vLine = const SizedBox(width: 0.6, height: 24.0, child: VerticalDivider(color: Color(0xff707070)));

  static const Widget empty = SizedBox();
}
