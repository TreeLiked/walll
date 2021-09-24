import 'dart:async';

import 'package:flustars/flustars.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:wall/api/member_api.dart';
import 'package:wall/api/university_api.dart';
import 'package:wall/application.dart';
import 'package:wall/config/routes/login_router.dart';
import 'package:wall/config/routes/routes.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/constant/gap_constant.dart';
import 'package:wall/constant/result_code.dart';
import 'package:wall/constant/shared_constant.dart';
import 'package:wall/model/biz/account/account.dart';
import 'package:wall/model/biz/login/register_temp.dart';
import 'package:wall/model/biz/org/university.dart';
import 'package:wall/model/response/result.dart';
import 'package:wall/provider/account_local_provider.dart';
import 'package:wall/util/common_util.dart';
import 'package:wall/util/http_util.dart';
import 'package:wall/util/navigator_util.dart';
import 'package:wall/util/theme_util.dart';
import 'package:wall/util/toast_util.dart';
import 'package:wall/widget/common/button/long_flat_btn.dart';
import 'package:wall/widget/common/button/my_text_btn.dart';
import 'package:wall/widget/common/my_app_bar.dart';

class RegisterOrgSelPage extends StatefulWidget {
  const RegisterOrgSelPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RegisterOrgSelPageState();
  }
}

class _RegisterOrgSelPageState extends State<RegisterOrgSelPage> {
  static const String _tag = "_OrgInfoCPageState";

  List<University> filterList = [];

  late TextEditingController _controller;
  late Future<List<University>> _queryUnTask;

  bool _haveChoice = false;
  int? _cId;
  String _cName = "";

  Duration durationTime = const Duration(seconds: 1);

