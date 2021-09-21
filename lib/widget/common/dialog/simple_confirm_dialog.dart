import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wall/constant/size_constant.dart';
import 'package:wall/util/navigator_util.dart';
import 'package:wall/widget/common/button/my_text_btn.dart';
import 'package:wall/widget/common/dialog/base_dialog.dart';

class SimpleConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final String? confirmText;
  final VoidCallback? onConfirm;

  const SimpleConfirmDialog(this.title, this.content, {Key? key, this.confirmText, this.onConfirm})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
        title: title,
        showCancel: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(content, style: const TextStyle(fontSize: SizeCst.normalFontSize)),
        ),
        rightBtnItem:
            MyTextButton(text: Text(confirmText ?? "确认"), onPressed: () => NavigatorUtils.goBack(context)));
  }
}
