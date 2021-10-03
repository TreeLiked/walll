import 'package:flutter/material.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/util/theme_util.dart';

class ShadowContainer extends StatelessWidget {
  const ShadowContainer(
      {Key? key,
      required this.child,
      this.bgColor,
      this.shadowColor,
      this.margin = const EdgeInsets.only(top: 6.0),
      this.padding = const EdgeInsets.all(6.0),
      this.radius = 11.0,
      this.onClick})
      : super(key: key);

  final Widget child;
  final Color? bgColor;
  final Color? shadowColor;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final GestureTapCallback? onClick;
  final double radius;

  @override
  Widget build(BuildContext context) {
    Color _backgroundColor;
    Color _shadowColor;
    bool isDark = ThemeUtil.isDark(context);

    if (shadowColor == null) {
      // _shadowColor = isDark ? Colors.transparent : Colors.grey;
      // _shadowColor = isDark ? Colors.transparent : const Color(0xFFe6e7ed);
      _shadowColor = isDark ? const Color(0xFF333333) : const Color(0xFFDADDE5);
    } else {
      _shadowColor = shadowColor!;
    }
    _backgroundColor = bgColor ?? Colours.getScaffoldColor(context);

    return onClick != null
        ? GestureDetector(
            onTap: onClick,
            child: Container(
                margin: margin,
                padding: padding,
                decoration:
                    BoxDecoration(color: _backgroundColor, borderRadius: BorderRadius.circular(radius), boxShadow: [
                  BoxShadow(color: _shadowColor, offset: const Offset(0.0, 5.0), blurRadius: 8.0, spreadRadius: 0.0),
                ]),
                child: child),
          )
        : Container(
            margin: margin,
        padding: padding,
        decoration: BoxDecoration(color: _backgroundColor, borderRadius: BorderRadius.circular(radius), boxShadow: [
              BoxShadow(color: _shadowColor, offset: const Offset(0.0, 5.0), blurRadius: 8.0, spreadRadius: 0.0),
            ]),
            child: child);
  }
}
