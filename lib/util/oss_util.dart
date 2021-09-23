/*
* Oss工具类
* PostObject方式上传图片官方文档：https://help.aliyun.com/document_detail/31988.html
*/
import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import 'package:wall/application.dart';
import 'package:wall/constant/app_constant.dart';
import 'package:wall/util/str_util.dart';

class OssUtil {
  static OssUtil? _instance;

  static Dio? uploadDio;

  // 工厂模式
  factory OssUtil() => _getInstance();

  static OssUtil get instance => _getInstance();

  OssUtil._internal();

  static OssUtil _getInstance() {
    _instance ??= OssUtil._internal();
    return _instance!;
  }

  static Dio _getUploadDio() {
    if (uploadDio == null) {
      BaseOptions options = BaseOptions();
      options.responseType = ResponseType.plain;
      options.contentType = "multipart/form-data";
      uploadDio = Dio(options);
    }
    return uploadDio!;
  }

  static const String destTweet = "tweet";
  static const String destCircle = "circle";
  static const String destTopic = "topic";
  static const String destAvatar = "avatar";
  static const String destCircleCover = "circle-cover";

  static Future<String?> uploadImage(String fileName, List<int> fileBytes, String destDir,
      {String? fixName}) async {
    String newFileName;
    if (StrUtil.isEmpty(fixName)) {
      String prefix = StrUtil.isEmpty(Application.getAccountId)
          ? const Uuid().v1().toString()
          : Application.getAccountId!;
      newFileName =
          prefix + "-" + const Uuid().v1().substring(0, 8) + fileName.substring(fileName.lastIndexOf("."));
    } else {
      newFileName = fixName!;
    }

    String nameKey;

    if (destDir == destAvatar) {
      nameKey = "almond-donuts/image/avatar/" + newFileName;
    } else {
      String date = DateUtil.formatDate(DateTime.now(), format: "yyyy-MM-dd");
      if (destDir == destCircleCover) {
        nameKey = "almond-donuts/image/circle-cover/" + newFileName;
      } else {
        nameKey = "almond-donuts/image/$destDir/$date/" + newFileName;
      }
    }
    String policyText =
        '{"expiration": "2050-01-01T12:00:00.000Z","conditions": [["content-length-range", 0, 1048576000]]}';
    List<int> policyTextUtf8 = utf8.encode(policyText);
    String policyBase64 = base64.encode(policyTextUtf8);
    List<int> policy = utf8.encode(policyBase64);

    // 利用OSSAccessKeySecret签名Policy
    List<int> key = utf8.encode(AppCst.accessKeySecret);
    List<int> signaturePre = Hmac(sha1, key).convert(policy).bytes;
    String signature = base64.encode(signaturePre);

    Dio dio = _getUploadDio();

    FormData data = FormData.fromMap({
      'key': nameKey,
      'policy': policyBase64,
      'OSSAccessKeyId': AppCst.accessKeyId,
      'success_action_status': '200',
      'signature': signature,
      'Access-Control-Allow-Origin': '*',
      'file': MultipartFile.fromBytes(fileBytes, filename: fileName)
//      'file': new UploadFileInfo.fromBytes(fileBytes, fileName),
    });
    try {
//      print(object.lengthSync() / 1024 / 1024);
      Response response = await dio.post(AppCst.postUrl, data: data);
      print(response.headers);
      print(response.data);
      return AppCst.postUrl + "/" + nameKey;
    } on DioError catch (e) {
      print(e.message);
    }
    return Future.value(null);
  }
}
