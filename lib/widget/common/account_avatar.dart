import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:wall/constant/asset_path_constant.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/constant/gap_constant.dart';
import 'package:wall/model/biz/common/gender.dart';
import 'package:wall/util/asset_util.dart';
import 'package:wall/util/theme_util.dart';

class AccountAvatar extends StatelessWidget {
  final double size;
  final bool whitePadding;
  final String avatarUrl;
  final GestureTapCallback? onTap;
  final bool cache;
  final Gender gender;
  final bool anonymous;
  final bool displayGender;

  const AccountAvatar(
      {Key? key,
      required this.avatarUrl,
      this.size = 40.0,
      this.onTap,
      this.cache = true,
      this.gender = Gender.unknown,
      this.whitePadding = false,
      this.anonymous = false,
      this.displayGender = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double genderFloatSize = size / 3;
    return Stack(children: [
      Container(
          decoration: BoxDecoration(
              // gradient: LinearGradient(colors: [Colors.yellow, Colors.redAccent]),
              // border: Border.all(
              //   color: Colors.black,
              // ),
              // border: whitePadding ? Border.all(width: 20,) : null,
              // borderRadius: BorderRadius.all((Radius.circular(50))),
              shape: BoxShape.circle,
              gradient: whitePadding
                  ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color.fromRGBO(0, 175, 255, 1.0), Color.fromRGBO(0, 244, 254, 1)])
                  : null),
          width: size,
          height: size,
          child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: GestureDetector(
                  onTap: onTap,
                  child: anonymous
                      ? LoadAssetSvg(AssetPathCst.svgAnonymousAvatarPath,
                          color: ThemeUtil.isDark(context) ? Colors.white30 : Colors.black,
                          width: double.infinity,
                          height: double.infinity)
                      : ClipOval(
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
                                      LoadAssetSvg(AssetPathCst.svgMaleAvatarPath, width: size, height: size)))))),
      gender.hasGender && !anonymous && displayGender
          ? Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(2.5),
                width: genderFloatSize,
                height: genderFloatSize,
                decoration: BoxDecoration(
                    color: gender == Gender.male ? Colours.maleMainColor : Colours.feMaleMainColor,
                    shape: BoxShape.circle),
                child: LoadAssetSvg(gender == Gender.male ? 'crm/male_signal' : 'crm/female_signal',
                    width: genderFloatSize, height: genderFloatSize, color: Colors.white),
              ))
          : Gaps.empty
    ]);
  }
}
