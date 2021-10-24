import 'package:flutter/material.dart';
import 'package:wall/api/tweet_api.dart';
import 'package:wall/application.dart';
import 'package:wall/model/biz/account/account.dart';
import 'package:wall/model/biz/tweet/tweet.dart';
import 'package:wall/model/biz/tweet/tweet_reply.dart';
import 'package:wall/util/common_util.dart';
import 'package:wall/util/navigator_util.dart';

class TRUtil {
  static TweetReply assembleReply(BaseTweet tweet, String body, bool anonymous, bool direct,
      {int? parentId, String? tarAccountId}) {
    TweetReply reply = TweetReply();
    reply.type = direct ? 1 : 2;
    reply.tweetId = tweet.id;
    reply.anonymous = anonymous;
    reply.account = Account.fromId(Application.getAccountId);
    reply.body = body;
    reply.sentTime = DateTime.now();

    if (direct) {
      reply.parentId = tweet.id;
      reply.tarAccount = Account.fromId(tweet.account!.id);
    } else {
      reply.parentId = parentId;
      reply.tarAccount = Account.fromId(tarAccountId);
    }
    return reply;
  }

  static Future<void> publicReply(BuildContext context, TweetReply reply, Function callback) async {
    Util.showDefaultLoadingWithBounds(context, text: '');
    var res = await TweetApi.pushReply(reply, reply.tweetId!);
    NavigatorUtils.goBack(context);
    if (!res.isSuccess) {
      callback(false, res.message);
      return;
    }
    callback(true, TweetReply.fromJson(res.oriData));
  }
}
