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
      this.centerTitle = true,
      this.actionName = "",
      this.actionWidget,
      this.backSvgPath = "common/arrow_left",
      this.actionOnPressed,
      this.isBack = true})
      : super(key: key);

  final String title;
  final bool centerTitle;
  final Color? background;

  final bool isBack;
  final String backSvgPath;

  final Color? actionColor;
  final String? actionName;
  final Widget? actionWidget;
  final VoidCallback? actionOnPressed;

  @override
  Widget build(BuildContext context) {
    bool isDark = ThemeUtil.isDark(context);

    return AppBar(
      backgroundColor: background ?? Colours.getScaffoldColor(context),
      title: Text(title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colours.getBlackOrWhite(context))),
      centerTitle: centerTitle,
      leading: !isBack
          ? Gaps.empty
          : IconButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                Navigator.maybePop(context);
              },
              padding: const EdgeInsets.all(12.0),
              icon: LoadAssetSvg(backSvgPath, width: 15, height: 15, color: isDark ? Colors.white : Colors.black)),
      actions: _renderWidgets(),
    );
  }

  _renderWidgets() {
    if (actionName != null) {
      return [
        TextButton(
            child: Text(actionName!,
                key: const Key('actionName'),
                style: TextStyle(
                    fontSize: 14, color: actionOnPressed == null ? Colors.grey : actionColor ?? Colours.mainColor)),
            onPressed: actionOnPressed)
      ];
    } else if (actionWidget != null) {
      return [actionWidget];
    }
    return [];
  }

  @override
  Size get preferredSize => const Size.fromHeight(48.0);
}
