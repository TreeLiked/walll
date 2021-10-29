import 'package:extended_text/extended_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/painting/inline_span.dart';

class TweetAtText extends SpecialText {
  static const String flag = "@";
  final int start;
  final bool showAtBackground;

  TweetAtText(TextStyle textStyle, SpecialTextGestureTapCallback onTap,
      {this.showAtBackground = false, required this.start})
      : super(flag, " ", textStyle);

  @override
  InlineSpan finishText() {
    final String atText = toString();

    return showAtBackground
        ? BackgroundTextSpan(
            background: Paint()..color = Colors.blue.withOpacity(0.15),
            text: atText,
            actualText: atText,
            start: start,
            deleteAll: true,
            style: textStyle,
            recognizer: (TapGestureRecognizer()
              ..onTap = () {
                if (onTap != null) {
                  onTap!(atText);
                }
              }))
        : SpecialTextSpan(
            text: atText,
            actualText: atText,
            start: start,
            style: textStyle,
            recognizer: (TapGestureRecognizer()
              ..onTap = () {
                if (onTap != null) {
                  onTap!(atText);
                }
              }));
  }
}
