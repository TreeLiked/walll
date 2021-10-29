import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';
import 'package:sp_util/sp_util.dart';
import 'package:wall/api/invite_api.dart';
import 'package:wall/application.dart';
import 'package:wall/config/routes/setting_router.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/constant/gap_constant.dart';
import 'package:wall/constant/shared_constant.dart';
import 'package:wall/provider/account_local_provider.dart';
import 'package:wall/provider/theme_provider.dart';
import 'package:wall/util/asset_util.dart';
import 'package:wall/util/bottom_sheet_util.dart';
import 'package:wall/util/common_util.dart';
import 'package:wall/util/navigator_util.dart';
import 'package:wall/util/toast_util.dart';
import 'package:wall/widget/common/container/center_row_text.dart';
import 'package:wall/widget/common/container/shadow_container.dart';
import 'package:wall/widget/common/custom_app_bar.dart';
import 'package:wall/widget/common/dialog/bottom_cancel_confirm.dart';
import 'package:wall/widget/common/real_rich_text.dart';
import 'package:wall/widget/setting/setting_row_item.dart';

// 其他设置
class AccountOtherSettingPage extends StatefulWidget {
  const AccountOtherSettingPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AccountOtherSettingPageState();
  }
}

class _AccountOtherSettingPageState extends State<AccountOtherSettingPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(
          title: '其它设置',
        ),
        body: Consumer<AccountLocalProvider>(builder: (_, provider, __) {
          return SingleChildScrollView(
              child: Column(children: <Widget>[
            SettingRowItem(
                title: '清理缓存',
                onTap: () {
                  PaintingBinding.instance!.imageCache?.clear();
                  DefaultCacheManager().emptyCache();
                  ToastUtil.showToast(context, '清理成功');
                }),
            SettingRowItem(
                title: '恢复已屏蔽的首页内容',
                onTap: () async {
                  await SpUtil.remove(SharedCst.unLikeTweetIds);
                  ToastUtil.showToast(context, '恢复成功，请手动刷新');
                }),
          ]));
        }));
  }
}
