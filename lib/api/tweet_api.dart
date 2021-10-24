import 'dart:core' as prefix1;
import 'dart:core';

import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:wall/api/api_category.dart';
import 'package:wall/application.dart';
import 'package:wall/constant/app_constant.dart';
import 'package:wall/model/biz/account/account.dart';
import 'package:wall/model/biz/common/page_param.dart';
import 'package:wall/model/biz/tweet/tweet.dart';
import 'package:wall/model/biz/tweet/tweet_account.dart';
import 'package:wall/model/biz/tweet/tweet_reply.dart';
import 'package:wall/model/response/result.dart';
import 'package:wall/util/coll_util.dart';
import 'package:wall/util/http_util.dart';
import 'package:wall/util/str_util.dart';

class TweetApi {
  static Future<List<BaseTweet>> queryTweets(PageParam param) async {
    // {currentPage: 1, pageSize: 10, totalItems: 10, totalPages: -1, data: [{id: 489, orgId: 1, body: 刚刚拉开

    Result res = await httpUtil.post(Api.apiBaseAlUrl + Api.apiGetTweet, data: param.toJson());
    List<dynamic> list;
    if ((list = res.oriData) != null) {
      return list.map((m) => BaseTweet.fromJson(m)).toList();
    }
    return [];
  }

  static Future<BaseTweet?> queryTweetById(int tweetId, {bool pop = false}) async {
    Result res = await httpUtil.get(Api.apiBaseAlUrl + Api.getSingleTweet + "?id=$tweetId");

    if (res.isSuccess) {
      return BaseTweet.fromJson(res.oriData);
    }
    return Future.value(null);
  }

  static Future<List<BaseTweet>> querySelfTweets(PageParam pageParam, String passiveAccountId,
      {bool needAnonymous = true}) async {
    Result res = await httpUtil.get(Api.apiBaseAlUrl + Api.querySelfTweet, data: pageParam.toJson());
    List<dynamic> list;
    if (res.isSuccess && (list = res.oriData['data']) != null) {
      // 这边是分页结果
      return list.map((m) => BaseTweet.fromJson(m)).toList();
    }
    return [];
  }

//
//   static Future<List<BaseTweet>> queryOtherTweets(PageParam pageParam, String passiveAccountId) async {
//     String requestUrl = Api.apiBaseAlUrl + Api.API_TWEET_QUERY_PUBLIC;
//     Response response;
//     var param = {
//       'currentPage': pageParam.currentPage,
//       'pageSize': pageParam.pageSize,
//       'accId': passiveAccountId,
//     };
//     try {
//       response = await httpUtil.dio.get(requestUrl, queryParameters: param);
//       Map<String, dynamic> json = Api.convertResponse(response.data);
//       dynamic pageData = json["data"];
//       if (pageData == null) {
//         return new List<BaseTweet>();
//       }
//       List<dynamic> tweetData = pageData["data"];
//       if (tweetData == null || tweetData.length == 0) {
//         return new List<BaseTweet>();
//       }
//       List<BaseTweet> tweetList = tweetData.map((m) => BaseTweet.fromJson(m)).toList();
//       return tweetList;
//     } on DioError catch (e) {
//       Api.formatError(e);
//     }
//     return null;
//   }
//
  static Future<Result> deleteAccountTweets(String? accountId, int tweetId) async {
    if (StrUtil.isEmpty(accountId)) {
      return Result(false);
    }
    String requestUrl = Api.deleteTweet + "?" + AppCst.accountIdIdentifier + "=$accountId&tId=$tweetId";
    return await httpUtil.post(requestUrl);
  }

  static Future<Result> pushTweet(BaseTweet tweet) async {
    return await httpUtil.post(Api.apiBaseAlUrl + Api.tweetCreate, data: tweet.toJson());
  }

//
//   static Future<Map<String, dynamic>> requestUploadMediaLink(List<String> fileSuffixes, String type) async {
//     StringBuffer buffer = new StringBuffer();
//     fileSuffixes.forEach((f) => buffer.write("&suffix=$f"));
//     String url = Api.apiBaseAlUrl +
//         Api.API_TWEET_MEDIA_UPLOAD_REQUEST +
//         "?type=$type&${SharedConstant.ACCOUNT_ID_IDENTIFIER}=" +
//         Application.getAccountId +
//         buffer.toString();
//
//     ;
//     Response response = await httpUtil.dio.get(url);
//     Map<String, dynamic> json = Api.convertResponse(response.data);
//     return json;
//   }
//
  static Future<Result> pushReply(TweetReply reply, int tweetId) async {
    reply.sentTime = DateTime.now();
    return await httpUtil.post(Api.apiBaseAlUrl + Api.sendTweetReply + '?tId=$tweetId', data: reply.toJson());
  }

