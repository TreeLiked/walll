/// app constant
class AppCst {
  static const String authHeaderVal = "Authorization";
  static const String accountIdIdentifier = "acId";


  /// 版本信息
  static const int versionIdAndroid = 35;
  static const int versionIdIos = 35;
  static const String versionRemarkAndroid = "3.1.0";
  static const String versionRemarkIos = "3.1.0";

  static const String androidAppId = "com.iutr.wall";


  /// oss相关
  static const String accessKeyId = "LTAI4FukqK1vSNmmDv18VGXw";
  static const String accessKeySecret = "iiUEipG0HKLTDYbdFoRAJPedn4XNu5";
  static const String postUrl = "http://iutr-media.oss-cn-hangzhou.aliyuncs.com";

  static const String thumbnailSuffix = "?x-oss-process=style/image_thumbnail";
  static const String previewSuffix = "?x-oss-process=style/image_preview";


  /// 首页最大展示的点赞数量
  static const int indexMaxDisplayPraiseSize = 10;

  /// 推文创建页面
  static const int tweetCreateMaxStrLen = 512;
  static const double tweetCreateImageMaxSizeTotal = 30;

}
