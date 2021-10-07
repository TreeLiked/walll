import 'package:flutter/cupertino.dart';

class CenterRowWidget extends StatelessWidget {
  final Widget child;
  final EdgeInsets? margin;

  const CenterRowWidget({Key? key, required this.child, this.margin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(margin: margin, alignment: Alignment.topCenter, child: child);
  }
}
