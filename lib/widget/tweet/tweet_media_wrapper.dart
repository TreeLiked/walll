import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wall/constant/app_constant.dart';
import 'package:wall/constant/asset_path_constant.dart';
import 'package:wall/constant/gap_constant.dart';
import 'package:wall/model/biz/common/media.dart';
import 'package:wall/model/biz/tweet/tweet.dart';
import 'package:wall/page/gallery_photo_view_page.dart';
import 'package:wall/util/asset_util.dart';
import 'package:wall/util/bottom_sheet_util.dart';
import 'package:wall/util/coll_util.dart';
import 'package:wall/util/common_util.dart';
import 'package:wall/util/navigator_util.dart';
import 'package:wall/util/perm_util.dart';
import 'package:wall/util/toast_util.dart';
import 'package:wall/widget/common/image/imgae_container.dart';

import '../../application.dart';

class TweetMediaWrapper extends StatelessWidget {
  static double availSw = Application.screenWidth! - 50;
  static double sh = Application.screenHeight!;

  final BaseTweet tweet;

  late int tweetId;
  late List<Media>? medias;
  late final List<String>? picUrls;

  TweetMediaWrapper({Key? key, required this.tweet}) : super(key: key) {
    tweetId = tweet.id!;
    medias = tweet.medias;
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
            ? SingleImgWrapper(imageUrl: picUrls![0], sw: availSw, sh: sh, onTap: () => open(context, 0, 0))
            : MultiImgWrapper(
                imageUrls: picUrls!, sw: availSw, sh: sh, onTap: (idx) => open(context, idx, picUrls!.length)));
  }

  void open(BuildContext context, final int index, final int total) {
    openPhotoView(context, picUrls, index, tweetId);
  }

  void openPhotoView(BuildContext context, List<String>? urls, int initialIndex, int refId) {
    if (CollUtil.isListEmpty(urls)) {
      return;
    }
    List<PhotoWrapItem> items =
        urls!.map((f) => PhotoWrapItem(index: initialIndex, url: Uri.decodeComponent(f))).toList();

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => GalleryPhotoViewWrapper(
                usePageViewWrapper: true,
                galleryItems: items,
                backgroundDecoration: const BoxDecoration(color: Colors.black),
                loadingChild: const SpinKitRing(color: Colors.grey, size: 20.0, lineWidth: 2.5),
                initialIndex: initialIndex,
                fromNetwork: true,
                onLongPress: (photoWrapItem) => _handleAndDisplayOptions(context, photoWrapItem, refId.toString())),
            maintainState: false));
  }

  void _handleAndDisplayOptions(BuildContext context, PhotoWrapItem item, String refId) {
    BottomSheetUtil.showBottomSheetView(context, [
      BottomSheetItem(const Icon(Icons.file_download, color: Colors.green), '保存', () async {
        Util.showDefaultLoadingWithBounds(context, text: "正在保存");
        bool saveResult = false;
        try {
          bool hasPermission = await PermissionUtil.checkAndRequestStorage(context);
          if (hasPermission) {
            saveResult = await Util.downloadAndSaveImageFromUrl(item.url);
          }
        } catch (e, stack) {
          saveResult = false;
        } finally {
          Navigator.pop(context);
          if (saveResult) {
            ToastUtil.showToast(context, '已保存到手机相册');
            Navigator.pop(context);
          } else {
            ToastUtil.showToast(context, '保存失败');
          }
        }
      }),
      BottomSheetItem(const Icon(Icons.warning, color: Colors.orange), '图片违规', () {
        Navigator.pop(context);
        ToastUtil.showToast(context, '举报成功，我们将在第一时间给您反馈');

        // NavigatorUtils.goReportPage(
        //     context, ReportPage.REPORT_TWEET_IMAGE, widget.galleryItems[currentIndex].url, "图片举报");
      }),
      BottomSheetItem(const Icon(Icons.share, color: Colors.lightBlueAccent), '分享到...', () {
        Navigator.pop(context);
        ToastUtil.showToast(context, '暂时无法分享');
      })
    ]);
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
        child: Container(
            constraints: BoxConstraints(maxWidth: sw * 0.6, maxHeight: sh * 0.25),
            margin: const EdgeInsets.only(bottom: 10.0),
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

    return Semantics(
        child: GridView.builder(
            shrinkWrap: true,
            itemCount: imageUrlsFull.length,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 1),
            itemBuilder: (context, index) => _imgContainer(imageUrlsFull[index], index, total, context)));
    // List<Widget> list = [];
    // for (int i = 0; i < total; i++) {
    //   list.add(_imgContainer(imageUrlsFull[i], i, total, context));
    // }
    // return Wrap(children: list);
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
        padding: EdgeInsets.only(right: 0, bottom: 0),
        callback: onTap == null ? null : () => onTap!(index));
  }
}