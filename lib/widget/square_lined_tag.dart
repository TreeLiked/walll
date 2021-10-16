import 'package:flutter/material.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/constant/gap_constant.dart';

class SquareBorderedTag extends StatelessWidget {
  final Color borderColor;
  final double borderWidth;
  final String text;
  final TextStyle textStyle;
  final double verticalPadding;
  final double horizontalPadding;
  final double roundRadius;
  final Widget? prefixIcon;

  const SquareBorderedTag(this.text,
      {Key? key,
      this.borderColor = const Color(0xfff1f0f1),
        this.borderWidth = 1.0,
      this.verticalPadding = 1.0,
      this.horizontalPadding = 0.0,
      this.textStyle = const TextStyle(
        fontSize: 13.0,
        fontWeight: FontWeight.w300,
        color: Colors.grey,
      ),
      this.prefixIcon,
      this.roundRadius = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // bool isDark = ThemeUtil.isDark(context);
    return Container(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
        decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: borderWidth),
            color: Colors.transparent,
            borderRadius: roundRadius != 0 ? BorderRadius.circular(roundRadius) : null),
        child: prefixIcon == null
            ? Text(text, style: textStyle)
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[prefixIcon!, Gaps.hGap4, Text(text, style: textStyle)],
              ));
  }
}
