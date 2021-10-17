import 'package:flutter/material.dart';
import 'package:wall/constant/gap_constant.dart';
import 'package:wall/util/str_util.dart';
import 'package:wall/util/theme_util.dart';

class SimpleTag extends StatelessWidget {
  final Color bgColor;
  final Color bgDarkColor;
  final Color textColor;
  final String? text;
  final bool round;
  final double horizontalPadding;
  final double verticalPadding;
  final double leftMargin;
  final double radius;

  const SimpleTag(this.text,
      {Key? key,
      this.bgColor = Colors.white,
      this.bgDarkColor = Colors.black,
      this.textColor = Colors.grey,
      this.radius = 0,
      this.round = true,
      this.verticalPadding = 1.0,
      this.horizontalPadding = 5.0,
      this.leftMargin = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (StrUtil.isEmpty(text)) {
      return Gaps.empty;
    }
    bool isDark = ThemeUtil.isDark(context);
    return Container(
        margin: EdgeInsets.only(left: leftMargin),
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
        decoration: BoxDecoration(
            color: isDark ? bgDarkColor : bgColor,
            borderRadius:
                round ? BorderRadius.vertical(top: Radius.circular(radius), bottom: Radius.circular(radius)) : null),
        child: Text(
          text ?? "",
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: textColor),
        ));
  }
}
