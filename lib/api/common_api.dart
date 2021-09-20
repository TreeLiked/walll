import 'dart:core';

import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:wall/util/http_util.dart';

import 'api_category.dart';

class CommonApi {
  static const String _tag = "CommonApi";

  // static Future<Result<List<String>>> blueQueryDataList(String url) async {
  //   Response response;
  //   Result<List<String>> res = Result();
  //   try {
  //     response = await httpUtil2.dio.get(url);
  //     Result<List<dynamic>> r = Result.fromJson(response.data);
  //     res = Result.fromResult(r);
  //     if (r.isSuccess && r.data != null) {
  //       List<dynamic> temp = r.data;
  //       List<String> values = temp.map((f) => f.toString()).toList();
  //       res.data = values;
  //     }
  //   } on DioError catch (e) {
  //     res.isSuccess = false;
  //     res.message = e.message;
  //     Api.formatError(e);
  //   }
  //   return res;
  // }

  static Future<Map<String, dynamic>> getSplashAd() async {
    return Future.value((await httpUtil2.get(Api.apiGetSplashAd)).jsonData);
  }

  // static Future<int> getAlertCount(MessageType msgType) async {
  //   Response response;
  //   try {
  //     String type = msgType.toString().substring(msgType.toString().indexOf('.') + 1);
  //     response = await httpUtil.dio.get(Api.API_MSG_CNT, queryParameters: {"t": type});
  //     Map<String, dynamic> json = Api.convertResponse(response.data);
  //     if (CollectionUtil.isMapEmpty(json)) {
  //       return -1;
  //     }
  //     Result r = Result.fromJson(json);
  //     if (r.isSuccess) {
  //       return r.data;
  //     }
  //     LogUtil.e("getAlertCount error, ${r.toJson()}", tag: _tag);
  //     return -1;
  //   } on DioError catch (e) {
  //     Api.formatError(e, pop: false);
  //     return -1;
  //   }
  // }
}
