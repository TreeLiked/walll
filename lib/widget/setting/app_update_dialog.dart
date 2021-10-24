import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' as f1;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/constant/gap_constant.dart';
import 'package:wall/model/biz/version/pub_v.dart';
import 'package:wall/util/navigator_util.dart';
import 'package:wall/util/str_util.dart';
import 'package:wall/util/version_util.dart';
import 'package:wall/widget/common/button/my_text_btn.dart';

class AppUpdateDialog extends StatefulWidget {
  final VersionBO version;
  final bool forceUpdate;

  AppUpdateDialog(this.version, this.forceUpdate);

  @override
  _AppUpdateDialogState createState() => _AppUpdateDialogState();
}

class _AppUpdateDialogState extends State<AppUpdateDialog> {
  final CancelToken _cancelToken = CancelToken();
  bool _isDownload = false;
  double _value = 0;

  @override
  void dispose() {
    if (!_cancelToken.isCancelled && _value != 1) {
      _cancelToken.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;

    return WillPopScope(
      onWillPop: () async {
        /// 使用false禁止返回键返回，达到强制升级目的
        if (widget.forceUpdate) {
          return false;
        }
        return true;
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: Center(
              child: Container(
                  decoration: BoxDecoration(
                    color: Colours.getTweetScaffoldColor(context),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  width: 280.0,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                            height: 120.0,
                            width: 280.0,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: StrUtil.isEmpty(widget.version.cover)
                                      ? const AssetImage("assets/images/update_head.jpg")
                                      : NetworkImage(widget.version.cover!) as ImageProvider),
                            )),
                        Container(
                            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 16.0, bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                const Text("新版本更新", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                Text(widget.version.mark ?? "",
                                    style: const TextStyle(color: Colors.blue, fontSize: 16))
                              ],
                            )),
                        widget.forceUpdate
                            ? Container(
                                padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0),
                                child: const Text("您必须升级到此版本，否则服务将出现异常",
                                    softWrap: true,
                                    maxLines: 2,
                                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                              )
                            : Gaps.empty,
                        Container(
                            constraints: const BoxConstraints(maxHeight: 300),
//                      alignment: Alignment.centerLeft,
                            width: double.infinity,
                            child: Scrollbar(
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                                  child: Text("${widget.version.updateDesc}"),
                                ),
                              ),
                            )),
                        Padding(
                            padding: const EdgeInsets.only(bottom: 15.0, left: 15.0, right: 15.0, top: 5.0),
                            child: _isDownload
                                ? Column(
                                    children: <Widget>[
                                      LinearProgressIndicator(
                                        backgroundColor: Colors.white,
                                        valueColor: const AlwaysStoppedAnimation<Color>(Colours.mainColor),
                                        value: _value,
                                      ),
                                      Gaps.vGap10,
                                      Padding(
                                          padding: const EdgeInsets.only(top: 10.0),
                                          child: Text('${(_value * 100).toStringAsFixed(2)}%',
                                              style: const TextStyle(color: Colors.lightBlueAccent, fontSize: 14)))
                                    ],
                                  )
                                : Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                                    !widget.forceUpdate
                                        ? Container(
                                            width: 110.0,
                                            height: 36.0,
                                            margin: const EdgeInsets.only(right: 10),
                                            child: MyTextButton(
                                                onPressed: () => NavigatorUtils.goBack(context),
                                                enabled: true,
                                                text: const Text("残忍拒绝", style: TextStyle(fontSize: 15))))
                                        : Gaps.empty,
                                    SizedBox(
                                        width: 110.0,
                                        height: 36.0,
                                        child: MyTextButton(
                                          onPressed: () {
                                            if (defaultTargetPlatform == TargetPlatform.iOS) {
                                              NavigatorUtils.goBack(context);
                                              VersionUtils.jumpAppStore();
                                            } else {
                                              setState(() {
                                                _isDownload = true;
                                              });
                                              _download(widget.version.versionId!);
                                            }
                                          },
                                          enabled: true,
                                          text: const Text("立即更新", style: TextStyle(fontSize: 15)),
                                        ))
                                  ]))
                      ])))),
    );
  }

  ///下载apk
  _download(int versionId) async {
    try {
      await DirectoryUtil.getInstance();
      await DirectoryUtil.initStorageDir();
      DirectoryUtil.createStorageDirSync(category: 'apk');
      String? path = DirectoryUtil.getStoragePath(fileName: 'wall', category: 'apk', format: 'apk');
      LogUtil.d("Apk is installing to $path");

      // Directory storageDir = await getExternalStorageDirectory();
      // String storagePath = storageDir.path;
      // File file = new File('$storagePath/${Config.APP_NAME}v${_version}.apk');

      File file = File(path!);

      /// 链接可能会失效
      await Dio().download(
        widget.version.apkUrl!,
        file.path,
        cancelToken: _cancelToken,
        onReceiveProgress: (int count, int total) {
          if (total != -1) {
            if (count == total) {
              NavigatorUtils.goBack(context);
              VersionUtils.install(path);
            }
            _value = count / total;
            setState(() {});
          }
        },
      );
    } catch (e) {
      Fluttertoast.showToast(msg: "下载失败!");
      LogUtil.d(e);
      setState(() {
        _isDownload = false;
      });
    }
  }
}
