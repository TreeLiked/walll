import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wall/constant/gap_constant.dart';

class ImageContainer extends StatelessWidget {
  final String url;
  final double width;
  final double height;
  final double? maxWidth;
  final double? maxHeight;
  final EdgeInsetsGeometry? padding;
  final Widget? errorWidget;
  final Function? callback;
  final bool round;

  const ImageContainer(
      {required this.url,
      required this.width,
      required this.height,
      this.callback,
      this.padding,
      this.maxWidth,
      this.errorWidget,
      this.round = true,
      this.maxHeight});

  @override
  Widget build(BuildContext context) {
    return Container(
        // %2 因为索引从0开始，3的倍数右边距设为0
        constraints: maxWidth != null || maxHeight != null
            ? BoxConstraints(maxHeight: maxHeight ?? double.infinity, maxWidth: maxWidth ?? double.infinity)
            : null,
        padding: padding,
        width: width,
        height: height,
        child: GestureDetector(
            onTap: callback == null ? null : callback!(),
            child: round
                ? ClipRRect(
                    child: CachedNetworkImage(
                        filterQuality: FilterQuality.medium,
                        imageUrl: url,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const CupertinoActivityIndicator(),
                        errorWidget: (context, url, error) => errorWidget ?? Gaps.empty),
                    borderRadius: BorderRadius.circular(4.0))
                : CachedNetworkImage(
                    filterQuality: FilterQuality.medium,
                    imageUrl: url,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const CupertinoActivityIndicator(),
                    errorWidget: (context, url, error) => errorWidget ?? Gaps.empty)));
  }
}
