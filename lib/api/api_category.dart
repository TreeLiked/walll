import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:wall/model/response/result.dart';

class Api {
  static const String _tag = "api";

  static const bool devInf = false;
  static const bool devMem = false;

  static const String apiBaseAl = "https://almond-donuts.iutr.tech";
  static const String apiBaseTr = "https://member.iutr.tech";
  static const String apiBaseWs = "wss://almond-donuts.iutr.tech/wallServer";

  static const String apiBaseAlDev = "http://192.168.31.235:8088";
  static const String apiBaseTrDev = "http://192.168.31.235:9002";
  static const String apiBaseWsDev = "ws://127.0.0.1:8088/wallServer";

  static const String apiBaseAlUrl = (devInf ? apiBaseAlDev : apiBaseAl) + "/iap/api";
  static const String apiBaseTrUrl = (devMem ? apiBaseTrDev : apiBaseTr) + "/trms/api";

  // 分享页面
  static const String sharePageUrl = "https://almond-donuts.iutr.tech/download.html";
  static const String agreementUrl = "https://almond-donuts.iutr.tech/terms.html";

  // tweet
  static const String tweetCreate = "/tweet/add.do";
  static const String deleteTweet = apiBaseAlUrl + "/tweet/d.do";
  static const String getSingleTweet = "/tweet/listSingle.json";
  static const String API_TWEET_QUERY = "/tweet/list.json";
  static const String apiGetTweet = "/tweet/listUni.json";
  static const String querySelfTweet = "/tweet/account/pushed.json";
  static const String API_TWEET_QUERY_PUBLIC = "/tweet/account/publicPushed.json";
  // static const String API_TWEET_MEDIA_UPLOAD_REQUEST = "/tweet/media/generate.json";

  // tweet operation
  static const String operateTweetInteract = "/tweet/opt/opt.do";
  static const String API_TWEET_OPT_QUERY_SINGLE = "/tweet/opt/querySingle.json";

  // tweet praise query
  static const String getTweetPraise = "/tweet/opt/getPraise.json";
  static const String API_TWEET_HOT_QUERY = "/tweet/listHot.json";

  // tweet reply
  static const String sendTweetReply = "/tweet/reply/add.do";
  static const String queryTweetReply = "/tweet/reply/list.json";
  static const String deleteTweetReply = "/tweet/reply/del.do";

  // circle relative start
  // static const String API_CIRCLE_INDEX_LIST = Api.apiBaseAlUrl + "/circle/list.json";
  // static const String API_CIRCLE_LIST_ME = Api.apiBaseAlUrl + "/circle/listM.json";
  // static const String API_CIRCLE_CREATE = Api.apiBaseAlUrl + "/circle/add.do";
  // static const String API_CIRCLE_QUERY_SINGLE = Api.apiBaseAlUrl + "/circle/listSingle.json";
  // static const String API_CIRCLE_QUERY_SINGLE_DETAIL = Api.apiBaseAlUrl + "/circle/listSingle.json";
  //
  // static const String API_CIRCLE_APPLY_JOIN = Api.apiBaseAlUrl + "/circleacc/applyJoin.do";
  // static const String API_CIRCLE_APPLY_HANDLE = Api.apiBaseAlUrl + "/circleacc/handleApply.do";
  // static const String API_CIRCLE_ACCOUNT_LIST = Api.apiBaseAlUrl + "/circleacc/list.json";
  // static const String API_CIRCLE_ACCOUNT_SINGLE = Api.apiBaseAlUrl + "/circleacc/me.json";
  //
  // static const String API_CIRCLE_UPDATE_ROLE = Api.apiBaseAlUrl + "/circleacc/updateUserRole.do";
  //
  // static const String API_CIRCLE_TWEET_CRATE = Api.apiBaseAlUrl + "/circletweet/add.do";
  // static const String API_CIRCLE_TWEET_LIST = Api.apiBaseAlUrl + "/circletweet/list.json";

  // sms
  static const String apiSendVerificationCode = apiBaseAlUrl + "/sms/send.do";
  static const String apiCheckVerificationCode = apiBaseAlUrl + "/sms/check.do";

  // member start --------
  static const String apiGetAccount = apiBaseTrUrl + "/account/getAccInfo.json";

  static const String apiGetAccountProfile = apiBaseTrUrl + "/account/getProfileInfo.json";
  static const String queryAccountCampusProfile =
      apiBaseTrUrl + "/account/getCampusProfile.json";

  static const String apiQueryFilteredAccountProfile = apiBaseTrUrl + "/account/getShowInfo.json";

  static const String API_QUERY_ACCOUNT_SETTING = apiBaseTrUrl + "/account/getSettings.json";

  static const String API_UPDATE_ACCOUNT_SETTING = apiBaseTrUrl + "/account/edit/setting.do";

  static const String accountModifyBasic = apiBaseTrUrl + "/account/edit/basic.do";

  static const String apiCheckNickRepeat = apiBaseTrUrl + "/account/nickCheck.do";

  static const String registerByPhone = apiBaseTrUrl + "/auth/rbp.do";

