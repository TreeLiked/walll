import 'dart:core';

import 'package:dio/dio.dart';
import 'package:wall/model/biz/org/university.dart';
import 'package:wall/model/response/result.dart';
import 'package:wall/util/http_util.dart';

import 'api_category.dart';

class UniversityApi {
  // static Future<Result<List<Institute>>> queryUniInstitutes() async {
  //   Response response;
  //   String url = Api.API_QUERY_INSTITUTE;
  //   ;
  //   Result<List<Institute>> res = Result();
  //   try {
  //     response = await httpUtil2.dio.get(url);
  //     Result<List<dynamic>> r = Result.fromJson(response.data);
  //     res = Result.fromResult(r);
  //     if (r.isSuccess && r.data != null) {
  //       List<dynamic> temp = r.data;
  //       List<Institute> ins = temp.map((f) => Institute.fromJson(f)).toList();
  //       res.data = ins;
  //     }
  //   } on DioError catch (e) {
  //     res.isSuccess = false;
  //     res.message = e.message;
  //     Api.formatError(e);
  //   }
  //   return res;
  // }
  //
  // static Future<List<University>> blurQueryUnis(String blurStr) async {
  //   Response response;
  //   String url = Api.API_BLUR_QUERY_UNIVERSITY + "?n=$blurStr";
  //   ;
  //   try {
  //     response = await httpUtil2.dio.get(url);
  //     List<dynamic> temp = response.data;
  //     if (CollectionUtil.isListEmpty(temp)) {
  //       return [];
  //     }
  //     return temp.map((f) => University.fromJson(f)).toList();
  //   } on DioError catch (e) {
  //     Api.formatError(e);
  //   }
  //   return null;
  // }

  static Future<University?> queryUnis(String accountToken) async {
    Result<University> res = await httpUtil2.post(Api.apiGetOrg);
    if (!res.isSuccess) {
      return Future.value(null);
    }
    return Future.value(University.fromJson(res.jsonData!));
  }
}
