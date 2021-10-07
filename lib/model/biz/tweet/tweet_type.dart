import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wall/util/theme_util.dart';

final String fallbackTweetType = "FALLBACK";
final tweetTypeMap = {
  "LOVE_CONFESSION": TweetTypeEntity.loveConfession,
  "ASK_FOR_MARRIAGE": TweetTypeEntity.askForMarriage,
  "SOMEONE_FIND": TweetTypeEntity.findSomeone,
  "QUESTION_CONSULT": TweetTypeEntity.questionConsult,
  "COMPLAINT": TweetTypeEntity.complaint,
  "GOSSIP": TweetTypeEntity.gossip,
  "HAVE_FUN": TweetTypeEntity.haveFun,
  "SHARE": TweetTypeEntity.share,
  "LOST_AND_FOUND": TweetTypeEntity.lostAndFound,
  "HELP_AND_REWARD": TweetTypeEntity.helpAndReward,
  "SECOND_HAND_TRANSACTION": TweetTypeEntity.secondHandTran,
  "OTHER": TweetTypeEntity.other,
  "OFFICIAL": TweetTypeEntity.official,
  "CAMPUS_OFFICIAL": TweetTypeEntity.campusOfficial,
  "FALLBACK": TweetTypeEntity.fallback,
  "AD": TweetTypeEntity.ad,
};

class TweetTypeUtil {
  static TweetTypeEntity parseType(String? type) {
    if (type == null || tweetTypeMap[type] == null) {
      return TweetTypeEntity.fallback;
    }
    return tweetTypeMap[type]!;
  }

  static String getTweetEntityCoverUrl(TweetTypeEntity? entity) {
    if (entity == null) {
      entity == TweetTypeEntity.fallback;
    }
    return "https://iutr-media.oss-cn-hangzhou.aliyuncs.com/almond-donuts/default/tweet-type-covers/${entity!.name.toUpperCase()}.jpg";
  }

  static String getTweetTypeCover(BuildContext context) {
    bool isDark = ThemeUtil.isDark(context);
    return "https://iutr-media.oss-cn-hangzhou.aliyuncs.com/almond-donuts/default/tweet-type-covers/${isDark ? 'TYPE_COVER_DARK' : 'TYPE_COVER'}.jpg";
  }

  static Map<dynamic, TweetTypeEntity> getPushableTweetTypeMap() {
    return Map.fromIterable(tweetTypeMap.keys.where((k) => tweetTypeMap[k]!.pushable), value: (k) => tweetTypeMap[k]!);
  }

// static Map getAllTweetTypeMap() {
//   return Map.from(tweetTypeMap);
// }
}

class TweetTypeEntity {
  final String name;
  final String zhTag;
  final Color color;
  final String? coverUrl;
  final IconData iconData;
  final Color iconColor;
  final String intro;
  final String typeImage;

  // 是否可以被本地筛选掉
  final bool filterable;

  // 是否用户可以选择此类型标签发布内容
  final bool pushable;

  // 是否可以被用户取消订阅
  final bool canUnSubscribe;

  // 是否用户可见
  final bool visible;

  // 是否渲染卡片背景颜色
  final bool renderBg;

  const TweetTypeEntity(
      {required this.iconData,
      required this.iconColor,
      required this.name,
      required this.zhTag,
      required this.color,
      this.coverUrl,
      this.intro = "暂无介绍喔～",
      this.filterable = true,
      this.pushable = true,
      this.canUnSubscribe = true,
      this.typeImage = "",
      this.visible = true,
      this.renderBg = false});

  static const loveConfession = TweetTypeEntity(
      iconData: Icons.favorite,
      iconColor: Color(0xffcd9cf2),
      name: "LOVE_CONFESSION",
      zhTag: "表白",
      color: Color(0xffcd9cf2),
      intro: "对你何止一句中意",
      typeImage: "https://tva1.sinaimg.cn/large/007S8ZIlgy1gjbz0jt9h9j31910u0k49.jpg",
      renderBg: true,
      coverUrl: "https://iutr-image.oss-cn-hangzhou.aliyuncs.com/almond-donuts/default/type_cover_confession.png");

  static const askForMarriage = TweetTypeEntity(
      iconData: Icons.people_alt_sharp,
      iconColor: Color(0xffCD5C5C),
      name: "ASK_FOR_MARRIAGE",
      zhTag: "征婚",
      intro: "我想早恋，但已经晚了",
      typeImage: "https://tva1.sinaimg.cn/large/007S8ZIlgy1gjbz0jt9h9j31910u0k49.jpg",
      color: Color(0xffCD5C5C),
      renderBg: true,
      coverUrl: "https://iutr-image.oss-cn-hangzhou.aliyuncs.com/almond-donuts/default/type_cover_marriage.png");

  static const findSomeone = TweetTypeEntity(
      iconData: Icons.person_search,
      iconColor: Colors.lightBlue,
      name: "SOMEONE_FIND",
      intro: "世界上所有的相遇都是久别重逢",
      zhTag: "找人",
      typeImage: "https://tva1.sinaimg.cn/large/007S8ZIlgy1gjbz0jt9h9j31910u0k49.jpg",
      color: Colors.lightBlue);

  static const questionConsult = TweetTypeEntity(
      iconData: Icons.local_library,
      iconColor: Color(0xffFF82A9),
      name: "QUESTION_CONSULT",
      intro: "咨询一下，你就知道",
      color: Color(0xffFF82A9),
      typeImage: "https://tva1.sinaimg.cn/large/007S8ZIlgy1gjbz0jt9h9j31910u0k49.jpg",
      zhTag: "咨询");

