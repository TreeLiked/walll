import 'package:flustars/flustars.dart';
import 'dart:convert' as a;


class Result<T> {
  bool isSuccess = false;
  String? code;
  String? message;
  Map<String, dynamic>? jsonData;
  T? data;

  Result.fromJson(Map<String, dynamic> json)
      : isSuccess = json['isSuccess'] ?? json['success'],
        code = json['code'] is String ? json['code'] : json['code'].toString(),
        message = json['message'],
        jsonData = json['data'] == null ? null : a.jsonDecode(a.jsonEncode(json['data']));

  Result(this.isSuccess);

  Result.fromResult(Result r)
      : isSuccess = r.isSuccess,
        code = r.code,
        message = r.message;

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'isSuccess': isSuccess, 'code': code, 'message': message, 'data': jsonData};

  void print() {
    LogUtil.v("$isSuccess, $message, $code, $data");
  }
}
