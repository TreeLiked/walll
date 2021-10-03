import 'package:flutter/material.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/constant/gap_constant.dart';
import 'package:wall/util/asset_util.dart';
import 'package:wall/util/str_util.dart';
import 'package:wall/util/theme_util.dart';

class EmptyView extends StatelessWidget {
  final String? tip;

  final String lightSvgPath;
  final String darkSvgPath;

  final Color lightColor;
  final Color darkColor;

  final double width;
  final double height;

  const EmptyView({
    Key? key,
    this.tip,
    this.lightSvgPath = "common/no_data",
    this.darkSvgPath = "common/no_data_dark",
    this.width = 90,
    this.height = 90,
    this.lightColor = Colours.lightScaffoldColor,
    this.darkColor = Colours.darkScaffoldColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Gaps.vGap30,
        SizedBox(
            height: height,
            width: width,
            child: LoadAssetSvg(ThemeUtil.isDark(context) ? darkSvgPath : lightSvgPath, fit: BoxFit.cover)),
        StrUtil.isEmpty(tip)
            ? Gaps.empty
            : Container(
                margin: const EdgeInsets.only(top: 16.0),
                child: Text(tip!, style: const TextStyle(color: Colors.grey, fontSize: 13)))
      ],
    );
  }
}
