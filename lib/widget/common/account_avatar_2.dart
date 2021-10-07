import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:wall/constant/asset_path_constant.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/constant/gap_constant.dart';
import 'package:wall/model/biz/common/gender.dart';
import 'package:wall/util/asset_util.dart';

/// 指定边框颜色的avatar
class AccountAvatar2 extends StatelessWidget {
  final double size;
  final double borderWidth;
  final Color borderColor;
  final String avatarUrl;
  final GestureTapCallback? onTap;
  final bool cache;
  final Gender gender;

  const AccountAvatar2(
      {Key? key,
      required this.avatarUrl,
      this.size = 40.0,
      this.borderWidth = 3.0,
      this.onTap,
      this.cache = true,
      this.gender = Gender.unknown,
      this.borderColor = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double genderFloatSize = size / 3.3;
    return Stack(children: [
      Container(
          decoration: BoxDecoration(border: Border.all(color: borderColor, width: borderWidth), shape: BoxShape.circle),
          width: size,
          height: size,
          child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: GestureDetector(
                  onTap: onTap,
                  child: Hero(
                    tag: "IMAGE_HERO",
                    child: ClipOval(
                        child: !cache
                            ? FadeInImage.memoryNetwork(
                                image: avatarUrl,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                                placeholder: kTransparentImage)
                            : CachedNetworkImage(
                                imageUrl: avatarUrl,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                                placeholder: (ctx, url) =>
                                    LoadAssetSvg(AssetPathCst.svgMaleAvatarPath, width: size, height: size))),
                  )))),
      (Gender.male == gender || Gender.female == gender)
          ? Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                  padding: const EdgeInsets.all(2.5),
                  width: genderFloatSize,
                  height: genderFloatSize,
                  decoration: BoxDecoration(
                      color: gender == Gender.male ? Colours.maleMainColor : Colours.feMaleMainColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: borderColor, width: borderWidth / 1.5)),
                  child: LoadAssetSvg(gender == Gender.male ? 'crm/male_signal' : 'crm/female_signal',
                      width: genderFloatSize, height: genderFloatSize, color: Colors.white)))
          : Gaps.empty
    ]);
  }
}
