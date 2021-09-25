import 'package:flutter/material.dart';
import 'package:wall/application.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/constant/gap_constant.dart';
import 'package:wall/util/common_util.dart';
import 'package:wall/util/navigator_util.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageHeroPage extends StatelessWidget {
  final String url;

  const ImageHeroPage({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            GestureDetector(
              onTap: () => NavigatorUtils.goBack(context),
              child: Container(
                alignment: Alignment.center,
                child: Hero(
                  tag: "IMAGE_HERO",
                  child: CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.fitWidth,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width),
                ),
              ),
            ),
            Positioned(
                child: Container(
                    decoration: BoxDecoration(
                        // color: Colors.white10,
                        borderRadius: BorderRadius.circular(6.0),
                        border: Border.all(color: Colors.white30, width: 1.5)),
                    width: 130,
                    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                    alignment: Alignment.center,
                    child: InkWell(
                        onTap: () => Util.saveImage(context, url),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
                          Icon(Icons.download_rounded, color: Colors.white, size: 13.0),
                          Gaps.hGap5,
                          Text('保存图片', style: TextStyle(color: Colors.white, fontSize: 13))
                        ]))),
                bottom: 80,
                left: (Application.screenWidth! - 130) / 2)
          ],
        ));
  }
}
