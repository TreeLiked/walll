import 'package:flutter/material.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/constant/gap_constant.dart';
import 'package:wall/widget/common/button/my_text_btn.dart';
import 'package:wall/widget/common/v_empty_view.dart';

/// 自定义dialog的模板
class BaseDialog extends StatelessWidget {
  BaseDialog(
      {Key? key,
      required this.title,
      this.leftBtnItem,
      required this.rightBtnItem,
      this.showCancel = true,
      this.hiddenTitle = false,
      required this.child})
      : super(key: key);

  late final String title;
  late final Widget child;
  final bool hiddenTitle;
  final bool showCancel;
  final MyTextButton? leftBtnItem;
  final MyTextButton rightBtnItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //创建透明层
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      // 键盘弹出收起动画过渡
      body: AnimatedContainer(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeInCubic,
        child: Container(
            decoration: BoxDecoration(
              color: Colours.getScaffoldColor(context),
              borderRadius: BorderRadius.circular(8.0),
            ),
            width: 270.0,
            padding: const EdgeInsets.only(top: 15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Offstage(
                  offstage: hiddenTitle,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      hiddenTitle ? "" : title,
                      style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Flexible(child: child),
                Gaps.vGap8,
                Gaps.line,
                Row(
                  children: <Widget>[
                    showCancel
                        ? Expanded(
                            child: SizedBox(height: 48.0, child: leftBtnItem),
                          )
                        : const VEmptyView(0),
                    const SizedBox(
                      height: 48.0,
                      width: 0.6,
                      child: VerticalDivider(),
                    ),
                    Expanded(
                      child: SizedBox(height: 48.0, child: rightBtnItem),
                    )
                  ],
                )
              ],
            )),
      ),
    );
  }
}
