import 'package:flutter/material.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/constant/gap_constant.dart';
import 'package:wall/widget/common/button/long_flat_btn.dart';

class BottomLeftRightDialog extends StatelessWidget {
  final String? title;
  final String content;
  final String rightText;
  final String leftText;
  final Color? rightBgColor;
  final VoidCallback? onClickLeft;
  final VoidCallback? onClickRight;
  final bool average;
  final Widget? leftItem;
  final Widget? rightItem;
  final bool showLeft;

  const BottomLeftRightDialog(
      {Key? key,
      this.title,
      required this.content,
      this.rightText = "确认",
      this.leftText = '取消',
      this.onClickLeft,
      this.onClickRight,
      this.rightBgColor,
      this.average = false,
      this.showLeft = true,
      this.leftItem,
      this.rightItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 30.0, top: 30),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          title == null || title == ""
              ? Gaps.empty
              : Container(
                  margin: const EdgeInsets.only(bottom: 15.0),
                  child: Text(title!, style: const TextStyle(fontSize: 13.5, color: Colours.secondaryFontColor))),
          Text(content,
              style: TextStyle(
                  color: Colours.getEmphasizedTextColor(context), fontSize: 14.0, fontWeight: FontWeight.bold)),
          Gaps.vGap50,
          Row(
            children: [
              showLeft
                  ? Expanded(
                      flex: average ? 3 : 1,
                      child: leftItem ??
                          LongFlatButton(
                              text: Text(leftText, style: const TextStyle(color: Colours.secondaryFontColor)),
                              enabled: true,
                              needGradient: false,
                              onPressed: onClickLeft,
                              bgColor: Colours.getFirstBorderColor(context)))
                  : Gaps.empty,
              showLeft ? Gaps.hGap30 : Gaps.empty,
              Expanded(
                  flex: 3,
                  child: rightItem ??
                      LongFlatButton(
                        onPressed: onClickRight,
                        text: Text(rightText, style: const TextStyle(color: Colors.white)),
                        needGradient: rightBgColor == null,
                        bgColor: rightBgColor,
                        enabled: true,
                      )),
            ],
          )
        ]));
  }
}
