import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/constant/gap_constant.dart';
import 'package:wall/util/str_util.dart';
import 'package:wall/util/theme_util.dart';
import 'package:wall/widget/tweet/tweet_special_text_builder.dart';

class TweetBodyWrapper extends StatelessWidget {
  final String? body;
  final double fontSize;
  final double height;
  final bool selectable;
  final int maxLine;

  const TweetBodyWrapper(this.body,
      {Key? key, this.fontSize = 15.5, this.maxLine = -1, this.height = -1, this.selectable = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDark = ThemeUtil.isDark(context);

    if (StrUtil.isEmpty(body)) {
      return Gaps.empty;
    }
    return Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: ExtendedText(body!,
            maxLines: maxLine == -1 ? null : maxLine,
            softWrap: true,
            textAlign: TextAlign.left,
            specialTextSpanBuilder: TweetSpecialTextSpanBuilder(showAtBackground: false),
            selectionEnabled: selectable,
            overflowWidget: maxLine == -1
                ? null
                : TextOverflowWidget(
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                        Gaps.hGap4,
                        Text("更多", style: TextStyle(color: Colours.secondaryFontColor, fontSize: fontSize))
                      ])),
            style: TextStyle(fontSize: fontSize, height: height, color: Colours.getEmphasizedTextColor(context))));
  }
}