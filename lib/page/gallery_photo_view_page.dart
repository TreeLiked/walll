import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:wall/constant/app_constant.dart';
import 'package:wall/util/navigator_util.dart';

class GalleryPhotoViewWrapper extends StatefulWidget {
  GalleryPhotoViewWrapper(
      {required this.loadingChild,
      this.usePageViewWrapper = false,
      this.backgroundDecoration,
      this.minScale,
      this.maxScale,
      required this.initialIndex,
      this.fromNetwork = true,
      this.onLongPress,
      required this.galleryItems})
      : pageController = PageController(initialPage: initialIndex);

  final Widget loadingChild;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final List<PhotoWrapItem> galleryItems;
  final bool usePageViewWrapper;

  final bool fromNetwork;
  final Function? onLongPress;

  @override
  State<StatefulWidget> createState() {
    return _GalleryPhotoViewWrapperState();
  }
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
      onTap: () => NavigatorUtils.goBack(context),
      onLongPress: () {
        if (widget.onLongPress == null) {
          return;
        }
        widget.onLongPress!(widget.galleryItems[currentIndex]);
      },
      child: Container(
          decoration: widget.backgroundDecoration,
          constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height,
          ),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: <Widget>[
              PhotoViewGallery.builder(
                scrollPhysics: const BouncingScrollPhysics(),
                builder: _buildItem,
                itemCount: widget.galleryItems.length,
                // loadingBuilder: LoadB,
                loadingBuilder: (context, _) => widget.loadingChild,
                // loadingChild: widget.loadingChild,
                backgroundDecoration: widget.backgroundDecoration,
                pageController: widget.pageController,
                onPageChanged: onPageChanged,
                enableRotation: false,
              ),
//               Positioned(
//                   // left: sw / 2,
//                   top: ScreenUtil.statusBarHeight + ScreenUtil().setHeight(20),
//                   left: 10,
//                   child: Container(
//                     width: Application.screenWidth - 20,
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
// //                      color: Colors.white10,
//                       borderRadius: const BorderRadius.all(
//                         Radius.circular(10.0),
//                       ),
//                     ),
//                     child: Row(children: <Widget>[
//                       Flexible(
//                         flex: 1,
//                         child: Container(),
//                       ),
//                       Flexible(
//                         flex: 1,
//                         child: Container(
//                           alignment: Alignment.center,
// //                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//                           child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: _renderDots(currentIndex)
// //                            <Widget>[
// //                              _genDot(realColor: Colors.yellow),
// //                              _genDot(),
// //                              Text(
// //                                "${currentIndex + 1}",
// //                                style: const TextStyle(
// //                                    color: Colors.yellow,
// //                                    fontWeight: FontWeight.w400,
// //                                    fontStyle: FontStyle.italic,
// //                                    fontSize: Dimens.font_sp18 * 2),
// //                              ),
// //                              Text(" / ", style: const TextStyle(color: Colors.white70, fontSize: 16)),
// //                              Text("${widget.galleryItems.length}",
// //                                  style: const TextStyle(color: Colors.white70, fontSize: 16)),
// ////                              Text(
// ////                                  widget.galleryItems.length != 1
// ////                                      ? '${currentIndex + 1} / ${widget.galleryItems.length}'
// ////                                      : '',
// ////                                  style: TextStyle(color: Colors.white70, fontSize: 16))
// //                            ],
//                               ),
//                         ),
//                       ),
//                       Flexible(
//                         flex: 1,
//                         child: Container(
//                             margin: EdgeInsets.only(top: 0, right: 0.0),
//                             alignment: Alignment.centerRight,
//                             child: GestureDetector(
//                                 child: Icon(
//                                   Icons.more_horiz,
//                                   color: Colors.white70,
//                                 ),
//                                 onTap: () => displayOptions())),
//                       ),
//                     ]),
//                   )),
              // Positioned(
              //     bottom: Application.screenHeight * 0.1,
              //     left: Application.screenWidth * 0.05,
              //     child: GestureDetector(
              //       child: ClipRRect(
              //         borderRadius: BorderRadius.circular(18),
              //         child: Container(
              //           color: Colors.white12,
              //           width: 35,
              //           height: 35,
              //           alignment: Alignment.center,
              //           child: Icon(Icons.arrow_back, color: Colors.amber, size: 20),
              //         ),
              //       ),
              //       onTap: () => NavigatorUtils.goBack(context),
              //     ))
            ],
          )),
    ));
  }

  List<Widget> _renderDots(int currentIndex) {
    int len = widget.galleryItems.length;
    if (len < 2) {
      return [];
    }
    List<Widget> dots = [];
    for (int i = 0; i < len; i++) {
      dots.add(_genDot(margin: 3.0, size: 8.0, realColor: currentIndex == i ? Colors.amber : Color(0xffCDCDCD)));
    }
    return dots;
  }

  Widget _genDot(
      {Color realColor = Colors.transparent,
      Color borderColor = Colors.transparent,
      double size = 5.0,
      double margin = 1.0}) {
    return Container(
      width: size,
      height: size,
      decoration:
          BoxDecoration(color: realColor, shape: BoxShape.circle, border: Border.all(color: borderColor, width: 0.5)),
      margin: EdgeInsets.all(margin),
    );
  }

  // void displayOptions() {
  //   if (widget.fromNetwork) {
  //     BottomSheetUtil.showBottomSheetView(context, [
  //       BottomSheetItem(
  //           Icon(
  //             Icons.file_download,
  //             color: Colors.lightBlue,
  //           ),
  //           '保存到本地', () async {
  //         Utils.showDefaultLoadingWithBounds(context, text: "正在保存");
  //         bool saveResult = false;
  //         try {
  //           bool hasPermission = await PermissionUtil.checkAndRequestStorage(context);
  //           if (hasPermission) {
  //             saveResult = await Utils.downloadAndSaveImageFromUrl(widget.galleryItems[currentIndex].url);
  //           }
  //         } catch (e, stack) {
  //           saveResult = false;
  //         } finally {
  //           Navigator.pop(context);
  //           if (saveResult) {
  //             ToastUtil.showToast(context, '已保存到手机相册');
  //           } else {
  //             ToastUtil.showToast(context, '保存失败');
  //           }
  //         }
  //       }),
  //       BottomSheetItem(
  //           Icon(
  //             Icons.warning,
  //             color: Colors.grey,
  //           ),
  //           '举报', () {
  //         Navigator.pop(context);
  //         NavigatorUtils.goReportPage(
  //             context, ReportPage.REPORT_TWEET_IMAGE, widget.galleryItems[currentIndex].url, "图片举报");
  //       }),
  //     ]);
  //   } else {
  //     BottomSheetUtil.showBottomSheetView(context, [
  //       BottomSheetItem(
  //           Icon(
  //             Icons.delete,
  //             color: Colors.lightBlue,
  //           ),
  //           '删除', () async {
  //         setState(() {
  //           widget.galleryItems.removeAt(currentIndex);
  //         });
  //       }),
  //       BottomSheetItem(
  //           Icon(
  //             Icons.warning,
  //             color: Colors.grey,
  //           ),
  //           '举报', () {
  //         Navigator.pop(context);
  //         ToastUtil.showToast(context, '举报成功');
  //       }),
  //     ]);
  //   }
  // }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final PhotoWrapItem item = widget.galleryItems[index];
    return PhotoViewGalleryPageOptions(
      imageProvider: widget.fromNetwork
          ? CachedNetworkImageProvider(
              item.url + AppCst.previewSuffix,
            )
          : FileImage(File(item.url)) as ImageProvider,
      initialScale: PhotoViewComputedScale.contained,
      // minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      minScale: PhotoViewComputedScale.contained,
      maxScale: PhotoViewComputedScale.covered * 1.5,
      heroAttributes: PhotoViewHeroAttributes(tag: index),
    );
  }
}

class PhotoWrapItem {
  final int index;
  final String url;

  const PhotoWrapItem({required this.index, required this.url});
}