  static const complaint = TweetTypeEntity(
      iconData: Icons.mood,
      iconColor: Color(0xffaa7aaF),
      name: "COMPLAINT",
      zhTag: "吐槽",
      color: Color(0xffaa7aaF),
      intro: "日子再坏，也要满怀期待",
      typeImage: "https://tva1.sinaimg.cn/large/007S8ZIlgy1gjbzief4r7j31900u0ws4.jpg",
      coverUrl: "https://iutr-image.oss-cn-hangzhou.aliyuncs.com/almond-donuts/default/type_cover_complaint.png");

  static const gossip = TweetTypeEntity(
      iconData: Icons.free_breakfast,
      iconColor: Color(0xff99bb93),
      intro: "多说话，多喝热水",
      typeImage: "https://tva1.sinaimg.cn/large/007S8ZIlgy1gjbz0jt9h9j31910u0k49.jpg",
      name: "GOSSIP",
      color: Color(0xff99bb93),
      coverUrl: 'https://tva1.sinaimg.cn/large/006y8mN6ly1g870g0gah7j30qo0xbwl7.jpg',
      zhTag: "闲聊");

  static const haveFun = TweetTypeEntity(
      iconData: Icons.toys,
      iconColor: Color(0xffDEB887),
      intro: "看到天上的星星了吗？是我打排位掉的",
      typeImage: "https://tva1.sinaimg.cn/large/007S8ZIlgy1gjbz0jt9h9j31910u0k49.jpg",
      name: "HAVE_FUN",
      color: Color(0xffDEB887),
      zhTag: "娱乐");

  static const share = TweetTypeEntity(
      iconData: Icons.star,
      iconColor: Color(0xff8AE1FC),
      intro: "快乐就要分享，分享了就更快乐",
      name: "SHARE",
      typeImage: "https://tva1.sinaimg.cn/large/007S8ZIlgy1gjbz0jt9h9j31910u0k49.jpg",
      color: Color(0xff8AE1FC),
      zhTag: "分享");

  static const lostAndFound = TweetTypeEntity(
      iconData: Icons.local_florist,
      iconColor: Color(0xff4E8098),
      intro: "你不等我回家，我还能去哪",
      name: "LOST_AND_FOUND",
      typeImage: "https://tva1.sinaimg.cn/large/007S8ZIlgy1gjbz0jt9h9j31910u0k49.jpg",
      color: Color(0xff4E8098),
      zhTag: "失物招领");

  static const helpAndReward = TweetTypeEntity(
      iconData: Icons.transfer_within_a_station,
      iconColor: Color(0xFFCD96CD),
      name: "HELP_AND_REWARD",
      intro: "送人玫瑰，手有余香",
      typeImage: "https://tva1.sinaimg.cn/large/007S8ZIlgy1gjbz0jt9h9j31910u0k49.jpg",
      color: Color(0xFFCD96CD),
      zhTag: "帮助");

  static const secondHandTran = TweetTypeEntity(
      iconData: Icons.attach_money_sharp,
      iconColor: Colors.blue,
      name: "SECOND_HAND_TRANSACTION",
      intro: "让价值再飞一会",
      color: Colors.blue,
      typeImage: "https://tva1.sinaimg.cn/large/007S8ZIlgy1gjbz0jt9h9j31910u0k49.jpg",
      zhTag: "二手交易");

  static const other = TweetTypeEntity(
      iconData: Icons.wb_sunny_rounded,
      iconColor: Color(0xff66CDAA),
      intro: "没有别的就选这个吧！",
      name: "OTHER",
      color: Color(0xff66CDAA),
      typeImage: "https://tva1.sinaimg.cn/large/007S8ZIlgy1gjbz0jt9h9j31910u0k49.jpg",
      zhTag: "其他");

  static const official = TweetTypeEntity(
      iconData: Icons.check_circle,
      iconColor: Color(0xff8470FF),
      name: "OFFICIAL",
      color: Color(0xff8470FF),
      zhTag: "官方",
      canUnSubscribe: false,
      pushable: false,
      typeImage: "https://tva1.sinaimg.cn/large/007S8ZIlgy1gjbz0jt9h9j31910u0k49.jpg",
      filterable: false);

  static const campusOfficial = TweetTypeEntity(
      iconData: Icons.check_circle,
      iconColor: Color(0xff8470FF),
      name: "CAMPUS_OFFICIAL",
      color: Color(0xff8470FF),
      zhTag: "官方",
      canUnSubscribe: false,
      pushable: false,
      typeImage: "https://tva1.sinaimg.cn/large/007S8ZIlgy1gjbz0jt9h9j31910u0k49.jpg",
      filterable: false);

  static const fallback = TweetTypeEntity(
      iconData: Icons.blur_circular,
      iconColor: Color(0xffFF6EB4),
      name: "FALLBACK",
      color: Color(0xffFF6EB4),
      zhTag: "内测",
      canUnSubscribe: false,
      pushable: false,
      typeImage: "https://tva1.sinaimg.cn/large/007S8ZIlgy1gjbz0jt9h9j31910u0k49.jpg",
      filterable: false,
      visible: false);

  static const ad = TweetTypeEntity(
      iconData: Icons.school,
      iconColor: Color(0xffA2B5CD),
      name: "AD",
      color: Color(0xffA2B5CD),
      zhTag: "广告",
      canUnSubscribe: false,
      pushable: false,
      filterable: false,
      visible: false);
}
