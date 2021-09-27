import 'package:flutter/material.dart';
import 'package:wall/application.dart';
import 'package:wall/config/routes/routes.dart';
import 'package:wall/constant/asset_path_constant.dart';
import 'package:wall/constant/gap_constant.dart';
import 'package:wall/model/biz/account/account.dart';
import 'package:wall/model/biz/common/gender.dart';
import 'package:wall/model/biz/tweet/tweet.dart';
import 'package:wall/model/biz/tweet/tweet_account.dart';
import 'package:wall/util/fluro_convert_utils.dart';
import 'package:wall/util/navigator_util.dart';
import 'package:wall/util/theme_util.dart';
import 'package:wall/widget/common/account_avatar.dart';
import 'package:wall/widget/tweet/tweet_body_wrapper.dart';
import 'package:fluro/fluro.dart';
import 'package:wall/widget/tweet/tweet_index_item_header.dart';
import 'package:wall/widget/tweet/tweet_media_wrapper.dart';
import 'package:wall/widget/tweet/tweet_praise_wrapper.dart';

class TweetIndexItem extends StatelessWidget {
//  final recomKey = GlobalKey<RecommendationState>();

  static final double maxWidthSinglePic = Application.screenWidth! * 0.75;
  final BaseTweet tweet;

  // space header 可点击
  final bool upClickable;

  // 点赞账户可点击
  final bool downClickable;

  // 点击回复框，回调home page textField
  final onClickComment;
  final sendReplyCallback;

  final bool displayPraise;
  final bool canPraise;
  final bool displayComment;
  final bool displayLink;
  final bool displayExtra;
  final bool displayInstitute;
  final bool myNickClickable;
  final bool needLeftProfile;
  final bool displayType;
  late BuildContext context;
  late bool isDark;
  final Function? onDetailDelete;

  late int indexInList;

  TweetIndexItem(this.tweet,
      {this.upClickable = true,
      this.downClickable = true,
      this.onClickComment,
      this.sendReplyCallback,
      this.displayPraise = false,
      this.displayLink = false,
      this.displayComment = false,
      this.displayInstitute = false,
      this.displayExtra = true,
      this.canPraise = false,
      this.myNickClickable = true,
      this.needLeftProfile = true,
      this.displayType = true,
      this.indexInList = -1,
      this.onDetailDelete}) {}

  @override
  Widget build(BuildContext context) {
    this.context = context;
    isDark = ThemeUtil.isDark(context);
    return cardContainer2(context);
  }

  Widget cardContainer2(BuildContext context) {
    Widget wd = Container(
        padding: EdgeInsets.only(bottom: 0.0, top: indexInList == 0 ? 12.0 : 10.0, left: 10.0, right: 15.0),
        // color: isDark ? Colours.dark_bg_color : Colors.white,
        child: GestureDetector(
          onTap: () => _forwardDetail(context),
          behavior: HitTestBehavior.translucent,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                flex: 5,
                fit: FlexFit.loose,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TweetIndexItemHeader(tweet.account!, tweet.anonymous!, tweet.sentTime!,
                        myNickClickable: myNickClickable, official: false),
                    Gaps.vGap10,
//                    TweetTypeWrapper(tweet.type),

                    // Gaps.vGap2,
                    TweetBodyWrapper(tweet.body, maxLine: 3, fontSize: 15, height: 1.6),
                    TweetMediaWrapper(tweet.id!, medias: tweet.medias, tweet: tweet),
                    // displayLink ? TweetLinkWrapper(tweet) : Gaps.empty,
                    Gaps.vGap8,

                    TweetPraiseWrapper(tweet, prefixIcon: true),
                    // TweetCampusWrapper(
                    //   tweet.id,
                    //   tweet.account.institute,
                    //   tweet.account.cla,
                    //   tweet.type,
                    //   tweet.anonymous,
                    //   displayType: displayType,
                    // ),
                    // displayExtra
                    //     ? TweetCardExtraWrapper(
                    //         displayPraise: displayPraise,
                    //         displayComment: displayComment,
                    //         tweet: tweet,
                    //         canPraise: canPraise,
                    //         onClickComment: onClickComment)
                    //     : Gaps.empty,
//                    displayComment && tweet.enableReply
//                        ? TweetCommentWrapper(
//                      tweet,
//                      displayReplyContainerCallback: displayReplyContainerCallback,
//                    )
//                        : Gaps.empty,
//                    displayComment ? Gaps.vGap25 : Gaps.vGap10,

                    Gaps.line,
                    Gaps.vGap5
                  ],
                ),
              )
            ],
          ),
        ));
    return wd;
  }

  Widget _profileContainer() {
    bool anonymous = tweet.anonymous!;
    Gender gender = anonymous ? Gender.unknown : Gender.parseGender(tweet.account!.gender!);
    return AccountAvatar(
        onTap: () => anonymous || !myNickClickable ? null : goAccountDetail2(context, tweet.account!, true),
        avatarUrl: !anonymous ? (tweet.account!.avatarUrl!) : AssetPathCst.svgAnonymousAvatarPath,
        gender: gender);
  }

  void _forwardDetail(BuildContext context) {
    // TODO 跳转详情
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) => TweetDetail(
    //             this.tweet,
    //             newLink: !displayLink,
    //             onDelete: onDetailDelete,
    //           )),
    // );
  }

  void goAccountDetail(BuildContext context, Account account, bool up) {
    // TODO 跳转详情
    // if ((up && upClickable) || (!up && downClickable)) {
    //   NavigatorUtils.push(
    //       context,
    //       Routes.accountProfile +
    //           Utils.packConvertArgs(
    //               {'nick': account.nick, 'accId': account.id, 'avatarUrl': account.avatarUrl}));
    // }
  }

  void goAccountDetail2(BuildContext context, TweetAccount account, bool up) {
    NavigatorUtils.push(
        context,
        Routes.accountProfile +
            FluroConvertUtils.packConvertArgs(
                {'nick': account.nick!, 'accId': account.id!, 'avatarUrl': account.avatarUrl!}),
        transitionType: TransitionType.fadeIn);
  }
}
