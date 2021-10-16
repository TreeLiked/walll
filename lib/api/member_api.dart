import 'dart:core';

import 'package:common_utils/common_utils.dart';
import 'package:wall/api/api_category.dart';
import 'package:wall/constant/app_constant.dart';
import 'package:wall/model/biz/account/account.dart';
import 'package:wall/model/biz/account/account_campus_profile.dart';
import 'package:wall/model/biz/account/account_display_info.dart';
import 'package:wall/model/biz/account/account_edit_param.dart';
import 'package:wall/model/response/result.dart';
import 'package:wall/util/http_util.dart';

class MemberApi {
  static const String _tag = "MemberApi";

  static Future<Account?> getMyAccount(String token) async {
    Result<Account> res = await httpUtil2.post(Api.apiGetAccount);
    if (!res.isSuccess) {
      return Future.value(null);
    }
    return Future.value(Account.fromJson(res.jsonData!));
  }

  static Future<Account?> getAccountProfile(String accountId) async {
    Result<Account> res = await httpUtil2.post(Api.apiGetAccountProfile);
    if (!res.isSuccess) {
      return Future.value(null);
    }
    return Future.value(Account.fromJson(res.jsonData!));
  }

  static Future<AccountCampusProfile?> getAccountCampusProfile(String accountId) async {
    Result res = await httpUtil2.get(Api.queryAccountCampusProfile);
    if (!res.isSuccess) {
      return Future.value(null);
    }
    return AccountCampusProfile.fromJson(res.oriData);
  }

  static Future<AccountDisplayInfo?> getAccountDisplayProfile(String accountId) async {
    Result res = await httpUtil2
        .get(Api.apiQueryFilteredAccountProfile, data: {AppCst.accountIdIdentifier: accountId});
    if (!res.isSuccess) {
      return Future.value(null);
    }
    return AccountDisplayInfo.fromJson(res.oriData);
  }

  static Future<Result> modAccount(AccountEditParam param) async {
    return await httpUtil2.post(Api.accountModifyBasic, data: param);
  }

  static Future<Result> sendPhoneVerificationCode(String phone) async {
    return httpUtil2.get(Api.apiSendVerificationCode + "?p=$phone");
  }

  static Future<Result> checkVerificationCode(String phone, String vCode) async {
    return httpUtil2.get(Api.apiCheckVerificationCode + "?p=$phone&c=$vCode");
  }

  static Future<Result> checkNickRepeat(String nick) async {
    return httpUtil2.get(Api.apiCheckNickRepeat + "?n=$nick");
  }

  static Future<Result> register(String phone, String nick, String avatarUrl, int orgId, String iCode) async {
    var data = {
      'phone': phone,
      'nick': nick,
      'avatarUrl': avatarUrl,
      'orgId': orgId,
      'iCode': iCode,
    };
    return await httpUtil2.post(Api.registerByPhone, data: data);
  }

  static Future<Result> login(String phone) async {
    Result<String> res = await httpUtil2.post(Api.apiLoginByPhone, data: {'phone': phone});
    if (res.isSuccess) {
      res.data = res.oriData.toString();
    }
    return Future.value(res);
  }
//
// static Future<Map<String, dynamic>> getAccountSetting({String passiveAccountId}) async {
//   String url = Api.API_QUERY_ACCOUNT_SETTING +
//       "?${SharedConstant.ACCOUNT_ID_IDENTIFIER}=" +
//       (passiveAccountId ?? "");
//   Response response;
//   try {
//     response = await httpUtil2.dio.get(url);
//     Map<String, dynamic> json = Api.convertResponse(response.data);
//     dynamic json2 = json["data"];
//     if (json2 == null || json['isSuccess'] == false) {
//       return null;
//     }
//     Map<String, dynamic> settingMap = Api.convertResponse(json2);
//     LogUtil.e(settingMap, tag: _TAG);
//
//     return settingMap;
//   } on DioError catch (e) {
//     Api.formatError(e);
//   }
//   return null;
// }
//
// static Future<Result> updateAccountSetting(String key, String value) async {
//   Response response;
//   try {
//     var data = {"key": key, "value": value};
//     response = await httpUtil2.dio.post(Api.API_UPDATE_ACCOUNT_SETTING, data: data);
//     Map<String, dynamic> json = Api.convertResponse(response.data);
//     LogUtil.e(json, tag: _TAG);
//     return Result.fromJson(json);
//   } on DioError catch (e) {
//     Api.formatError(e);
//   }
//   return null;
// }
}
