import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:wall/api/api_category.dart';
import 'package:wall/api/device_api.dart';
import 'package:wall/config/routes/login_router.dart';
import 'package:wall/config/routes/routes.dart';
import 'package:wall/constant/app_constant.dart';
import 'package:wall/constant/result_code.dart';
import 'package:wall/constant/shared_constant.dart';
import 'package:wall/model/response/result.dart';
import 'package:wall/provider/msg_provider.dart';

import '../application.dart';
import 'navigator_util.dart';
import 'toast_util.dart';

var httpUtil = HttpUtil(Api.apiBaseAlUrl, header: headersJson);
var httpUtil2 = HttpUtil(Api.apiBaseTrUrl, header: headersJson);

//普通格式header

Map<String, dynamic> headers = {
  "Accept": "application/json",
  "Content-Type": "application/x-www-form-urlencoded",
};
//json格式
Map<String, dynamic> headersJson = {
  "Accept": "application/json",
  "Content-Type": "application/json; charset=UTF-8",
  "identify-id": Application.getAccountId ?? "",
  "user-agent":
      "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.93 Safari/537.36",
  "versionId": Platform.isAndroid ? AppCst.versionIdAndroid : AppCst.versionIdIos,
  "version": Platform.isAndroid ? AppCst.versionRemarkAndroid : AppCst.versionRemarkIos,
};

class HttpUtil {
  static const String _tag = "HttpUtil";
  static const String authKey = AppCst.authHeaderVal;

  late Dio dio;
  late BaseOptions options;
  Map<String, dynamic>? headers;

//
//  void resetToken(String token) {
//    BaseOptions options = BaseOptions(
//      // 请求基地址，一般为域名，可以包含路径
//      // baseUrl: baseUrl,
//      //连接服务器超时时间，单位是毫秒.
//      connectTimeout: 10000,
//
//      //[如果返回数据是json(content-type)，dio默认会自动将数据转为json，无需再手动转](https://github.com/flutterchina/dio/issues/30)
//      // responseType: ResponseType.plain,
//
//      ///  响应流上前后两次接受到数据的间隔，单位为毫秒。如果两次间隔超过[receiveTimeout]，
//      ///  [Dio] 将会抛出一个[DioErrorType.RECEIVE_TIMEOUT]的异常.
//      ///  注意: 这并不是接收数据的总时限.
//      receiveTimeout: 30000,
//      headers: this.headers,
//    );
//
//    dio = new Dio(options);
//
//    String myToken = Application.getLocalAccountToken;
//    if (myToken == null) {
//      myToken = SpUtil.getString(SharedConstant.LOCAL_ACCOUNT_TOKEN);
//      Application.setLocalAccountToken(myToken);
//    }
//    if (myToken == null) {
//      ToastUtil.showToast(Application.context, '用户身份过期，请重新登录');
//    }
//    header.putIfAbsent("Authorization", () => myToken);
//  }

  HttpUtil(baseUrl, {Map<String, dynamic>? header}) {
    headers = header;
    options = BaseOptions(
        // 请求基地址，一般为域名，可以包含路径
        // baseUrl: baseUrl,
        //连接服务器超时时间，单位是毫秒.
        connectTimeout: 10000,

        //[如果返回数据是json(content-type)，dio默认会自动将数据转为json，无需再手动转](https://github.com/flutterchina/dio/issues/30)
        // responseType: ResponseType.plain,

        ///  响应流上前后两次接受到数据的间隔，单位为毫秒。如果两次间隔超过[receiveTimeout]，
        ///  [Dio] 将会抛出一个[DioErrorType.RECEIVE_TIMEOUT]的异常.
        ///  注意: 这并不是接收数据的总时限.
        receiveTimeout: 30000,
        headers: header,
        followRedirects: true);

    dio = Dio(options)..interceptors.add(getMyInterceptor());
    // dio = new Dio(options)..interceptors.add(getMyInterceptor());

    String? myToken = Application.getLocalAccountToken;
    if (myToken == null) {
      myToken = SpUtil.getString(SharedCst.localAccountToken);
      Application.setLocalAccountToken(myToken);
    }
    if (myToken == null) {
      ToastUtil.showToastNew('用户身份过期，请重新登录');
    } else {
      header!.putIfAbsent(authKey, () => myToken);
    }

    // dio.interceptors.add(CookieManager(CookieJar()));
  }

  void updateAuthToken(String accountToken) {
    if (headers!.containsKey(authKey)) {
      headers!.update(authKey, (_) => accountToken);
    } else {
      headers!.putIfAbsent(authKey, () => accountToken);
    }
    options =
        BaseOptions(connectTimeout: 10000, receiveTimeout: 30000, followRedirects: true, headers: headers);
    dio = Dio(options)..interceptors.add(getMyInterceptor());
  }

