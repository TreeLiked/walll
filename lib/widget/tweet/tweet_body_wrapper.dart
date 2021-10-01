import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/constant/gap_constant.dart';
import 'package:wall/util/str_util.dart';
import 'package:wall/util/theme_util.dart';

class TweetBodyWrapper extends StatelessWidget {
  final String? body;
  final double fontSize;
  final double height;
  final bool selectable;
  final int maxLine;

  const TweetBodyWrapper(this.body,
      {this.fontSize = 15.0, this.maxLine = -1, this.height = -1, this.selectable = false});

  @override
  Widget build(BuildContext context) {
    bool isDark = ThemeUtil.isDark(context);

    if (StrUtil.isEmpty(body)) {
      return Gaps.empty;
    }
    return ExtendedText(body!,
        // child: ExtendedText("$body",
        maxLines: maxLine == -1 ? null : maxLine,
        softWrap: true,
        textAlign: TextAlign.left,
        // TODO 链接
        // specialTextSpanBuilder: MySpecialTextSpanBuilder(
        //     showAtBackground: false,
        //     onTapCb: (String text) {
        //       if (text != null && text.length > 0) {
        //         if (text.startsWith("http")) {
        //           NavigatorUtils.goWebViewPage(context, text, text.trim());
        //         }
        //       }
        //     }),
        selectionEnabled: selectable,
        overflowWidget: maxLine == -1
            ? null
            : TextOverflowWidget(
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                    Text("更多", style: TextStyle(color: Colours.secondaryFontColor, fontSize: fontSize))
                  ])),
        style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w400,
            height: height,
            color: Colours.getEmphasizedTextColor(context)));
  }
}
