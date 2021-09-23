import 'package:flutter/material.dart';

class ColorfulBorderWidget extends StatelessWidget {
  // final kGradientBoxDecoration = BoxDecoration(
  //   gradient: LinearGradient(colors: [Colors.yellow.shade600, Colors.orange, Colors.red]),
  //   border: Border.all(
  //     color: Colors.amber, //kHintColor, so this should be changed?
  //   ),
  //   borderRadius: BorderRadius.circular(32),
  // );

  final double width;
  final Widget child;
  final GestureTapCallback? onTap;

  const ColorfulBorderWidget({
    Key? key,
    required this.child,
    this.width = 2.0,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            // gradient: LinearGradient(colors: [Colors.yellow, Colors.redAccent]),
            // border: Border.all(
            //   color: Colors.black,
            // ),
            // border: whitePadding ? Border.all(width: 20,) : null,
            // borderRadius: BorderRadius.all((Radius.circular(50))),
            shape: BoxShape.circle,
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
              Color(0xffEFD55E),
              Color(0xff89D0C2),
              Color.fromRGBO(0, 175, 255, 1),
              Color.fromRGBO(0, 244, 254, 1),
              // Color(0xffF77A82),
              // Color(0xffB7AACB),
              // Color(0xff077ABD),
              // Color(0xffB7E0FF),
              // Color(0xffCFEADC),
              // Color(0xffFBEDCA),
              // Color(0xff768BA0),
              // Color(0xffFEDEE1),
            ]),
            // border: Border.all(color: Colors.amber, width: 20)
        ),
        child: Padding(
          padding: EdgeInsets.all(width),
          child: GestureDetector(onTap: onTap, child: child),
        ));
  }
}
