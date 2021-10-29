import 'dart:async';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/constant/gap_constant.dart';
import 'package:wall/util/bottom_sheet_util.dart';
import 'package:wall/util/common_util.dart';
import 'package:wall/util/navigator_util.dart';
import 'package:wall/util/str_util.dart';
import 'package:wall/util/theme_util.dart';
import 'package:wall/util/toast_util.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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
  // late WebView wv;
  InAppWebViewController? webViewController;
  double progress = 0;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LogUtil.d("web page : ${widget.url}");
    // return InAppWebView(initialUrlRequest: URLRequest(url: Uri.tryParse(widget.url)));
    // // return Gaps.empty;
    // wv = WebView(
    //   initialUrl: widget.url,
    //   javascriptMode: JavascriptMode.unrestricted,
    //   onWebViewCreated: (WebViewController webViewController) async {
    //     _controller.complete(webViewController);
    //   },
    // );
    //
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(55),
            child: AppBar(
                elevation: 0.3,
                backgroundColor: Colours.getReversedBlackOrWhite(context),
                centerTitle: true,
                title: Text(widget.title,
                    style: TextStyle(
                        color: Colours.getEmphasizedTextColor(context), fontSize: 16, fontWeight: FontWeight.w500)),
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
                    icon: Icon(Icons.arrow_back_ios, color: Colours.getEmphasizedTextColor(context), size: 17)),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.more_horiz_rounded, color: Colours.getEmphasizedTextColor(context), size: 20),
                      onPressed: () => {
                            BottomSheetUtil.showBottomSheetView(context, [
                              BottomSheetItem(const Icon(Icons.content_copy, color: Colors.lightBlue), "复制链接", () {
                                Util.copyTextToClipBoard(widget.url);
                                ToastUtil.showToast(context, '已复制');
                                NavigatorUtils.goBack(context);
                              }),
                              BottomSheetItem(const Icon(Icons.refresh, color: Colors.green), "刷新", () async {
                                NavigatorUtils.goBack(context);
                                await webViewController?.clearCache();
                                await webViewController?.reload();
                              }),
                              BottomSheetItem(const Icon(Icons.near_me_rounded, color: Colors.amber), "在浏览器打开",
                                  () async {
                                NavigatorUtils.goBack(context);
                                await launch(widget.url);
                              }),
                            ])
                          })
                ])),
        body: Column(children: [
          progress < 1.0
              ? LinearProgressIndicator(
                  value: progress,
                  minHeight: 2,
                  backgroundColor: Colours.getTweetScaffoldColor(context),
                  color: Colors.lightBlueAccent
                )
              : Gaps.empty,
          Expanded(
              child: InAppWebView(
                  initialUrlRequest: URLRequest(url: Uri.tryParse(widget.url)),
                  onWebViewCreated: (controller) {
                    webViewController = controller;
                  },
                  onLoadStart: (controller, url) {
                    setState(() {});
                  },
                  onProgressChanged: (controller, progress) {
                    setState(() {
                      this.progress = progress / 100;
                    });
                  },
                  initialOptions: InAppWebViewGroupOptions(
                      crossPlatform: InAppWebViewOptions(
                        useShouldOverrideUrlLoading: true,
                        mediaPlaybackRequiresUserGesture: false,
                      ),
                      android: AndroidInAppWebViewOptions(
                        useHybridComposition: true,
                      ),
                      ios: IOSInAppWebViewOptions(
                        allowsInlineMediaPlayback: true,
                      ))))
        ]));
  }
}
