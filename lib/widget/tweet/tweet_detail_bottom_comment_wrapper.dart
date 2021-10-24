import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/constant/gap_constant.dart';
import 'package:wall/provider/account_local_provider.dart';
import 'package:wall/util/theme_util.dart';
import 'package:wall/widget/common/account_avatar.dart';

import '../../application.dart';

class TweetDetailBottomCommentWrapper extends StatelessWidget {
  final String? hintText;
  final FocusNode focusNode;

  TweetDetailBottomCommentWrapper(
      {Key? key, this.hintText = "", required this.valueCallback, required this.focusNode})
      : super(key: key);

  bool isDark = false;

  final TextEditingController _controller = TextEditingController();

  final Function valueCallback;

  @override
  Widget build(BuildContext context) {
    isDark = ThemeUtil.isDark(context);

    // 针对刘海屏的底部的距离
    var bottom = MediaQuery.of(context).padding.bottom;
    return Container(
        height: 60 + bottom,
        width: Application.screenWidth,
        // margin: EdgeInsets.only(bottom: bottom),
        alignment: Alignment.center,
        color: Colours.getScaffoldColor(context),
        padding: EdgeInsets.fromLTRB(5.0, 0, 5.0, bottom),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: <Widget>[
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Consumer<AccountLocalProvider>(builder: (_, provider, __) {
                  return AccountAvatar(
                    cache: true,
                    whitePadding: false,
                    avatarUrl: provider.account!.avatarUrl!,
                    size: 40,
                  );
                }),
              ),
              Expanded(
                child: TextField(
                  autofocus: false,
                  controller: _controller,
                  focusNode: focusNode,
                  maxLength: 512,
                  maxLines: 2,
                  minLines: 1,
                  keyboardAppearance: Theme.of(context).brightness,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      fillColor: isDark ? const Color(0xFF000000) : const Color(0xFFF3F7FA),
                      filled: true,
                      alignLabelWithHint: true,
                      counterText: '',
                      hintText: hintText,
                      border: InputBorder.none,
                      disabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)), borderSide: BorderSide.none),
                      enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)), borderSide: BorderSide.none),
                      focusedBorder:
                          OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(6)),
                      hintStyle: const TextStyle(color: Colours.secondaryFontColor, fontSize: 15)),
                  textInputAction: TextInputAction.send,
                  cursorColor: Colors.amber,
                  autocorrect: false,
                  style: const TextStyle(fontSize: 15, letterSpacing: 1.0),
                  onSubmitted: (value) => valueCallback(value),
                ),
              ),
            ],
          ),
          // Gaps.vGap10,
          // Container(
          //   margin: EdgeInsets.only(left: 10),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //
          //       OptionItem(
          //         '\“${_displayChangeTalk ? '换一个' : '说个梗'}\” ',
          //         Icon(Icons.auto_awesome, size: 15.0, color: isDark ? Colors.grey : Colors.amber[400]),
          //             () {
          //           if (speaks.isNotEmpty) {
          //             int i = getUnrepeatIndex();
          //             setState(() {
          //               speakLastIndex = i;
          //               _controller.text = speaks[i];
          //             });
          //           } else {
          //             ToastUtil.showToast(context, '╮(╯▽╰)╭ ');
          //           }
          //         },
          //         radius: 5.0,
          //         rightMargin: 0,
          //       ),
          //     ],
          //   ),
          // ),
        ]));
  }
}