  // 防抖函数
  Timer? timer;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();
    _queryUnTask = queryUnis("");
  }

  Future<List<University>> queryUnis(String name) async {
    return await UniversityApi.blurQueryUnis(name.trim());
  }

  _finishAll() async {
    Util.showDefaultLoadingWithBounds(context, text: '正在注册');
    RegTemp.orgId = _cId;
    Result res = await MemberApi.register(
        RegTemp.phone!, RegTemp.nick!, RegTemp.avatarUrl!, RegTemp.orgId!, RegTemp.invitationCode!);

    if (res.isSuccess) {
      String token = res.oriData;
      await prefix0.SpUtil.putString(SharedCst.localAccountToken, token);
      await prefix0.SpUtil.putInt(SharedCst.orgId, _cId!);
      await prefix0.SpUtil.putString(SharedCst.orgName, _cName);
      Application.setLocalAccountToken(token);
      httpUtil.updateAuthToken(token);
      httpUtil2.updateAuthToken(token);

      Account? acc = await MemberApi.getMyAccount(token);
      if (acc == null) {
        ToastUtil.showServiceExpToast(context);
        NavigatorUtils.goBack(context);
        return;
      }
      AccountLocalProvider accountLocalProvider = Provider.of<AccountLocalProvider>(context, listen: false);
      accountLocalProvider.setAccount(acc);
      Application.setAccount(acc);
      Application.setAccountId(acc.id);
      Application.setOrgId(_cId!);
      Application.setOrgName(_cName);
      NavigatorUtils.goBack(context);
      NavigatorUtils.push(context, Routes.splash, clearStack: true);
    } else {
      NavigatorUtils.goBack(context);
      prefix0.LogUtil.e(res.toString(), tag: _tag);

      if (res.code == ResultCode.registeredPhone) {
        ToastUtil.showToast(context, '该手机号已被注册，请登录');
        await Future.delayed(durationTime).then((_) {
          NavigatorUtils.push(context, LoginRouter.loginIndex, clearStack: true);
        });
        return;
      }
      if (res.code == ResultCode.registerError) {
        ToastUtil.showToast(context, '注册失败');
        NavigatorUtils.push(context, LoginRouter.loginIndex, clearStack: true);
        return;
      }

      if (res.code == ResultCode.invalidInvitationCode) {
        ToastUtil.showToast(context, '邀请码无效');
        NavigatorUtils.push(context, LoginRouter.loginIndex, clearStack: true);
        return;
      }

      if (res.code == ResultCode.nickExisted) {
        ToastUtil.showToast(context, '昵称已存在');
        NavigatorUtils.push(context, LoginRouter.loginIndex, clearStack: true);
        return;
      }
      ToastUtil.showToast(context, res.message);
      NavigatorUtils.push(context, LoginRouter.loginIndex, clearStack: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
          centerTitle: _haveChoice ? '确认选择' : '选择组织',
          isBack: !_haveChoice,
        ),
        body: !_haveChoice
            ? Column(
                children: <Widget>[
                  Gaps.vGap10,
                  Container(
                      padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.0),
                        color: ThemeUtil.isDark(context) ? Colours.borderColorFirstDark : Colours.borderColorFirst,
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: TextField(
                          controller: _controller,
                          textInputAction: TextInputAction.search,
                          onSubmitted: (_) async {
                            setState(() {
                              _queryUnTask = queryUnis(_controller.text);
                            });
                          },
                          onChanged: (val) async {
                            setState(() {
                              timer?.cancel();
                              timer = Timer(durationTime, () {
                                setState(() {
                                  _queryUnTask = queryUnis(val);
                                });
                              });
                            });
                          },
                          decoration: const InputDecoration(
                              hintText: '输入大学以搜索，英文缩写也可以哦',
                              hintStyle: TextStyle(color: Colours.secondaryFontColor, fontSize: 16.0),
                              prefixIcon: Icon(Icons.search, color: Colors.grey),
                              border: InputBorder.none),
                          maxLines: 1)),
                  Expanded(
                      child: Container(
                          margin: const EdgeInsets.all(0),
                          padding: const EdgeInsets.all(0),
                          child: FutureBuilder<List<University>>(
                              builder: (context, AsyncSnapshot<List<University>> async) {
                                //在这里根据快照的状态，返回相应的widget
                                if (async.connectionState == ConnectionState.active ||
                                    async.connectionState == ConnectionState.waiting) {
                                  return Container(
                                      margin: const EdgeInsets.only(bottom: 500),
                                      child: const SpinKitThreeBounce(color: Colors.lightGreen, size: 18));
                                }
                                if (async.connectionState == ConnectionState.done) {
                                  if (async.hasError) {
                                    return Center(child: Text("${async.error}"));
                                  } else if (async.hasData) {
                                    List<University> list = async.data!;
                                    if (list.isEmpty) {
                                      return const Padding(
                                          padding: EdgeInsets.only(top: 37),
                                          child: Text('未检索到结果',
                                              style: TextStyle(color: Colours.secondaryFontColor)));
                                    }
                                    return ListView.builder(
                                        itemCount: list.length,
                                        itemBuilder: (context, index) {
                                          String enAbbr = list[index].enAbbr ?? "";
                                          return ListTile(
                                              onTap: () {
                                                University un = list[index];
                                                if (un.status != 1) {
                                                  if (un.status == 0) {
                                                    ToastUtil.showToast(context, "抱歉，您选择的学校暂时未开放");
                                                  }
                                                  if (un.status == 2) {
                                                    ToastUtil.showToast(context, "抱歉，您的学校正在灰度测试中，感谢您的支持");
                                                  }
                                                  return;
                                                }
                                                setState(() {
                                                  _haveChoice = true;
                                                  _cName = un.name!;
                                                  _cId = un.id;
                                                });
                                              },
                                              title: Text(list[index].name!,
                                                  style: const TextStyle(fontSize: 15.5)),
                                              subtitle: enAbbr == ""
                                                  ? null
                                                  : Text(enAbbr.toUpperCase(),
                                                      style: const TextStyle(fontSize: 14)));
                                        });
                                  }
                                }
                                return Gaps.empty;
                              },
                              future: _queryUnTask)))
                ],
              )
            : Container(
                margin: const EdgeInsets.only(top: 50),
                width: double.infinity,
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Text(_cName, style: const TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold)),
                    Gaps.vGap30,
                    const Text('提示：选择确认后，将不支持更改',
                        style: TextStyle(
                            color: Colours.secondaryFontColor, fontSize: 16.0, fontWeight: FontWeight.w400)),
                    Gaps.vGap50,
                    SizedBox(
                        width: 250,
                        child: MyTextButton(
                          enabled: true,
                          text: const Text('重新选择', style: TextStyle(fontSize: 17)),
                          onPressed: () {
                            setState(() {
                              _controller.text = "";
                              _queryUnTask = queryUnis("");
                              _haveChoice = false;
                            });
                          },
                        )),
                    Gaps.vGap20,
                    SizedBox(
                        width: 250,
                        child: LongFlatButton(
                            enabled: true,
                            text: const Text('我已确认', style: TextStyle(color: Colors.white, fontSize: 17)),
                            onPressed: () => _finishAll()))
                  ],
                )));
  }
}
