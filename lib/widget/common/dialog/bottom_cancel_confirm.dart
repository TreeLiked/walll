import 'package:flutter/material.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/constant/gap_constant.dart';
import 'package:wall/widget/common/button/long_flat_btn.dart';

class BottomCancelConfirmDialog extends StatelessWidget {
  final String? title;
  final String content;
  final String confirmText;
  final String cancelText;
  final Color? confirmBgColor;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;
  final bool average;
  final Widget? cancelItem;

  const BottomCancelConfirmDialog(
      {Key? key,
      this.title,
      required this.content,
      this.confirmText = "确认",
      this.cancelText = '取消',
      this.onCancel,
      this.onConfirm,
      this.confirmBgColor,
      this.average = false,
      this.cancelItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          title == null
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
              Expanded(
                  flex: average ? 3 : 1,
                  child: average
                      ? cancelItem!
                      : LongFlatButton(
                          text: Text(cancelText, style: const TextStyle(color: Colours.secondaryFontColor)),
                          enabled: true,
                          needGradient: false,
                          onPressed: onCancel,
                          bgColor: Colours.getFirstBorderColor(context))),
              Gaps.hGap30,
              Expanded(
                  flex: 3,
                  child: LongFlatButton(
                    onPressed: onConfirm,
                    text: Text(confirmText, style: const TextStyle(color: Colors.white)),
                    needGradient: confirmBgColor == null,
                    bgColor: confirmBgColor,
                    enabled: true,
                  )),
            ],
          )
        ]));
  }
}
