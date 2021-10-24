import 'package:flutter/material.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/constant/gap_constant.dart';
import 'package:wall/util/asset_util.dart';

class SettingRowItem extends StatelessWidget {
  const SettingRowItem(
      {Key? key,
      this.onTap,
      required this.title,
      this.content = "",
      this.prefixWidget,
      this.textAlign = TextAlign.start,
      this.onLongPress,
      this.maxLines = 1})
      : super(key: key);

  final GestureTapCallback? onTap;
  final GestureTapCallback? onLongPress;
  final String title;
  final String content;
  final TextAlign textAlign;
  final int maxLines;
  final Widget? prefixWidget;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        // margin: const EdgeInsets.only(left: 15.0),
        padding: const EdgeInsets.fromLTRB(15, 15.0, 15.0, 15.0),
        constraints: const BoxConstraints(maxHeight: double.infinity, minHeight: 50.0),
        width: double.infinity,
        child: Row(
          //为了数字类文字居中
          crossAxisAlignment: CrossAxisAlignment.center,
//          crossAxisAlignment: maxLines == 1 ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: <Widget>[
            prefixWidget ?? Gaps.empty,
            Text(
              title,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.fade,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5),
            ),
            const Spacer(),
            Expanded(
                flex: 4,
                child: Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 16.0),
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Text(content,
                          maxLines: maxLines,
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colours.secondaryFontColor, fontSize: 14.0)),
                    ))),
            Opacity(
              // 无点击事件时，隐藏箭头图标
              opacity: onTap == null ? 0 : 1,
              child: Padding(
                  padding: EdgeInsets.only(top: maxLines == 1 ? 0.0 : 2.0),
                  child: const LoadAssetSvg("common/arrow_next",
                      width: 25, height: 25, color: Colours.secondaryFontColor)),
            )
          ],
        ),
      ),
    );
  }
}
