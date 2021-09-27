import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wall/constant/app_constant.dart';
import 'package:wall/constant/asset_path_constant.dart';
import 'package:wall/constant/gap_constant.dart';
import 'package:wall/model/biz/common/media.dart';
import 'package:wall/model/biz/tweet/tweet.dart';
import 'package:wall/util/asset_util.dart';
import 'package:wall/util/coll_util.dart';
import 'package:wall/widget/common/image/imgae_container.dart';

import '../../application.dart';

class TweetMediaWrapper extends StatelessWidget {
  static double availSw = Application.screenWidth! - 25;
  static double sh = Application.screenHeight!;

  final List<Media>? medias;
  late final List<String>? picUrls;
  final int tweetId;
  final BaseTweet tweet;

  TweetMediaWrapper(this.tweetId, {Key? key, required this.medias, required this.tweet}) : super(key: key) {
    if (medias != null) {
      List<Media> temp = List.from(medias!)..retainWhere((media) => media.mediaType == Media.typeImage);
      picUrls = temp.map((f) => f.url!).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (CollUtil.isListEmpty(medias)) {
      return Gaps.empty;
    }
    return Container(
        padding: const EdgeInsets.only(top: 10.0),
        child: picUrls!.length == 1
            ? SingleImgWrapper(imageUrl: picUrls![0], sw: availSw, sh: sh, onTap: () => open(context, 0))
            : MultiImgWrapper(imageUrls: picUrls!, sw: availSw, sh: sh, onTap: (idx) => open(context, idx)));
  }

  void open(BuildContext context, final int index) {
    // Util.openPhotoView(context, picUrls, index, tweetId);
  }
}

class SingleImgWrapper extends StatelessWidget {
  final String imageUrl;
  final double sw;
  final double sh;
  final Function? onTap;

  const SingleImgWrapper({Key? key, required this.imageUrl, required this.sw, required this.sh, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imageUrlFull = "$imageUrl${AppCst.thumbnailSuffix}";
    return GestureDetector(
        onTap: onTap == null ? null : () => onTap!(),
        child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: sw * 0.6, maxHeight: sh * 0.25),
            child: ClipRRect(
                child: CachedNetworkImage(
                    filterQuality: FilterQuality.high,
                    imageUrl: imageUrlFull,
                    placeholder: (context, url) =>
                        LoadAssetImage(AssetPathCst.imgHolderImgPath, width: sw * 0.25, height: sw * 0.25)),
                borderRadius: BorderRadius.circular(4.0))));
  }
}

class MultiImgWrapper extends StatelessWidget {
  static const double _imgRightPadding = 10.0;

  final List<String> imageUrls;
  final double sw;
  final double sh;
  final Function? onTap;

  const MultiImgWrapper({Key? key, required this.imageUrls, required this.sw, required this.sh, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> imageUrlsFull = imageUrls.map((f) => "$f${AppCst.thumbnailSuffix}").toList();
    int total = imageUrlsFull.length;

    List<Widget> list = [];
    for (int i = 0; i < total; i++) {
      list.add(_imgContainer(imageUrlsFull[i], i, total, context));
    }
    return Wrap(children: list);
  }

  Widget _imgContainer(String url, int index, int totalSize, BuildContext context) {
    double curRightPadding = _imgRightPadding;
    // 40 最外层container左右padding,
    double left = (sw);
    double perW = (left - _imgRightPadding * 2) / 3;
    if (index % 3 == 2) {
      curRightPadding = 0;
    }
    // if (totalSize == 2 || totalSize == 4) {
    //   if (totalSize == 2) {
    //     perW = (left - _imgRightPadding * 2) / 2.6;
    //   } else {
    //     perW = (left - _imgRightPadding * 4) / 2.2;
    //   }
    // } else {
    //   perW = (left - _imgRightPadding * 2 - 1) / 3;
    // }
    return ImageContainer(
        url: url,
        width: perW,
        height: perW,
        padding: EdgeInsets.only(right: curRightPadding, bottom: _imgRightPadding),
        callback: onTap == null ? null : () => onTap!(index));
  }
}
