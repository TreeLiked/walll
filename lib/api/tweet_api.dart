import 'dart:core' as prefix1;
import 'dart:core';

import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:wall/api/api_category.dart';
import 'package:wall/model/biz/common/page_param.dart';
import 'package:wall/model/biz/tweet/tweet.dart';
import 'package:wall/model/response/result.dart';
import 'package:wall/util/coll_util.dart';
import 'package:wall/util/http_util.dart';

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

//   static Future<BaseTweet> queryTweetById(int tweetId, {bool pop = false}) async {
//     String url = Api.API_BASE_INF_URL + Api.API_TWEET_QUERY_SIN + "?id=$tweetId";
//     ;
//     Response response;
//     try {
//       response = await httpUtil.dio.get(url);
//       Map<String, dynamic> json = Api.convertResponse(response.data);
//       if (json['isSuccess'] == true) {
//         dynamic jsonData = json["data"];
//         return BaseTweet.fromJson(jsonData);
//       }
//       return null;
//     } on DioError catch (e) {
//       Api.formatError(e, pop: pop);
//     }
//     return null;
//   }
//
//   static Future<List<BaseTweet>> querySelfTweets(PageParam pageParam, String passiveAccountId,
//       {bool needAnonymous = true}) async {
//     String requestUrl = Api.API_BASE_INF_URL + Api.API_TWEET_QUERY_SELF;
//     Response response;
//     var param = {
//       'currentPage': pageParam.currentPage,
//       'pageSize': pageParam.pageSize,
//     };
//     try {
//       response = await httpUtil.dio.get(requestUrl, queryParameters: param);
//       Map<String, dynamic> json = Api.convertResponse(response.data);
//       dynamic pageData = json["data"];
//       if (pageData == null) {
//         return new List<BaseTweet>();
//       }
//       List<dynamic> tweetData = pageData["data"];
//       if (CollectionUtil.isListEmpty(tweetData)) {
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
//   static Future<List<BaseTweet>> queryOtherTweets(PageParam pageParam, String passiveAccountId) async {
//     String requestUrl = Api.API_BASE_INF_URL + Api.API_TWEET_QUERY_PUBLIC;
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
//   static Future<Result> deleteAccountTweets(String accountId, int tweetId) async {
//     if (StringUtil.isEmpty(accountId)) {
//       return Result(isSuccess: false);
//     }
//     String requestUrl =
//         Api.API_TWEET_DELETE + "?" + SharedConstant.ACCOUNT_ID_IDENTIFIER + "=$accountId&tId=$tweetId";
//     Response response;
//     try {
//       response = await httpUtil.dio.post(requestUrl);
//       Map<String, dynamic> json = Api.convertResponse(response.data);
//       return Result.fromJson(json);
//     } on DioError catch (e) {
//       Api.formatError(e);
//     }
//     return null;
//   }
//
//   static Future<Map<String, dynamic>> pushTweet(BaseTweet tweet) async {
//     Result r;
//     try {
//       Response response =
//           await httpUtil.dio.post(Api.API_BASE_INF_URL + Api.API_TWEET_CREATE, data: tweet.toJson());
//       return Api.convertResponse(response.data);
//     } on DioError catch (e) {
//       String error = Api.formatError(e);
//
//       r = Api.genErrorResult(error);
//     }
//     return r.toJson();
//   }
//
//   static Future<Map<String, dynamic>> requestUploadMediaLink(List<String> fileSuffixes, String type) async {
//     StringBuffer buffer = new StringBuffer();
//     fileSuffixes.forEach((f) => buffer.write("&suffix=$f"));
//     String url = Api.API_BASE_INF_URL +
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
//   static Future<Result> pushReply(TweetReply reply, int tweetId) async {
//     reply.sentTime = DateTime.now();
//     Response response = await httpUtil.dio
//         .post(Api.API_BASE_INF_URL + Api.API_TWEET_REPLY_CREATE + '?tId=$tweetId', data: reply.toJson());
//     Map<String, dynamic> json = Api.convertResponse(response.data);
//     return Result.fromJson(json);
//   }
//
//   static Future<void> operateTweet(int tweetId, String type, bool positive) async {
//     var param = {'tweetId': tweetId, 'accountId': Application.getAccountId, 'type': type, 'valid': positive};
//     String url = Api.API_BASE_INF_URL + Api.API_TWEET_OPERATION + '?acId=' + Application.getAccountId;
//     ;
//     httpUtil.dio.post(url, data: param);
//   }
//
//   static Future<List<TweetReply>> queryTweetReply(int tweetId, bool needSub) async {
//     String url = Api.API_BASE_INF_URL + Api.API_TWEET_REPLY_QUERY + '?id=$tweetId&needSub=$needSub';
//     ;
//     try {
//       Response response = await httpUtil.dio.get(url);
//       Map<String, dynamic> json = Api.convertResponse(response.data);
//       List<dynamic> jsonData = json["data"];
//       if (CollectionUtil.isListEmpty(jsonData)) {
//         return new List<TweetReply>();
//       }
//       List<TweetReply> replies = jsonData.map((m) => TweetReply.fromJson(m)).toList();
//       return replies;
//     } on DioError catch (e) {
//       Api.formatError(e);
//     }
//     return null;
//   }
//
//   static Future<Result> delTweetReply(int replyId) async {
//     String url = Api.API_BASE_INF_URL + Api.API_TWEET_REPLY_DELETE + "?id=$replyId";
//     ;
//     Result r = Result(isSuccess: false);
//     try {
//       Response response = await httpUtil.dio.get(url);
//       Map<String, dynamic> json = Api.convertResponse(response.data);
//       return Result.fromJson(json);
//     } on DioError catch (e) {
//       Api.formatError(e);
//       r.message = e.message;
//     }
//     return r;
//   }
//
//   static Future<List<Account>> queryTweetPraise(int tweetId) async {
//     var param = {
//       'tweetIds': [tweetId],
//       'type': 'PRAISE'
//     };
//     String url = Api.API_BASE_INF_URL + Api.API_TWEET_OPT_QUERY_SINGLE + '?acId=' + Application.getAccountId;
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
//           Api.API_BASE_INF_URL + Api.API_TWEET_HOT_QUERY + '?orgId=$orgId&acId=' + Application.getAccountId;
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
//         await httpUtil.dio.get(Api.API_BASE_INF_URL + Api.API_TWEET_HOT_QUERY + '?tId=$tweetId');
//     Map<String, dynamic> json = Api.convertResponse(response.data);
//     return UniHotTweet.fromJson(json);
//   }
}
