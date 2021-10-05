import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:wall/api/device_api.dart';
import 'package:wall/application.dart';
import 'package:wall/config/routes/login_router.dart';
import 'package:wall/util/common_util.dart';
import 'package:wall/util/http_util.dart';
import 'package:wall/util/navigator_util.dart';
import 'package:wall/widget/common/button/my_text_btn.dart';
import 'package:wall/widget/common/dialog/base_dialog.dart';

class SystemExitDialog extends StatefulWidget {
  const SystemExitDialog({
    Key? key,
  }) : super(key: key);

  @override
  _ExitDialog createState() => _ExitDialog();
}

class _ExitDialog extends State<SystemExitDialog> {
  @override
  Widget build(BuildContext context) {
    // return BaseDialog(title: '123', rightBtnItem: MyTextButton(text: const Text('确认',style: TextStyle(color: Colors.orange),), enabled:
    // true, onPressed: ()=>NavigatorUtils.goBack(context),), child: Container(child: MyTextButton(text: const Text('确认',style: TextStyle(color: Colors.orange),), enabled:
    // true, onPressed: ()=>NavigatorUtils.goBack(context),)));
    return BaseDialog(
        title: "提示",
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text("您确定要退出登录吗？", style: TextStyle(fontSize: 16.0)),
        ),
        showCancel: false,
        rightBtnItem: MyTextButton(
          text: const Text('确认'),
          enabled: true,
          onPressed: () async {
            Util.showDefaultLoading(context);

            if (Application.getDeviceId != null) {
              DeviceApi.removeDeviceInfo(Application.getAccountId, Application.getDeviceId);
            }
            Application.setLocalAccountToken(null);

            Application.setAccount(null);
            Application.setAccountId(null);

            await SpUtil.clear();
            // MessageUtil.close();

            // Provider.of<MsgProvider>(context, listen: false).clear();

            httpUtil.clearAuthToken();
            httpUtil2.clearAuthToken();
            NavigatorUtils.goBack(context);
            NavigatorUtils.push(context, LoginRouter.loginIndex, clearStack: true);
          },
        ));
  }
}
