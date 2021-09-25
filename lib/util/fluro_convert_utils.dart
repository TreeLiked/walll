import 'dart:convert';

import 'package:wall/util/coll_util.dart';
import 'package:wall/util/str_util.dart';

class FluroConvertUtils {
  static String packConvertArgs(Map<String, Object> args) {
    if (CollUtil.isMapEmpty(args)) {
      return "";
    }
    StringBuffer buffer = StringBuffer("?");
    args.forEach((k, v) => buffer.write(k + "=" + fluroCnParamsEncode(v.toString()) + "&"));
    String str = buffer.toString();
    str = str.substring(0, str.length - 1);
    return str;
  }

  static String assembleArgs(Map<String, dynamic> args) {
    StringBuffer sb = StringBuffer("?");
    args.forEach((key, value) {
      sb.write(key);
      sb.write("=");
      if (value is String) {
        sb.write(fluroCnParamsEncode(value));
      } else {
        sb.write(value);
      }
      sb.write("&");
    });
    String url = sb.toString();
    return url.substring(0, url.length - 1);
  }

  static String fluroCnParamsEncode(String originalCn) {
    if (StrUtil.isEmpty(originalCn)) {
      return "";
    }
    StringBuffer sb = StringBuffer();
    var encoded = Utf8Encoder().convert(originalCn);
    encoded.forEach((val) => sb.write('$val,'));
    return sb.toString().substring(0, sb.length - 1).toString();
  }

  /// fluro 传递后取出参数，解析
  static String fluroCnParamsDecode(String encodedCn) {
    if (StrUtil.isEmpty(encodedCn)) {
      return "";
    }
    var decoded = encodedCn.split('[').last.split(']').first.split(',');
    var list = <int>[];
    decoded.forEach((s) => list.add(int.parse(s.trim())));
    return Utf8Decoder().convert(list);
  }

  /// string 转为 int
  static int string2int(String str) {
    return int.parse(str);
  }

  /// string 转为 double
  static double string2double(String str) {
    return double.parse(str);
  }

  /// string 转为 bool
  static bool string2bool(String str) {
    if (str == 'true') {
      return true;
    } else {
      return false;
    }
  }

  /// object 转为 string json
  static String object2string<T>(T t) {
    return fluroCnParamsEncode(jsonEncode(t));
  }

  /// string json 转为 map
  static Map<String, dynamic> string2map(String str) {
    return json.decode(fluroCnParamsDecode(str));
  }
}
