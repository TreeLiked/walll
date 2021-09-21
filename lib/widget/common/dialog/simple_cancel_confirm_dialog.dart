import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wall/constant/size_constant.dart';
import 'package:wall/widget/common/button/my_text_btn.dart';
import 'package:wall/widget/common/dialog/base_dialog.dart';

class SimpleCancelConfirmDialog extends StatelessWidget {
  final String title;
  final String content;

  final MyTextButton leftBtn;
  final MyTextButton rightBtn;

  SimpleCancelConfirmDialog(this.title, this.content, this.leftBtn, this.rightBtn, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
        title: title,
        showCancel: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(content, style: const TextStyle(fontSize: SizeCst.normalFontSize)),
        ),
        leftBtnItem: leftBtn,
        rightBtnItem: rightBtn);
  }
}
