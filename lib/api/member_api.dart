import 'dart:core';

import 'package:common_utils/common_utils.dart';
import 'package:wall/api/api_category.dart';
import 'package:wall/model/biz/account/account.dart';
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

  // static Future<AccountCampusProfile> getAccountCampusProfile(String accountId) async {
  //   Response response;
  //   try {
  //     response = await httpUtil2.dio.get(Api.API_QUERY_ACCOUNT_CAMPUS_PROFILE);
  //     Map<String, dynamic> json = Api.convertResponse(response.data);
  //     LogUtil.e(json, tag: _TAG);
  //
  //     dynamic json2 = json["data"];
  //     if (json2 == null) {
  //       return null;
  //     }
  //     AccountCampusProfile profile = AccountCampusProfile.fromJson(json2);
  //     return profile;
  //   } on DioError catch (e) {
  //     Api.formatError(e);
  //   }
  //   return null;
  // }
  //
  // static Future<AccountDisplayInfo> getAccountDisplayProfile(String accountId) async {
  //   Response response;
  //   try {
  //     response = await httpUtil2.dio.get(
  //         Api.API_QUERY_FILTERED_ACCOUNT_PROFILE + "?${SharedConstant.ACCOUNT_ID_IDENTIFIER}=" + accountId);
  //     Map<String, dynamic> json = Api.convertResponse(response.data);
  //     LogUtil.e(json, tag: _TAG);
  //     dynamic json2 = json["data"];
  //     if (json2 == null) {
  //       return null;
  //     }
  //     AccountDisplayInfo account = AccountDisplayInfo.fromJson(json2);
  //     return account;
  //   } on DioError catch (e) {
  //     Api.formatError(e);
  //   }
  //   return null;
  // }
  //
  // static Future<Result> modAccount(AccountEditParam param) async {
  //   Response response;
  //   try {
  //     response = await httpUtil2.dio.post(Api.API_ACCOUNT_MOD_BASIC, data: param);
  //     Map<String, dynamic> json = Api.convertResponse(response.data);
  //     LogUtil.e(json, tag: _TAG);
  //
  //     return Result.fromJson(json);
  //   } on DioError catch (e) {
  //     Api.formatError(e);
  //   }
  //   return null;
  // }
  //
  static Future<Result> sendPhoneVerificationCode(String phone) async {
    return httpUtil2.get(Api.API_SEND_VERIFICATION_CODE + "?p=$phone");
  }

  static Future<Result> checkVerificationCode(String phone, String vCode) async {
    return httpUtil2.get(Api.apiCheckVerificationCode + "?p=$phone&c=$vCode");
  }

static Future<Result> checkNickRepeat(String nick) async {
  return httpUtil2.get(Api.API_CHECK_NICK_REPEAT + "?n=$nick");
}
//
// static Future<Result> register(String phone, String nick, String avatarUrl, int orgId, String iCode) async {
//   Response response;
//   String url = Api.API_REGISTER_BY_PHONE;
//   var data = {
//     'phone': phone,
//     'nick': nick,
//     'avatarUrl': avatarUrl,
//     'orgId': orgId,
//     'iCode': iCode,
//   };
//   try {
//     response = await httpUtil2.dio.post(url, data: data);
//     Map<String, dynamic> json = Api.convertResponse(response.data);
//     LogUtil.e(json, tag: _TAG);
//     return Result.fromJson(json);
//   } on DioError catch (e) {
//     Api.formatError(e);
//   }
//   return null;
// }

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
