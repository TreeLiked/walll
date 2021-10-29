import 'dart:ui';

import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/painting/text_style.dart';
import 'package:wall/application.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/util/navigator_util.dart';
import 'package:wall/widget/tweet/tweet_at_text.dart';
import 'package:wall/widget/tweet/tweet_link_text.dart';

class TweetSpecialTextSpanBuilder extends SpecialTextSpanBuilder {
  /// whether show background for @somebody
  final bool showAtBackground;
  final SpecialTextGestureTapCallback? onTap;

  TweetSpecialTextSpanBuilder({this.showAtBackground = false, this.onTap});

  @override
  SpecialText? createSpecialText(String flag, {TextStyle? textStyle, onTap, int? index}) {
    ///index is end index of start flag, so text start index should be index-(flag.length-1)
    if (isStart(flag, TweetLinkText.flag)) {
      return TweetLinkText(
          const TextStyle(
              color: Colours.textLinkColor, fontSize: 15, height: 1.6, decoration: TextDecoration.underline),
          onTapText: (text) => NavigatorUtils.goWebViewPage(Application.context!, text, text.trim()),
          start: index! - (TweetLinkText.flag.length - 1),
          showAtBackground: showAtBackground);
    } else if (isStart(flag, TweetAtText.flag)) {
      return TweetAtText(const TextStyle(color: Colors.amber, height: 1.6, fontSize: 15), (_) => {},
          start: index! - (TweetAtText.flag.length - 1), showAtBackground: showAtBackground);
    }
    return null;
  }

//  MyLinkTextSpanBuilder(
//      {this.showAtBackground: false, this.type: BuilderType.extendedText});
//
//  @override
//  TextSpan build(String data, {TextStyle textStyle, onTap}) {
//    var textSpan = super.build(data, textStyle: textStyle, onTap: onTap);
//    return textSpan;
//  }
//
//  @override
//  SpecialText createSpecialText(String flag,
//      {TextStyle textStyle, SpecialTextGestureTapCallback onTap, int index}) {

//  }
}