  void clearAuthToken() {
    if (headers!.containsKey(authKey)) {
      headers!.remove(authKey);
    }
    options =
        BaseOptions(connectTimeout: 10000, receiveTimeout: 30000, headers: headers, followRedirects: true);
    dio = Dio(options)..interceptors.add(getMyInterceptor());
  }

  Future<Result<T>> get<T>(url, {data, options, cancelToken}) async {
    Response response;
    Result<T> result = Result(false);
    try {
      response = await dio.get(url, cancelToken: cancelToken, queryParameters: data);
      var responseContent = response.data;
      if(responseContent is Map) {
        LogUtil.d(responseContent);
        Map<String, dynamic> json = response.data;
        return Result.fromJson(json);
      } else {
        // 兼容没有返回result的接口
        result.isSuccess = true;
        result.data = responseContent;
        return result;
      }
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        result.message = e.message;
      }
    }
    return Future.value(result);
  }

  Future<Result<T>> post<T>(url, {data, options, cancelToken}) async {
    Result<T> result = Result(false);
    Response response;
    try {
      response = await dio.post(url, data: data, options: options, cancelToken: cancelToken);
      var responseContent = response.data;
      if(responseContent is Map) {
        Map<String, dynamic> json = response.data;
        return Result.fromJson(json);
      } else {
        // 兼容没有返回result的接口
        result.isSuccess = true;
        result.data = responseContent;
        return result;
      }
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        result.message = e.message;
      }
    }
    return Future.value(result);
  }

  // static Future<WebLinkModel> loadHtml(BuildContext context, String url) async {
  //   if (url.startsWith("www")) {
  //     url = "http://" + url;
  //   }
  //   Response<dynamic> resp = await httpUtil.dio.get(url);
  //   if (resp != null) {
  //     String html = resp.data;
  //     if (!StringUtil.isEmpty(html)) {
  //       Document doc = HtmlUtils.parseDocument(html);
  //       return WebLinkModel(url, HtmlUtils.getDocTitle(doc) ?? url, HtmlUtils.getDocFaviconPath(doc));
  //     }
  //   }
  //   return null;
  // }

  static InterceptorsWrapper getMyInterceptor() {
    return InterceptorsWrapper(
        onRequest: (options, handler) => requestInterceptor(options, handler),
        onResponse: (response, handler) => responseInterceptor(response, handler),
        onError: (dioError, handler) => errorHandler(dioError, handler));
  }

  static dynamic requestInterceptor(RequestOptions options, RequestInterceptorHandler handler) async {
    String requestId = Uuid().v1().substring(0, 8);
    LogUtil.e('--> Request  to [ $requestId ] -->  ${options.uri}', tag: _tag);
    options.extra.addAll({"RequestId": requestId});
    return handler.next(options);
  }

  static dynamic responseInterceptor(Response resp, ResponseInterceptorHandler handler) async {
    String val = resp.data.toString();
    String requestPath = resp.requestOptions.path;
    String requestId = resp.requestOptions.extra['RequestId'];
    LogUtil.e(
        '<-- Response to [ $requestId ] <-- $requestPath: ${val.length > 100 ? val.substring(0, 100) : val}',
        tag: _tag);
    if(resp.data is Map) {
      Map<String, dynamic> resMap = Api.convertResponse(resp.data);
      if (resMap.isNotEmpty && resMap.containsKey("code") && resMap.containsKey("success")) {
        String code = resMap["code"].toString();
        if (code == ResultCode.loginOut) {
          BuildContext context = Application.context!;

          if (Application.getDeviceId != null) {
            DeviceApi.removeDeviceInfo(Application.getAccountId, Application.getDeviceId);
          }
          Application.setLocalAccountToken(null);
          Application.setAccount(null);
          Application.setAccountId(null);
          await SpUtil.clear();

          Provider.of<MsgProvider>(context, listen: false).clear();

          httpUtil.clearAuthToken();
          httpUtil2.clearAuthToken();

          if (resMap["message"] != null) {
            ToastUtil.showToast(context, resMap["message"], gravity: ToastGravity.CENTER);
          }
          NavigatorUtils.push(context, LoginRouter.loginIndex, clearStack: true);
          return handler.next(resp);
        }
      }
    }

    return handler.next(resp);
  }

  static dynamic errorHandler(DioError error, ErrorInterceptorHandler handler) async {
    LogUtil.e(error, tag: _tag);
    return handler.next(error);
  }

  static int get lineNumber {
    final re = RegExp(r'^#1[ \t]+.+:(?<line>[0-9]+):[0-9]+\)$', multiLine: true);
    final match = re.firstMatch(StackTrace.current.toString());
    return (match == null) ? -1 : int.parse(match.namedGroup('line')!);
  }
}
