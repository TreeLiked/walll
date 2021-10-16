import 'package:flutter/material.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/constant/gap_constant.dart';

class SquareTag extends StatelessWidget {
  final Color? backgroundColor;
  final double verticalPadding;
  final double horizontalPadding;
  final double roundRadius;
  final Widget? prefixIcon;
  final Widget child;

  const SquareTag(
      {Key? key,
      required this.child,
      this.backgroundColor,
      this.verticalPadding = 1.0,
      this.horizontalPadding = 0.0,
      this.prefixIcon,
      this.roundRadius = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // bool isDark = ThemeUtil.isDark(context);
    return Container(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
        decoration: BoxDecoration(
            color: backgroundColor ?? Colours.getTagBgColor(context),
            borderRadius: roundRadius != 0 ? BorderRadius.circular(roundRadius) : null),
        child: prefixIcon == null
            ? child
            : Row(mainAxisSize: MainAxisSize.min, children: <Widget>[prefixIcon!, Gaps.hGap4, child]));
  }
}
