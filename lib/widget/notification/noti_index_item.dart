
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/constant/gap_constant.dart';
import 'package:wall/util/asset_util.dart';
import 'package:wall/util/common_util.dart';
import 'package:wall/util/theme_util.dart';
import 'package:wall/util/time_util.dart';
import 'package:wall/widget/common/simgple_tag.dart';

class NotiIndexItem extends StatefulWidget {
  final String iconPath;
  final String title;
  final String? tagName;
  final String? body;
  final Color color;
  final Color? iconColor;
  final Color badgeBgColor;
  final DateTime? time;
  final GestureTapCallback? onTap;
  final bool pointType;
  final bool official;
  final double iconSize;
  final double iconPadding;
  final int msgCnt;

  const NotiIndexItem(
      {Key? key,
      required this.iconPath,
      this.color = Colours.mainColor,
      this.iconColor,
      this.badgeBgColor = Colors.red,
      required this.title,
      this.tagName,
      this.body,
      this.time,
      this.msgCnt = 0,
      this.pointType = false,
      this.official = false,
      this.iconSize = 45,
      this.iconPadding = 7.5,
      this.onTap})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NotiIndexItemState();
  }
}

class _NotiIndexItemState extends State<NotiIndexItem> {
  double lineHeight = 50;

  @override
  Widget build(BuildContext context) {
    bool isDark = ThemeUtil.isDark(context);
    return Material(
      color: Colours.getReversedBlackOrWhite(context),
      child: Ink(
          child: InkWell(
              splashColor: isDark ? Colours.darkTagBgColor : widget.color,
              onTap: widget.onTap,
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 11.0),
                  child: Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                    Stack(children: [
                      Container(
                          height: lineHeight,
                          width: lineHeight,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: isDark ? null : widget.color,
                              border: Border.all(color: Colors.white12, width: isDark ? 1 : 0)),
                          child: Padding(
                            padding: EdgeInsets.all(widget.iconPadding),
                            child: LoadAssetSvg(
                              widget.iconPath,
                              color: widget.iconColor,
                              // color: isDark ? widget.color : Colors.black,
                              height: widget.iconSize,
                              width: widget.iconSize,
                            ),
                          )),
                      widget.official
                          ? Positioned(
                              right: 0,
                              bottom: 0,
                              child: Icon(Icons.double_arrow, size: 15, color: widget.iconColor),
                            )
                          : Gaps.empty
                    ]),
                    Gaps.hGap15,
                    Expanded(
                        child: Row(children: [
                      Expanded(
                          child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                    child: Text(widget.title,
                                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1)),
                                widget.tagName == null
                                    ? Gaps.empty
                                    : SimpleTag(
                                        widget.tagName!,
                                        leftMargin: 5.0,
                                        radius: 5.0,
                                        // bgColor: Colors.black,
                                        // textColor: Colors.amberAccent,
                                        verticalPadding: 2,
                                      ),
                                Expanded(
                                    child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(widget.time == null ? '' : TimeUtil.getShortTime(widget.time!),
                                      style: const TextStyle(color: Colours.secondaryFontColor, fontSize: 13.5)),
                                ))
                              ],
                            ),
                            Gaps.vGap5,
                            Row(
                              children: [
                                Expanded(
                                    child: Text(widget.body ?? "暂无消息",
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1)),
                                Badge(
                                    elevation: 0,
                                    shape: BadgeShape.circle,
                                    showBadge: widget.msgCnt > 0,
                                    badgeColor: widget.badgeBgColor,
                                    animationType: BadgeAnimationType.fade,
                                    badgeContent: widget.pointType
                                        ? const SizedBox(
                                            height: 0.1,
                                            width: 0.1,
                                          )
                                        : Util.getRpWidget(widget.msgCnt))
                              ],
                            )
                          ]))
                    ]))
                  ])))),
    );
  }
}
