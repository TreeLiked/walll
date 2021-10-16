import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wall/util/asset_util.dart';
import 'package:wall/util/theme_util.dart';

class TweetNoDataView extends StatelessWidget {
  final Function? onTapReload;

  const TweetNoDataView({this.onTapReload});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 15.0, top: ScreenUtil().setHeight(160)),
          color: Colors.transparent,
          child: LoadAssetSvg(ThemeUtil.isDark(context) ? "common/no_data_dark" : "common/no_data", width: MediaQuery.of
            (context).size.width * 0.35),
        ),
        // GestureDetector(
        //   onTap: () => onTapReload == null ? null : onTapReload(),
        //   child: Text(
        //     '点击重新加载',
        //     style: pfStyle.copyWith(color: Colors.blueAccent, fontSize: Dimens.font_sp16, letterSpacing: 1.2),
        //   ),
        // )
      ],
    );
  }
}
