import 'package:flutter/material.dart';

class AverageRow extends StatelessWidget {
  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;

  /// 子项widget对齐
  final AlignmentGeometry innerAlignment;

  const AverageRow(
      {Key? key,
      required this.children,
      this.crossAxisAlignment = CrossAxisAlignment.center,
      this.innerAlignment = Alignment.centerLeft})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: crossAxisAlignment, children: children.map((e) => _wrapSingleWidget(e)).toList());
  }

  Widget _wrapSingleWidget(Widget c) => Expanded(child: Container(alignment: innerAlignment, child: c), flex: 1);
}
