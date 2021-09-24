import 'package:flutter/material.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/constant/size_constant.dart';
import 'package:wall/util/theme_util.dart';

class MyTextButton extends StatelessWidget {
  VoidCallback? onPressed;
  late final bool enabled;
  late final Text text;

  MyTextButton({
    Key? key,
    required this.text,
    this.enabled = false,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDark = ThemeUtil.isDark(context);

    return TextButton(
        child: text,
        style: ButtonStyle(
          //定义文本的样式 这里设置的颜色是不起作用的
          textStyle: MaterialStateProperty.all(const TextStyle(fontSize: SizeCst.normalFontSize)),

          //设置按钮上字体与图标的颜色
          //foregroundColor: MaterialStateProperty.all(Colors.deepPurple),
          //更优美的方式来设置
          // foregroundColor: MaterialStateProperty.resolveWith(
          //   (states) {
          //     if (states.contains(MaterialState.focused) && !states.contains(MaterialState.pressed)) {
          //       //获取焦点时的颜色
          //       return Colors.blue;
          //     } else if (states.contains(MaterialState.pressed)) {
          //       //按下时的颜色
          //       return Colors.deepPurple;
          //     }
          //     //默认状态使用灰色
          //     return Colors.grey;
          //   },
          // ),
          //背景颜色
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            //设置按下时的背景颜色
            if (states.contains(MaterialState.pressed)) {
              return isDark ? Colours.darkScaffoldColor : Colours.lightScaffoldColor;
            }
            //默认不使用背景颜色
            return null;
          }),
          //设置水波纹颜色
          // overlayColor: MaterialStateProperty.all(Colors.yellow),
          //设置阴影  不适用于这里的TextButton
          elevation: MaterialStateProperty.all(0),
          //设置按钮内边距
          // padding: MaterialStateProperty.all(EdgeInsets.all(10)),
          //设置按钮的大小
          // minimumSize: MaterialStateProperty.all(Size(200, 100)),

          //设置边框
          // side: MaterialStateProperty.all(BorderSide(color: Colors.grey, width: 1)),
          //外边框装饰 会覆盖 side 配置的样式
          // shape: MaterialStateProperty.all(StadiumBorder()),
        ),
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        // color: enabled ? (isDark ? const Color(0xaa4facfe) : const Color(0xFF4facfe)) : Colors.grey,
        // padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        // disabledColor: !isDark ? Color(0xffD7D6D9) : Colours.dark_bg_color_darker,
        onPressed: enabled ? onPressed : null);
  }
}
