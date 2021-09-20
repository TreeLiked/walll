// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:iap_app/global/color_constant.dart';
// import 'package:iap_app/global/path_constant.dart';
// import 'package:iap_app/global/theme_constant.dart';
// import 'package:iap_app/res/colors.dart';
// import 'package:iap_app/res/dimens.dart';
// import 'package:iap_app/res/gaps.dart';
// import 'package:iap_app/style/text_style.dart';
// import 'package:iap_app/util/theme_utils.dart';
//
// /// 自定义AppBar
// class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
//   const MyAppBar(
//       {Key key,
//       this.actionColor,
//       this.background,
//       this.title: "",
//       this.centerTitle: "",
//       this.actionName: "",
//       this.actionWidget,
//       this.backImg: PathConstant.ICON_GO_BACK_ARROW,
//       this.onPressed,
//       this.isBack: true})
//       : super(key: key);
//
//   final Color actionColor;
//   final Color background;
//   final String title;
//   final String centerTitle;
//   final String backImg;
//   final String actionName;
//   final VoidCallback onPressed;
//   final Widget actionWidget;
//   final bool isBack;
//
//   @override
//   Widget build(BuildContext context) {
//     bool isDark = ThemeUtils.isDark(context);
//     Color _backgroundColor;
//     Color _actionBtnColor;
//
//     _backgroundColor = background ?? isDark ? ThemeConstant.darkBG : Colors.white;
//     _actionBtnColor = actionColor ?? Colors.amber[700];
//
//     SystemUiOverlayStyle _overlayStyle =
//         ThemeData.estimateBrightnessForColor(_backgroundColor) == Brightness.dark
//             ? SystemUiOverlayStyle.light
//             : SystemUiOverlayStyle.dark;
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: _overlayStyle,
//       child: Material(
//         color: _backgroundColor,
//         child: SafeArea(
//           child: Stack(
//             alignment: Alignment.centerLeft,
//             children: <Widget>[
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Container(
//                     alignment: centerTitle.isEmpty ? Alignment.centerLeft : Alignment.center,
//                     width: double.infinity,
//                     child: Text(title.isEmpty ? centerTitle : title,
//                         softWrap: true,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 1,
//                         style: pfStyle.copyWith(
//                           fontWeight: FontWeight.w500,
//                           fontSize: Dimens.font_sp16p5,
//                           letterSpacing: 1.1,
//                           color:
//                               _overlayStyle == SystemUiOverlayStyle.light ? Colours.dark_text : Colours.text,
//                         )),
//                     padding: const EdgeInsets.symmetric(horizontal: 48.0),
//                   )
//                 ],
//               ),
//               isBack
//                   ? IconButton(
//                       onPressed: () {
//                         FocusScope.of(context).unfocus();
//                         Navigator.maybePop(context);
//                       },
//                       tooltip: '返回',
//                       padding: const EdgeInsets.all(12.0),
//                       icon: Image.asset(
//                         backImg,
//                         color: _overlayStyle == SystemUiOverlayStyle.light ? Colours.dark_text : Colours.text,
//                       ),
//                     )
//                   : Gaps.empty,
//               Positioned(
//                   right: 8.0,
//                   child: Theme(
//                     data: Theme.of(context).copyWith(
//                         buttonTheme: ButtonThemeData(
//                       padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                       minWidth: 60.0,
//                     )),
//                     child: actionWidget ??
//                         (actionName.isEmpty
//                             ? Gaps.empty
//                             : TextButton(
//                                 child: Text(
//                                   actionName,
//                                   key: const Key('actionName'),
//                                   style: pfStyle.copyWith(
//                                       fontSize: Dimens.font_sp13,
//                                       color: onPressed == null ? Colors.grey : _actionBtnColor),
//                                 ),
//                                 onPressed: onPressed,
//                               ))
//                   )),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Size get preferredSize => Size.fromHeight(48.0);
// }