  static Future<Result> operateTweet(int tweetId, String type, bool positive) async {
    String accId = Application.getAccountId!;

    return httpUtil.post(Api.apiBaseAlUrl + Api.operateTweetInteract + '?acId=' + accId,
        data: {'tweetId': tweetId, 'accountId': accId, 'type': type, 'valid': positive});
  }

  static Future<List<TweetReply>> queryTweetReply(int tweetId, bool needSub) async {
    String url = Api.apiBaseAlUrl + Api.queryTweetReply + '?id=$tweetId&needSub=$needSub';
    Result res = await httpUtil.get(url);
    if (!res.isSuccess || CollUtil.isListEmpty(res.oriData)) {
      return [];
    }
    List<dynamic> data = res.oriData;
    return data.map((m) => TweetReply.fromJson(m)).toList();
  }

  static Future<Result> delTweetReply(int replyId) async {
    return await httpUtil.get(Api.apiBaseAlUrl + Api.deleteTweetReply + "?id=$replyId");
  }

  static Future<List<TweetAccount>> queryTweetPraise(int page, int size, int tweetId) async {
    String url = Api.apiBaseAlUrl + Api.getTweetPraise;
    Result res = await httpUtil.get(url, data: {"currentPage": page, "pageSize": size, "tweetId": tweetId});
    List<dynamic> list;
    if (res.isSuccess && (list = res.oriData) != null) {
      // 这边是分页结果
      return list.map((m) => TweetAccount.fromJson(m)).toList();
    }
    return [];
  }

//
//   static Future<List<Account>> queryTweetPraise(int tweetId) async {
//     var param = {
//       'tweetIds': [tweetId],
//       'type': 'PRAISE'
//     };
//     String url = Api.apiBaseAlUrl + Api.API_TWEET_OPT_QUERY_SINGLE + '?acId=' + Application.getAccountId;
//     ;
//     try {
//       Response response = await httpUtil.dio.post(url, data: param);
//       Map<String, dynamic> json = Api.convertResponse(response.data);
//       List<dynamic> jsonData = json["data"];
//       if (CollectionUtil.isListEmpty(jsonData)) {
//         return new List<Account>();
//       }
//       List<Account> accounts = jsonData.map((m) => Account.fromJson(m)).toList();
//       return accounts;
//     } on DioError catch (e) {
//       Api.formatError(e);
//     }
//     return null;
//   }
//
//   //   static Future<Result> modPraise() async {
//
//   //   Response response = await httpUtil.dio.post(
//   //       Api.API_BASE_URL + Api.API_TWEET_REPLY_CREATE,
//   //       data: reply.toJson());
//   //   String jsonTemp = prefix0.json.encode(response.data);
//   //   Map<String, dynamic> json = prefix0.json.decode(jsonTemp);
//   //   return Result.fromJson(json);
//   // }
//
//   static Future<UniHotTweet> queryOrgHotTweets(int orgId) async {
//     try {
//       String url =
//           Api.apiBaseAlUrl + Api.API_TWEET_HOT_QUERY + '?orgId=$orgId&acId=' + Application.getAccountId;
//       ;
//       Response response = await httpUtil.dio.get(url);
//       Map<String, dynamic> json = Api.convertResponse(response.data);
// //      String json = response.data;
//       if (json != null) {
//         return UniHotTweet.fromJson(json);
//       }
//     } on DioError catch (e) {
//       Api.formatError(e, pop: false);
//     }
//     return null;
//   }
//
//   static Future<UniHotTweet> queryPraise(int tweetId) async {
//     Response response =
//         await httpUtil.dio.get(Api.apiBaseAlUrl + Api.API_TWEET_HOT_QUERY + '?tId=$tweetId');
//     Map<String, dynamic> json = Api.convertResponse(response.data);
//     return UniHotTweet.fromJson(json);
//   }
}
