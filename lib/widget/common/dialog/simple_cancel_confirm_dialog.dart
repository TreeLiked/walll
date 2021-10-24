import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wall/constant/size_constant.dart';
import 'package:wall/util/navigator_util.dart';
import 'package:wall/widget/common/button/my_text_btn.dart';
import 'package:wall/widget/common/dialog/base_dialog.dart';
import 'package:wall/widget/common/dialog/bottom_cancel_confirm.dart';

class SimpleCancelConfirmDialog extends StatelessWidget {
  final String title;
  final String content;

  final bool showCancel;
  final String cancelText;
  final String confirmText;
  final Color? confirmBgColor;
  final VoidCallback onConfirm;

  const SimpleCancelConfirmDialog(this.title, this.content,
      {Key? key,
      required this.onConfirm,
      this.cancelText = '取消',
      this.confirmText = '确认',
      this.confirmBgColor,
      this.showCancel = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomLeftRightDialog(
        title: title,
        content: content,
        leftText: cancelText,
        rightText: confirmText,
        rightBgColor: confirmBgColor,
        showLeft: showCancel,
        onClickLeft: () => NavigatorUtils.goBack(context),
        onClickRight: onConfirm);
  }
}
