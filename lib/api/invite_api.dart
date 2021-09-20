import 'dart:core';

import 'package:dio/dio.dart';
import 'package:wall/model/response/result.dart';
import 'package:wall/util/http_util.dart';

import 'api_category.dart';

class InviteAPI {
  static Future<Result> checkIsInInvitation() async {
    return Future.value(await httpUtil.get(Api.getIsOnInvitation));
  }

  static Future<Result> checkCodeValid(String code) async {
    String url = Api.API_CHECK_INVITATION_CODE + '?c=$code';
    return Future.value(await httpUtil.get(url));
  }

// static Future<Map<String, dynamic>> checkMyInvitation() async {
//   Response response;
//   try {
//     response = await httpUtil2.dio.get(Api.API_MY_INVITATION);
//     Map<String, dynamic> json = Api.convertResponse(response.data);
//     if (json['data'] != null) {
//       return json['data'];
//     }
//   } on DioError catch (e) {
//     Api.formatError(e);
//   }
//   return null;
// }
}
