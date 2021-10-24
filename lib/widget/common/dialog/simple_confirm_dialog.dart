import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wall/constant/size_constant.dart';
import 'package:wall/util/navigator_util.dart';
import 'package:wall/widget/common/button/long_flat_btn.dart';
import 'package:wall/widget/common/button/my_text_btn.dart';
import 'package:wall/widget/common/dialog/base_dialog.dart';
import 'package:wall/widget/common/dialog/simple_cancel_confirm_dialog.dart';

class SimpleConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final VoidCallback? onConfirm;
  final Color? confirmBgColor;

  const SimpleConfirmDialog(
      {Key? key, this.title = "", this.content = "", this.confirmText = "确认", this.onConfirm, this.confirmBgColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleCancelConfirmDialog(title, content,
        onConfirm: onConfirm ?? () => NavigatorUtils.goBack(context),
        confirmText: confirmText,
        confirmBgColor: confirmBgColor,
        showCancel: false);
  }
}
