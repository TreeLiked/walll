import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WidgetNotFound extends StatelessWidget {
  const WidgetNotFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("页面不存在"),
        ),
        body: SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(200)), child: const Text('页面走丢了')),
        ));
  }
}
