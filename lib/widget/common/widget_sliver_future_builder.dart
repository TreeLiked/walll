import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef ValueWidgetBuilder<T> = Widget Function(
  BuildContext context,
  T value,
);

/// FutureBuilder 简单封装，除正确返回和错误外，其他返回 小菊花
/// 错误时返回定义好的错误 Widget，例如点击重新请求
class CustomSliverFutureBuilder<T> extends StatefulWidget {
  final ValueWidgetBuilder<T> builder;
  final Function futureFunc;
  final Map<String, dynamic>? params;

  const CustomSliverFutureBuilder({
    Key? key,
    required this.futureFunc,
    required this.builder,
    this.params,
  }) : super(key: key);

  @override
  _CustomFutureBuilderState<T> createState() => _CustomFutureBuilderState<T>();
}

class _CustomFutureBuilderState<T> extends State<CustomSliverFutureBuilder<T>> {
  late Future<T> _future;

  @override
  void initState() {
    // WidgetsBinding.instance!.addPostFrameCallback((call) {
    //   _request();
    // });
    if (widget.params == null) {
      _future = widget.futureFunc(context);
    } else {
      _future = widget.futureFunc(context, params: widget.params);
    }
    super.initState();
  }

  void _request() {
    setState(() {
      if (widget.params == null) {
        _future = widget.futureFunc(context);
      } else {
        _future = widget.futureFunc(context, params: widget.params);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _future == null
        ? Align(
            child: Container(
              alignment: Alignment.center,
              height: 60,
              width: double.infinity,
              child: const CupertinoActivityIndicator(),
            ),
          )
        : FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                case ConnectionState.active:
                  return Container(
                      alignment: Alignment.topCenter,
                      margin: const EdgeInsets.only(top: 50),
                      child: Column(mainAxisSize: MainAxisSize.max, children: const <Widget>[
                        CupertinoActivityIndicator()
                        // Gaps.vGap20,
                        // Text('正在加载', style: MyDefaultTextStyle.getTweetTimeStyle(context))
                      ]));
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    return widget.builder(context, snapshot.data as T);
                  } else if (snapshot.hasError) {
                    LogUtil.d(snapshot.error);
                    return Container(
                        alignment: Alignment.topCenter,
                        margin: const EdgeInsets.only(top: 50),
                        child: const Text("", style: TextStyle(color: Colors.grey, fontSize: 14)));
                  }
              }
              return Container();
            },
          );
  }
}
