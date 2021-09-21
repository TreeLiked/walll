import 'package:flutter/material.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/util/theme_util.dart';

class LongFlatButton extends StatelessWidget {
  VoidCallback? onPressed;
  late final bool enabled;
  late final Text text;

  LongFlatButton({
    Key? key,
    required this.text,
    this.enabled = false,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDark = ThemeUtil.isDark(context);

    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          gradient: enabled
              ? LinearGradient(
                  colors: isDark
                      ? [const Color(0xaa4facfe), const Color(0xaa00f2fe)]
                      : [const Color(0xFF4facfe), const Color(0xFF00f2fe)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          color: enabled ? null : (isDark ? Colours.borderColorFirstDark : Colours.borderColorSecond),
        ),
        child: TextButton(
            child: text,
            // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            // color: _canGetCode ? Colors.amber : null,
            // padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            // disabledColor: !isDark ? Color(0xffD7D6D9) : Colours.dark_bg_color_darker,
            onPressed: enabled ? onPressed : null));
  }
}
