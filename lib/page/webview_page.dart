import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/util/bottom_sheet_util.dart';
import 'package:wall/util/common_util.dart';
import 'package:wall/util/navigator_util.dart';
import 'package:wall/util/str_util.dart';
import 'package:wall/util/theme_util.dart';
import 'package:wall/util/toast_util.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({
    Key? key,
    required this.title,
    required this.url,
    this.source,
  }) : super(key: key);

  final String title;
  final String url;
  final String? source;

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  late WebView wv;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return Gaps.empty;
    wv = WebView(
      initialUrl: widget.url,
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) async {
        _controller.complete(webViewController);
      },
    );

    return FutureBuilder<WebViewController>(
        future: _controller.future,
        builder: (context, snapshot) {
          return WillPopScope(
              onWillPop: () async {
                if (snapshot.hasData) {
                  bool canGoBack = await snapshot.data!.canGoBack();
                  if (canGoBack) {
                    // 网页可以返回时，优先返回上一页
                    snapshot.data!.goBack();
                    return Future.value(false);
                  }
                  return Future.value(true);
                }
                return Future.value(true);
              },
              child: Scaffold(
                  appBar: AppBar(
                      backgroundColor: Colours.getReversedBlackOrWhite(context),
                      centerTitle: true,
                      title: Text(widget.title,
                          style: TextStyle(
                              color: Colours.getEmphasizedTextColor(context),
                              fontSize: 16,
                              fontWeight: FontWeight.w500)),
                      leading: IconButton(
                          onPressed: () {
                            if (StrUtil.notEmpty(widget.source) && widget.source == "1") {
                              // 从splash页面进来的广告页面
                              NavigatorUtils.goIndex(context);
                              return;
                            }
                            NavigatorUtils.goBack(context);
                          },
                          padding: const EdgeInsets.all(12.0),
                          icon: Icon(Icons.arrow_back_ios, color: Colours.getEmphasizedTextColor(context), size: 20)),
                      actions: <Widget>[
                        IconButton(
                            icon: Icon(Icons.more_horiz_rounded, color: Colours.getEmphasizedTextColor(context), size: 20),
                            onPressed: () => {
                                  BottomSheetUtil.showBottomSheetView(context, [
                                    BottomSheetItem(const Icon(Icons.content_copy, color: Colors.lightBlue), "复制链接",
                                        () {
                                      Util.copyTextToClipBoard(widget.url);
                                      ToastUtil.showToast(context, '已复制');
                                      NavigatorUtils.goBack(context);
                                    }),
                                    BottomSheetItem(const Icon(Icons.refresh, color: Colors.green), "刷新", () async {
                                      NavigatorUtils.goBack(context);
                                      await (await (_controller.future)).clearCache();
                                    })
                                  ])
                                })
                      ]),
                  body: wv));
        });
  }
}
