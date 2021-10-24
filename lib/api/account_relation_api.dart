import 'dart:core' as prefix1;
import 'dart:core';

import 'package:wall/api/api_category.dart';
import 'package:wall/model/response/result.dart';
import 'package:wall/util/http_util.dart';
import 'package:wall/util/str_util.dart';

class AccountRelaApi {
  static const String blockAccountApi = Api.apiBaseAlUrl + "/unlikeAcc/add.do";

  static Future<Result> unlikeAccount(String targetAccountId) async {
    if (StrUtil.isEmpty(targetAccountId)) {
      return Result(false);
    }
    return await httpUtil.post(blockAccountApi, data: targetAccountId);
  }
}
