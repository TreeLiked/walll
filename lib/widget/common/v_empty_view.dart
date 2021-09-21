import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VEmptyView extends StatelessWidget {
  final double height;

  const VEmptyView(this.height, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScreenUtil().setWidth(height),
    );
  }
}

class VEmptyViewWithBg extends StatelessWidget {
  final double height;

  const VEmptyViewWithBg(this.height, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(height: height, color: Colors.transparent);
  }
}
