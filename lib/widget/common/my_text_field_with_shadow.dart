import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/constant/size_constant.dart';
import 'package:wall/widget/common/my_text_field.dart';

/// 登录模块的输入框封装
class MyShadowTextField extends StatefulWidget {
  const MyShadowTextField(
      {Key? key,
      required this.controller,
      this.maxLength = 16,
      this.autoFocus = false,
      this.keyboardType = TextInputType.text,
      this.hintText = "",
      this.focusNode,
      this.isInputPwd: false,
      this.getVCode,
      this.onChange,
      this.onSub,
      this.isShowDelete = true,
      this.bgColor,
      this.border,
      this.keyName})
      : super(key: key);

  final TextEditingController controller;
  final int maxLength;
  final bool autoFocus;
  final TextInputType keyboardType;
  final String hintText;
  final FocusNode? focusNode;
  final bool isInputPwd;
  final Future<bool> Function()? getVCode;
  final onChange;
  final onSub;
  final bool isShowDelete;
  final Color? bgColor;
  final InputBorder? border;

  /// 用于集成测试寻找widget
  final String? keyName;

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyShadowTextField> {
  @override
  void initState() {
    super.initState();

//    /// 获取初始化值
//    _isShowDelete = widget.controller.text.isEmpty;
//
//    /// 监听输入改变
//    widget.controller.addListener(() {
//      setState(() {
//        _isShowDelete = widget.controller.text.isEmpty;
//      });
//    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(() {});
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (widget.config != null && defaultTargetPlatform == TargetPlatform.iOS) {
    //   // 因Android平台输入法兼容问题，所以只配置IOS平台
    //
    //   // FormKeyboardActions.setKeyboardActions(context, widget.config);
    // }
    ThemeData themeData = Theme.of(context);
    bool isDark = themeData.brightness == Brightness.dark;
    return Container(
        decoration: BoxDecoration(
            color: isDark ? Colours.borderColorFirstDark : Colours.borderColorFirst,
            borderRadius: BorderRadius.circular(6.0)),
        child: Row(
          children: <Widget>[
            Expanded(
              child: MyTextField(
                  controller: widget.controller,
                  maxLength: widget.maxLength,
                  autoFocus: widget.autoFocus,
                  keyboardType: widget.keyboardType,
                  hintText: widget.hintText,
                  focusNode: widget.focusNode,
                  isInputPwd: widget.isInputPwd,
                  getVCode: widget.getVCode,
                  onChange: widget.onChange,
                  onSub: widget.onSub,
                  isShowDelete: widget.isShowDelete,
                  bgColor: widget.bgColor,
                  border: widget.border,
                  keyName: widget.keyName),
            )
          ],
        ));
  }
}