  static const String apiLoginByPhone = apiBaseTrUrl + "/auth/lbp.do";

  // 内测邀请相关
  static const String getIsOnInvitation = apiBaseTrUrl + "/auth/i";
  static const String API_CHECK_INVITATION_CODE = apiBaseTrUrl + "/auth/checkICode";
  static const String API_MY_INVITATION = apiBaseTrUrl + "/auth/iCode";

  // university
  static const String API_BLUR_QUERY_UNIVERSITY = apiBaseTrUrl + "/un/blurQuery.json";

  static const String apiGetOrg = apiBaseTrUrl + "/org/getAccUniversity.json";

  // institute
  static const String API_QUERY_INSTITUTE = apiBaseTrUrl + "/un/getInstitutes.json";
  static const String API_BLUR_QUERY_MAJOR = apiBaseTrUrl + "/un/getMajorName.json";

  // device
  static const String updateDeviceInfo = apiBaseAlUrl + "/device/update.do";
  static const String removeDeviceInfo = apiBaseAlUrl + "/device/signOut.do";

  // notification message
  static const String listInteractionMsg = apiBaseAlUrl + "/message/listInteractions.json";
  static const String listSystemMsg = apiBaseAlUrl + "/message/listSystems.json";
  static const String API_MSG_LIST_CIRCLE_SYSTEM = apiBaseAlUrl + "/message/listCircleSystems.json";
  static const String readAllInteractionMsg = apiBaseAlUrl + "/message/interactionsAllRead.do";
  static const String API_MSG_READ_ALL_SYSTEM = apiBaseAlUrl + "/message/systemsAllRead.do";
  static const String readThisMsg = apiBaseAlUrl + "/message/read.do";
  static const String ignoreThisMsg = apiBaseAlUrl + "/message/ignored.do";

  static const String getInteractionMsgCnt = apiBaseAlUrl + "/message/interactionAlertCount.json";
  static const String newTweetCnt = apiBaseAlUrl + "/message/listNewTweetCount.json";
  static const String getSystemMsgCnt = apiBaseAlUrl + "/message/systemAlertCount.json";
  static const String getMsgCnt = apiBaseAlUrl + "/message/alertCnt.json";
  static const String batchGetMsgCnt = apiBaseAlUrl + "/message/batchAlertCnt.json";

  static const String getLatestMsg = apiBaseAlUrl + "/message/latest.json";
  static const String batchGetLatestMsg = apiBaseAlUrl + "/message/batchLatest.json";

  // subscribe
  static const String API_TWEET_TYPE_SUBSCRIBE = apiBaseAlUrl + "/tt/s/s.action";
  static const String API_TWEET_TYPE_UN_SUBSCRIBE = apiBaseAlUrl + "/tt/s/us.action";
  static const String API_TWEET_TYPE_CHECK_SUBSCRIBE = apiBaseAlUrl + "/tt/s/c.action";
  static const String API_TWEET_TYPE_GET_SUBSCRIBE = apiBaseAlUrl + "/tt/s/g.action";

  // version update
  static const String checkAndGetUpdate = apiBaseAlUrl + "/version/checkUpdate";
  static const String checkUpdateAvaliable = apiBaseAlUrl + "/version/available";


  // advertisement
  static const String apiGetSplashAd = apiBaseAlUrl + "/adv/splash/g";

  // dict service
  static const String API_DICT_PREFIX = apiBaseAlUrl + "/dict";

  static Map<String, dynamic> convertResponse(Object responseData) {
    String jsonTemp = json.encode(responseData);
    return json.decode(jsonTemp);
  }

  static String formatError(DioError e, {pop = false}) {
    LogUtil.d(e, tag: _tag);

    if (e.type == DioErrorType.connectTimeout) {
      // It occurs when url is opened timeout.
      LogUtil.e("连接超时", tag: _tag);
      return "连接超时";
    } else if (e.type == DioErrorType.sendTimeout) {
      // It occurs when url is sent timeout.
      LogUtil.e("请求超时", tag: _tag);
      return "请求超时";
    } else if (e.type == DioErrorType.receiveTimeout) {
      //It occurs when receiving timeout
      LogUtil.e("连接超时", tag: _tag);
      return "响应超时";
    } else if (e.type == DioErrorType.response) {
      // When the server response, but with a incorrect status, such as 404, 503...
      LogUtil.e("服务出现异常$e", tag: _tag);
      return "服务出现异常";
    } else if (e.type == DioErrorType.cancel) {
      // When the request is cancelled, dio will throw a error with this type.
      LogUtil.e("请求取消", tag: _tag);
      return "请求取消";
    } else {
      //DEFAULT Default error type, Some other Error. In this case, you can read the DioError.error if it is not null.
      LogUtil.e("未知错误$e", tag: _tag);
      return "未知错误";
    }
  }

  static Result<dynamic> genErrorResult(String errorMsg, {dynamic data}) {
    Result r = Result(false);
    r.message = errorMsg;
    r.data = data;
    return r;
  }
}
