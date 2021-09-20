import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:wall/constant/size_constant.dart';

/// 登录模块的输入框封装
class MyTextField extends StatefulWidget {
  const MyTextField(
      {Key? key,
      required this.controller,
      this.maxLength: 16,
      this.autoFocus: false,
      this.keyboardType: TextInputType.text,
      this.hintText: "",
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

class _MyTextFieldState extends State<MyTextField> {
  bool _isShowPwd = false;

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
//    _subscription?.cancel();
    widget.controller.removeListener(() {});
    widget.controller.dispose();
    super.dispose();
  }

//  Future _getVCode() async {
//    bool isSuccess = await widget.getVCode();
//    if (isSuccess != null && isSuccess) {
//      setState(() {
//        s = second;
//        _isClick = false;
//      });
//      _subscription = Observable.periodic(Duration(seconds: 1), (i) => i).take(second).listen((i) {
//        setState(() {
//          s = second - i - 1;
//          _isClick = s < 1;
//        });
//      });
//    }
//  }

  @override
  Widget build(BuildContext context) {
    // if (widget.config != null && defaultTargetPlatform == TargetPlatform.iOS) {
    //   // 因Android平台输入法兼容问题，所以只配置IOS平台
    //
    //   // FormKeyboardActions.setKeyboardActions(context, widget.config);
    // }
    ThemeData themeData = Theme.of(context);
    bool isDark = themeData.brightness == Brightness.dark;
    return Stack(
      alignment: Alignment.centerRight,
      children: <Widget>[
        TextField(
            keyboardAppearance: Theme.of(context).brightness,
            focusNode: widget.focusNode,
            maxLength: widget.maxLength,
            obscureText: widget.isInputPwd ? !_isShowPwd : false,
            autofocus: widget.autoFocus,
            controller: widget.controller,
//          style:
//              TextStyle(color: widget.keyboardType == TextInputType.text ? Colors.black87 : Colors.white70),

            style: const TextStyle(fontSize: SizeCst.normalFontSize),
            textInputAction: TextInputAction.done,
            keyboardType: widget.keyboardType,
            // 数字、手机号限制格式为0到9(白名单)， 密码限制不包含汉字（黑名单）
            inputFormatters:
                (widget.keyboardType == TextInputType.number || widget.keyboardType == TextInputType.phone)
                    ? [WhitelistingTextInputFormatter(RegExp("[0-9]"))]
                    : (widget.keyboardType != TextInputType.text
                        ? [BlacklistingTextInputFormatter(RegExp("[\u4e00-\u9fa5]"))]
                        : null),
            onChanged: (val) => widget.onChange(val),
            onSubmitted: (val) => widget.onSub != null ? widget.onSub(val) : null,
            decoration: InputDecoration(
                border: widget.border ?? null,
                fillColor: widget.bgColor,
//                fillColor: widget.bgColor,
                filled: widget.bgColor != null,
//                filled: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8),
                hintText: widget.hintText,
                counterText: "",
                focusedBorder: InputBorder.none,
                enabledBorder: widget.border != null ? null : InputBorder.none)),
      ],
    );
  }
}
