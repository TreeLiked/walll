import 'dart:ffi';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wall/constant/shared_constant.dart';
import 'package:wall/model/biz/account/account.dart';
import 'package:wall/model/biz/tweet/tweet.dart';
import 'package:wall/model/biz/tweet/tweet_reply.dart';
import 'package:wall/util/toast_util.dart';
import 'package:wall/extension/extend_list.dart';

class TweetProvider extends ChangeNotifier {
  List<BaseTweet>? _displayTweets;

  List<BaseTweet>? get displayTweets => _displayTweets;

  void refresh() {
    notifyListeners();
  }

  void delete(int tweetId) {
    _displayTweets!.removeWhere((t) => t.id == tweetId);
    refresh();
  }

  void deleteReply(int tweetId, int parentId, int replyId, int type) {
    if (displayTweets == null) {
      return;
    }
    BaseTweet? t = _displayTweets!.firstWhereOrNull((t) => t.id == tweetId);
    if (t == null) {
      return;
    }
    List<TweetReply?>? trs = t.dirReplies;
    if (trs != null && trs.isNotEmpty) {
      if (type == 1) {
        // 删除直接回复
        trs.removeWhere((dirReply) => dirReply!.id == replyId);
      } else if (type == 2) {
        TweetReply? parentReply = trs.firstWhere((dirReply) => dirReply!.id == parentId, orElse: () => null);
        if (parentReply != null) {
          List<TweetReply?>? subTrs = parentReply.children;
          if (subTrs != null && subTrs.isNotEmpty) {
            subTrs.removeWhere((subReply) => subReply!.id == replyId);
          }
        }
      }
    }
    refresh();
  }

  void deleteByAccount(String accountId) {
    _displayTweets!.removeWhere((t) => !t.anonymous! && t.account!.id == accountId);
    refresh();
  }

  void updateReply(BuildContext context, TweetReply? tr) {
    if (tr == null) {
      ToastUtil.showToast(context, '回复失败，请稍后重试');
      return;
    }
    print(tr.toJson());
    print("--------------------");

    BaseTweet? targetTweet = displayTweets!.firstWhereOrNull((tweet) => tweet.id == tr.tweetId);
    targetTweet!.replyCount = targetTweet.replyCount! + 1;
    if (tr.type == 1) {
      // 设置到直接回复
      targetTweet.dirReplies ??= [];
      targetTweet.dirReplies!.add(tr);
    } else {
      // 子回复
      int parentId = tr.parentId!;
      targetTweet.dirReplies ??= [];
      TweetReply tr2 = targetTweet.dirReplies!.firstWhere((dirReply) => dirReply.id == parentId);
      tr2.children ??= [];
      tr2.children!.add(tr);
    }
    notifyListeners();
  }

  void updatePraise(BuildContext context, Account account, int tweetId, bool praise) {
    BaseTweet? targetTweet = displayTweets!.firstWhereOrNull((tweet) => tweet.id == tweetId);
    if (targetTweet == null) {
      ToastUtil.showToast(context, '内容不存在，请刷新后重试');
      return;
    }
    targetTweet.loved = praise;
    if (praise) {
      targetTweet.praise = targetTweet.praise! + 1;
      targetTweet.latestPraise ??= [];
      targetTweet.latestPraise!.add(account);
    } else {
      targetTweet.praise = targetTweet.praise! - 1;
      if (targetTweet.latestPraise != null) {
        targetTweet.latestPraise!.removeWhere((acc) => acc.id == account.id);
      }
    }
    notifyListeners();
    print('12321321321-------------------');
  }

  void update(List<BaseTweet> tweets, {bool append = true, bool clear = false}) {
    if (append && clear) {
      throw 'append and clear must have different value';
    }
    if (tweets == null) {
      // _displayTweets = null;
    } else {
      List<String>? unlikes = SpUtil.getStringList(SharedCst.unLikeTweetIds);
      if (unlikes != null && unlikes.isNotEmpty) {
        tweets.removeWhere((tweet) => unlikes.contains(tweet.id.toString()));
      }
      if (clear) {
        _displayTweets = [];
        _displayTweets!.addAll(tweets);
      } else {
        if (append) {
          _displayTweets ??= [];
          _displayTweets!.addAll(tweets);
        }
      }
    }
    refresh();
  }
}
