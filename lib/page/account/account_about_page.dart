import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';
import 'package:sp_util/sp_util.dart';
import 'package:wall/api/api_category.dart';
import 'package:wall/api/invite_api.dart';
import 'package:wall/application.dart';
import 'package:wall/config/routes/setting_router.dart';
import 'package:wall/constant/app_constant.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/constant/gap_constant.dart';
import 'package:wall/constant/shared_constant.dart';
import 'package:wall/provider/account_local_provider.dart';
import 'package:wall/provider/theme_provider.dart';
import 'package:wall/util/asset_util.dart';
import 'package:wall/util/bottom_sheet_util.dart';
import 'package:wall/util/common_util.dart';
import 'package:wall/util/navigator_util.dart';
import 'package:wall/util/theme_util.dart';
import 'package:wall/util/toast_util.dart';
import 'package:wall/util/version_util.dart';
import 'package:wall/widget/common/container/center_row_text.dart';
import 'package:wall/widget/common/container/shadow_container.dart';
import 'package:wall/widget/common/custom_app_bar.dart';
import 'package:wall/widget/common/dialog/bottom_cancel_confirm.dart';
import 'package:wall/widget/common/dialog/simple_cancel_confirm_dialog.dart';
import 'package:wall/widget/common/dialog/simple_confirm_dialog.dart';
import 'package:wall/widget/common/real_rich_text.dart';
import 'package:wall/widget/setting/setting_row_item.dart';

// 关于我们
class AccountAboutPage extends StatefulWidget {
  const AccountAboutPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AccountAboutPageState();
  }
}

class _AccountAboutPageState extends State<AccountAboutPage> with SingleTickerProviderStateMixin {
  late AnimationController controller1;

  late Animation animation2;

  @override
  void initState() {
    super.initState();
    controller1 = AnimationController(vsync: this, duration: const Duration(seconds: 10));
    animation2 = Tween(begin: 0.0, end: 1.0).animate(controller1);
    controller1.repeat();
  }

  @override
  void dispose() {
    controller1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool ios = Platform.isIOS;

    return Scaffold(
        appBar: const CustomAppBar(
          title: '关于我们',
        ),
        body: Consumer<AccountLocalProvider>(builder: (_, provider, __) {
          return SingleChildScrollView(
              child: Column(children: <Widget>[
            Gaps.vGap30,
            GestureDetector(
                child: RotationTransition(
                    turns: animation2 as Animation<double>,
                    child: const LoadAssetImage('wall_logo_tran', width: 100, height: 100)),
                onTap: () => ToastUtil.showToast(context, "Hey ~ Contact and join me")),
            Gaps.vGap50,
            SettingRowItem(
                title: '关于我们',
                content: 'IUTR.TECH_WALL',
                onLongPress: () => ToastUtil.showToast(
                    context, '${Application.getDeviceId} - ${ios ? AppCst.versionIdIos : AppCst.versionIdAndroid}')),
            SettingRowItem(
                title: '使用须知',
                content: '服务协议',
                onTap: () {
                  NavigatorUtils.goWebViewPage(context, "Wall服务协议", Api.agreementUrl);
                }),
            SettingRowItem(
                title: '检查更新',
                content: 'v${ios ? AppCst.versionRemarkIos : AppCst.versionRemarkAndroid}',
                onTap: () {
                  Util.showDefaultLoadingWithBounds(context, text: '正在检查');
                  VersionUtils.checkUpdate(context: context).then((result) {
                    NavigatorUtils.goBack(context);
                    VersionUtils.displayUpdateDialog(result, context: context);
                  });
                }),
            SettingRowItem(
                title: '联系我',
                content: '微信｜邮箱',
                onTap: () {
                  BottomSheetUtil.showBottomSheet(
                      context,
                      0.3,
                      const SimpleConfirmDialog(
                          content: '你可以添加微信号：dlwlrma73\n或发送邮件到 im.lqs2@icloud.com和我联系', confirmText: '我知道啦'));
                }),
            SettingRowItem(
                title: '分享给朋友',
                onTap: () {
                  Util.copyTextToClipBoard(Api.sharePageUrl);
                  ToastUtil.showToast(context, '分享链接已复制到粘贴板');
                  NavigatorUtils.goWebViewPage(context, "分享给朋友", Api.sharePageUrl);
                })
          ]));
        }));
  }
}
