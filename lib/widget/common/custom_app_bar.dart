import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/constant/gap_constant.dart';
import 'package:wall/util/asset_util.dart';
import 'package:wall/util/theme_util.dart';

/// 自定义AppBar
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar(
      {Key? key,
      this.actionColor,
      this.background,
      this.title = "",
      this.centerTitle = "",
      this.actionName = "",
      this.actionWidget,
      this.backSvgPath = "common/arrow_left",
      this.onPressed,
      this.isBack = true})
      : super(key: key);

  final Color? actionColor;
  final Color? background;
  final String title;
  final String centerTitle;
  final String backSvgPath;
  final String actionName;
  final VoidCallback? onPressed;
  final Widget? actionWidget;
  final bool isBack;

  @override
  Widget build(BuildContext context) {
    bool isDark = ThemeUtil.isDark(context);

    return SafeArea(
        child: Stack(alignment: Alignment.centerLeft, children: <Widget>[
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: centerTitle.isEmpty ? Alignment.centerLeft : Alignment.center,
            width: double.infinity,
            child: Text(title.isEmpty ? centerTitle : title,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    letterSpacing: 1.1,
                    color: Colours.getEmphasizedTextColor(context))),
            padding: const EdgeInsets.symmetric(horizontal: 48.0),
          )
        ],
      ),
      isBack
          ? IconButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                Navigator.maybePop(context);
              },
              tooltip: '返回',
              padding: const EdgeInsets.all(12.0),
              icon: LoadAssetSvg(backSvgPath, width: 20, height: 20, color: isDark ? Colors.white : Colors.black))
          : Gaps.empty,
      Positioned(
          right: 8.0,
          child: actionWidget ??
              (actionName.isEmpty
                  ? Gaps.empty
                  : TextButton(
                      child: Text(
                        actionName,
                        key: const Key('actionName'),
                        style: TextStyle(fontSize: 13.5, color: onPressed == null ? Colors.grey : Colours.mainColor),
                      ),
                      onPressed: onPressed)))
    ]));
  }

  @override
  Size get preferredSize => Size.fromHeight(48.0);
}
