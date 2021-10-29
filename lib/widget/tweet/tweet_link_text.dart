import 'package:extended_text/extended_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/painting/inline_span.dart';

class TweetLinkText extends SpecialText {
  static const String flag = "http";
  final int start;
  final bool showAtBackground;
  final SpecialTextGestureTapCallback? onTapText;

  TweetLinkText(TextStyle textStyle, {this.showAtBackground = false, required this.start, this.onTapText})
      : super(flag, " ", textStyle);

  @override
  InlineSpan finishText() {
    // TODO: implement finishText

    final String atText = toString();

    return showAtBackground
        ? BackgroundTextSpan(
            background: Paint()..color = Colors.blue.withOpacity(0.15),
            text: atText.trim(),
            actualText: atText,
            start: start,
            ///caret can move into special text
            deleteAll: true,
            style: textStyle,
            recognizer: (TapGestureRecognizer()
              ..onTap = () {
                if (onTapText != null) {
                  onTapText!(atText);
                }
              }))
        : SpecialTextSpan(
            text: atText,
            actualText: atText,
            start: start,
            style: textStyle,
            recognizer: (TapGestureRecognizer()
              ..onTap = () {
                if (onTapText != null) {
                  onTapText!(atText);
                }
              }));
  }
}
