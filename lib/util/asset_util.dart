import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WidgetUtil {
  static Widget getAsset(String path, {double size = 20, bool click = false, final callback}) {
    if (!click) {
      return Image.asset(
        path,
        width: size,
        height: size,
      );
    } else {
      return Container(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            child: GestureDetector(
                onTap: () => callback(),
                child: Image.asset(
                  path,
                  width: size,
                  height: size,
                )),
          ),
        ),
      );
    }
  }

  static Widget getIcon(IconData iconData, Color color,
      {double size = 20, bool click = false, final callback}) {
    if (!click) {
      return Icon(
        iconData,
        color: color,
        size: size,
      );
    } else {
      return GestureDetector(
          onTap: () => callback(),
          child: Icon(
            iconData,
            color: color,
            size: size,
          ));
    }
  }

  static Widget getEmptyContainer({double height = 0}) {
    return Container(height: height);
  }
}

/// 加载本地资源图片
class LoadAssetImage extends StatelessWidget {
  const LoadAssetImage(this.image,
      {Key? key, this.width, this.height, this.fit = BoxFit.cover, this.format = 'png', this.color})
      : super(key: key);

  final String image;
  final double? width;
  final double? height;
  final BoxFit fit;
  final String format;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      image.startsWith("assets") ? image : 'assets/images/$image.$format',
      height: height,
      width: width,
      fit: fit,
      color: color,
    );
  }
}

class LoadAssetIcon extends StatelessWidget {
  const LoadAssetIcon(this.image,
      {Key? key, this.width, this.height, this.fit = BoxFit.cover, this.format = 'png', this.color})
      : super(key: key);

  final String image;
  final double? width;
  final double? height;
  final BoxFit fit;
  final String format;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      image.startsWith("assets") ? image : 'assets/icons/$image.$format',
      height: height,
      width: width,
      fit: fit,
      color: color,
    );
  }
}

class LoadAssetSvg extends StatelessWidget {
  const LoadAssetSvg(this.svgName,
      {Key? key, this.width, this.height, this.fit = BoxFit.cover, this.format = 'svg', this.color})
      : super(key: key);

  final String svgName;
  final double? width;
  final double? height;
  final BoxFit fit;
  final String? format;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      svgName.startsWith("assets") ? svgName : 'assets/svg/$svgName.$format',
      key: key,
      width: width,
      height: height,
      fit: fit,
      color: color,
      alignment: Alignment.center,
    );
  }
}
