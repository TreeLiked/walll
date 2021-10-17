import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sp_util/sp_util.dart';
import 'package:wall/api/invite_api.dart';
import 'package:wall/application.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/constant/gap_constant.dart';
import 'package:wall/constant/shared_constant.dart';
import 'package:wall/provider/account_local_provider.dart';
import 'package:wall/provider/theme_provider.dart';
import 'package:wall/util/asset_util.dart';
import 'package:wall/util/bottom_sheet_util.dart';
import 'package:wall/util/common_util.dart';
import 'package:wall/util/navigator_util.dart';
import 'package:wall/widget/common/container/center_row_text.dart';
import 'package:wall/widget/common/container/shadow_container.dart';
import 'package:wall/widget/common/custom_app_bar.dart';
import 'package:wall/widget/common/dialog/bottom_cancel_confirm.dart';
import 'package:wall/widget/common/real_rich_text.dart';
import 'package:wall/widget/setting/setting_row_item.dart';
import 'package:wall/widget/setting/system_exit_dialog.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AccountSettingsPageState();
  }
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  bool _onInvite = false;

  String _themeModeStr = "";
  String _theme = "";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      getCurrentTheme();
      checkOnInvite();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  checkOnInvite() {
    InviteAPI.checkIsInInvitation().then((res) {
      if (res.isSuccess) {
        setState(() {
          _onInvite = true;
        });
      }
    });
  }

  getCurrentTheme() {
    String? theme = SpUtil.getString(SharedCst.theme);
    String themeMode;
    switch (theme ?? "") {
      case "Dark":
        themeMode = "开启";
        break;
      case "Light":
        themeMode = "关闭";
        break;
      default:
        theme = ThemeProvider.themes[Themes.system];
        themeMode = "跟随系统";
        break;
    }
    setState(() {
      _theme = theme!;
      _themeModeStr = themeMode;
    });
  }

  void loopColor() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(title: '设置',),
        body: Consumer<AccountLocalProvider>(builder: (_, provider, __) {
          return SingleChildScrollView(
              child: Column(children: <Widget>[
            SettingRowItem(title: '我的组织', content: Application.getOrgName!),
            SettingRowItem(
              title: '个人资料',
              onTap: () {},
            ),
            SettingRowItem(
              title: '隐私设置',
              onTap: () {},
            ),
            Gaps.line,
            SettingRowItem(
              title: '深色模式',
              content: _themeModeStr,
              onTap: () => _handleClickThemeItem(context),
            ),
            SettingRowItem(
              title: '其它设置',
              onTap: () {},
            ),
            Gaps.line,
            SettingRowItem(
              title: '关于我们',
              onTap: () {},
            ),
            _onInvite
                ? SettingRowItem(
                    title: '我的内测',
                    onTap: () {},
                  )
                : Gaps.empty,
            Gaps.line,
            InkWell(
                onTap: () async {
                  BottomSheetUtil.showBottomSheet(
                      context,
                      0.3,
                      BottomCancelConfirmDialog(
                        content: '确认退出登录吗',
                        onCancel: () => NavigatorUtils.goBack(context),
                        confirmBgColor: Colors.orangeAccent,
                        onConfirm: () {
                          Util.loginOut(context);
                        },
                      ));
                  // showElasticDialog(
                  //     context: context, barrierDismissible: true, builder: (_) => const SystemExitDialog()
                  // );
                },
                // onTap: () => showGeneralDialog(
                //     context: context, barrierDismissible: false,
                //     pageBuilder: (BuildContext context, Animation<double> animation, Animation<double>
                //     secondaryAnimation) { return const SystemExitDialog(); }),
                child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                    alignment: Alignment.center,
                    child: const Text('退出登录',
                        style: TextStyle(color: Colors.orange, fontSize: 14.5, fontWeight: FontWeight.bold))))
          ]));
        }));
  }

  _handleClickThemeItem(BuildContext context) {
    BottomSheetUtil.showBottomSheet(
        context,
        .4,
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Gaps.vGap15,
            const CenterRowWidget(child: Text('深色模式', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.5))),
            Gaps.vGap50,
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: _getThemeIconList()),
            CenterRowWidget(
                margin: const EdgeInsets.only(top: 50.0),
                child: RealRichText([
                  const TextSpan(text: '当前设置:  ', style: TextStyle(color: Colours.secondaryFontColor, fontSize: 13.5)),
                  TextSpan(text: _themeModeStr, style: const TextStyle(color: Colors.orange)),
                ])),
          ],
        ),
        topLine: false);
  }

  List<Widget> _getThemeIconList() {
    List<Widget> list = [];
    list.add(ShadowContainer(
        child: const LoadAssetSvg('setting/theme_sun', width: 50, height: 50),
        radius: 11.0,
        padding: const EdgeInsets.all(15.0),
        onClick: () => _changeTheme(context, Themes.light)));
    list.add(ShadowContainer(
        child: const LoadAssetSvg('setting/theme_moon', width: 50, height: 50),
        radius: 11.0,
        padding: const EdgeInsets.all(15.0),
        onClick: () => _changeTheme(context, Themes.dark)));
    list.add(ShadowContainer(
        child: const LoadAssetSvg('setting/theme_auto', width: 50, height: 50, color: Colors.green),
        radius: 11.0,
        padding: const EdgeInsets.all(15.0),
        onClick: () => _changeTheme(context, Themes.system)));
    if (_theme == ThemeProvider.themes[Themes.light]) {
      list.removeAt(0);
    } else if (_theme == ThemeProvider.themes[Themes.dark]) {
      list.removeAt(1);
    } else {
      list.removeAt(2);
    }
    return list;
  }

  /// 切换主题
  _changeTheme(BuildContext context, Themes theme) {
    Provider.of<ThemeProvider>(context, listen: false).setTheme(theme);
    getCurrentTheme();
    NavigatorUtils.goBack(context);
  }
}
