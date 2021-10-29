import 'dart:core' as prefix1;
import 'dart:core';

import 'package:dio/dio.dart';
import 'package:wall/api/api_category.dart';
import 'package:wall/model/biz/message/asbtract_message.dart';
import 'package:wall/model/response/result.dart';
import 'package:wall/util/coll_util.dart';
import 'package:wall/util/common_util.dart';
import 'package:wall/util/http_util.dart';
import 'package:wall/util/str_util.dart';

enum MessageCategory { interaction, tweetNew, system, circleSys, circleInteraction, circle, all }

final msgCategoryCodeMap = {
  MessageCategory.interaction: "21",
  MessageCategory.tweetNew: "22",
  MessageCategory.system: "11",
  MessageCategory.circleInteraction: "31",
  MessageCategory.circleSys: "32",
  MessageCategory.circle: "30",
  MessageCategory.all: "0",
};

final codeMsgCategoryMap = {
  "21": MessageCategory.interaction,
  "22": MessageCategory.tweetNew,
  "11": MessageCategory.system,
  "31": MessageCategory.circleInteraction,
  "32": MessageCategory.circleSys,
  "30": MessageCategory.circle,
  "0": MessageCategory.all
};

class MessageApi {
  static Future<List<AbstractMessage>> queryInteractionMsg(int currentPage, int pageSize) async {
    Result res = await httpUtil.get(Api.listInteractionMsg, data: {"currentPage": currentPage, "pageSize": pageSize});
    if (!res.isSuccess) {
      return [];
    }
    Map<String, dynamic> pageData = res.oriData;
    List<dynamic> jsonData;

    if (CollUtil.isListEmpty(jsonData = pageData["data"])) {
      return [];
    }
    return jsonData.map((m) => AbstractMessage.fromJson(m)).toList();
  }

  static Future<List<AbstractMessage>> querySystemMsg(int currentPage, int pageSize) async {
    Result res = await httpUtil.get(Api.listSystemMsg + "?currentPage=$currentPage");
    if (!res.isSuccess) {
      return [];
    }
    Map<String, dynamic> pageData = res.oriData;
    List<dynamic> jsonData = pageData["data"];
    if (jsonData.isEmpty) {
      return [];
    }
    return jsonData.map((m) {
      return AbstractMessage.fromJson(m);
    }).toList();
  }

  static Future<Result> readAllInteractionMessage({bool pop = false}) async {
    return await httpUtil.get(Api.readAllInteractionMsg);
  }

  static Future<Result> readThisMessage(int messageId) async {
    return await httpUtil.get(Api.readThisMsg, data: {"mId": messageId});
  }

  static Future<Result> ignoreThisMessage(int messageId) async {
    return await httpUtil.get(Api.ignoreThisMsg, data: {"mId": messageId});
  }

  // 0 系统消息，1互动消息
  static Future<dynamic> fetchLatestMessage(MessageCategory type) async {
    Result res = await httpUtil.get(Api.getLatestMsg, data: {"c": Util.getEnumValue(type)});
    if (!res.isSuccess || res.oriData == null) {
      return null;
    }
    return AbstractMessage.fromJson(res.oriData);
  }

  static Future<int> queryInteractionMessageCount() async {
    Result res = await httpUtil.get(Api.getInteractionMsgCnt);
    if (!res.isSuccess) {
      return -1;
    }
    return res.oriData as int;
  }

  static Future<int> queryNewTweetCount(int orgId, int tweetId, String type) async {
    String url;
    if (StrUtil.isEmpty(type)) {
      url = "${Api.newTweetCnt}?oId=$orgId&tId=$tweetId";
    } else {
      url = "${Api.newTweetCnt}?oId=$orgId&tId=$tweetId&tType=$type";
    }
    Result res = await httpUtil.get(url);
    if (!res.isSuccess) {
      return -1;
    }
    return res.oriData as int;
  }

  static Future<int> querySystemMessageCount() async {
    Result res = await httpUtil.get(Api.getSystemMsgCnt);
    if (!res.isSuccess) {
      return -1;
    }
    return res.oriData as int;
  }

  static Future<int> queryMsgCount(MessageCategory category) async {
    Result res = await httpUtil.get(Api.getMsgCnt, data: {"t": Util.getEnumValue(category)});
    if (!res.isSuccess) {
      return -1;
    }
    return (res.oriData ?? 0) as int;
  }

  static Future<Map<String, int>> batchQueryMsgCount(List<String> categoryCodes) async {
    Result res = await httpUtil.get(Api.batchGetMsgCnt, data: {"t": categoryCodes});
    Map<String, dynamic> msgCntMap;
    if (!res.isSuccess || CollUtil.isMapEmpty(msgCntMap = res.oriData)) {
      return {};
    }
    return msgCntMap.map((key, value) => prefix1.MapEntry(key, value as int));
  }

  static Future<Map<String, AbstractMessage>> batchFetchLatestMessage(List<String> categoryCodes) async {
    Result res = await httpUtil.get(Api.batchGetLatestMsg, data: {"t": categoryCodes});
    Map<String, dynamic> msgCntMap;
    if (!res.isSuccess || CollUtil.isMapEmpty(msgCntMap = res.oriData)) {
      return {};
    }
    return msgCntMap.map((key, value) => prefix1.MapEntry(key, AbstractMessage.fromJson(value)));
  }
}
