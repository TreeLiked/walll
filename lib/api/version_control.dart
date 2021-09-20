import 'dart:core';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:wall/constant/app_constant.dart';
import 'package:wall/model/biz/version/pub_v.dart';
import 'package:wall/model/response/result.dart';
import 'package:wall/util/http_util.dart';

import 'api_category.dart';

class VersionApi {
  /// 检查当前的版本是否仍然可用
  static Future<Result> checkThisVersionAvailable() async {
    return httpUtil.get(Api.checkUpdateAvaliable,
        data: {"versionId": Platform.isIOS ? AppCst.versionIdIos : AppCst.versionIdAndroid});
  }

  static Future<Result<VersionBO>> fetchLatestVersion() async {
    bool ios = Platform.isIOS;

    Result<VersionBO> res = await httpUtil.get(Api.checkAndGetUpdate, data: {
      "platform": ios ? 'IOS' : 'ANDROID',
      "versionId": ios ? AppCst.versionIdIos : AppCst.versionIdAndroid
    });

    if (res.jsonData != null) {
      res.data = VersionBO.fromJson(res.jsonData!);
    }
    return Future.value(res);
  }
}
