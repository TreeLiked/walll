import 'dart:async';

import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' as prefix2;
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:provider/provider.dart';
import 'package:wall/api/api_category.dart';
import 'package:wall/api/invite_api.dart';
import 'package:wall/api/member_api.dart';
import 'package:wall/api/university_api.dart';
import 'package:wall/config/routes/login_router.dart';
import 'package:wall/config/routes/routes.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/constant/gap_constant.dart';
import 'package:wall/constant/result_code.dart';
import 'package:wall/constant/shared_constant.dart';
import 'package:wall/constant/url_constant.dart';
import 'package:wall/model/biz/account/account.dart';
import 'package:wall/model/biz/login/register_temp.dart';
import 'package:wall/model/biz/org/university.dart';
import 'package:wall/model/biz/version/pub_v.dart';
import 'package:wall/model/response/result.dart';
import 'package:wall/provider/account_local_provider.dart';
import 'package:wall/provider/theme_provider.dart';
import 'package:wall/util/common_util.dart';
import 'package:wall/util/http_util.dart';
import 'package:wall/util/navigator_util.dart';
import 'package:wall/util/str_util.dart';
import 'package:wall/util/theme_util.dart';
import 'package:wall/util/toast_util.dart';
import 'package:wall/util/version_util.dart';
import 'package:wall/widget/common/button/long_flat_btn.dart';
import 'package:wall/widget/common/my_text_field.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../../application.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _SMSLoginPageState createState() => _SMSLoginPageState();
}

class _SMSLoginPageState extends State<LoginPage> {
  static const String _tag = "_SMSLoginPageState";

  TextEditingController _phoneController = TextEditingController();
  TextEditingController _vCodeController = TextEditingController();
  TextEditingController _iCodeController = TextEditingController();

  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  final FocusNode _nodeText3 = FocusNode();

  bool _canGetCode = false;
  bool _codeWaiting = false;

  bool _showCodeInput = false;
  bool _showInvitationCodeInput = false;

  /// 倒计时秒数
  final int second = 90;

  /// 当前秒数
  int? s;
  StreamSubscription? _subscription;

  bool isDark = false;

  @override
  void initState() {
    super.initState();
    isDark = false;

    // 登录页面也检查更新
    VersionUtils.checkUpdate().then((res) => VersionUtils.displayUpdateDialog(res, slient: true));

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await SpUtil.getInstance();
      Provider.of<ThemeProvider>(context, listen: false).syncTheme();
    });
    _phoneController.addListener(_verifyPhone);
  }

  void _verifyPhone() {
    if (!_codeWaiting) {
      String phone = _phoneController.text;
      bool isCodeClick = true;
      if (phone.isEmpty || phone.length < 11) {
        isCodeClick = false;
      }
      setState(() {
        _canGetCode = isCodeClick;
      });
    }
  }

  void _verifyCode(String val) {
    String phone = _phoneController.text;
    String vCode = _vCodeController.text;
    if (phone.isEmpty || phone.length < 11 || vCode.isEmpty || vCode.length != 6) {
      return;
    }
    _login();
  }

  void _verifyInvitationCode(String val) async {
    String phone = _phoneController.text;
    String vCode = _vCodeController.text;
    String iCode = _iCodeController.text;
    if (phone.isEmpty ||
        phone.length < 11 ||
        iCode.isEmpty ||
        iCode.length != 6 ||
        vCode.isEmpty ||
        vCode.length != 6) {
      return;
    }
    await InviteAPI.checkCodeValid(iCode).then((res) {
      if (res.isSuccess) {
        RegTemp.invitationCode = iCode;
        _login();
      } else {
        ToastUtil.showToast(context, '无效的邀请码');
      }
    });
  }

  void _login() async {
    Util.showDefaultLoadingWithBounds(context, text: '正在验证');

    Result r = await MemberApi.checkVerificationCode(_phoneController.text, _vCodeController.text);
    if (!r.isSuccess) {
      NavigatorUtils.goBack(context);
      ToastUtil.showToast(context, '验证码不正确');
      return;
    }
    Result res = await MemberApi.login(_phoneController.text);

    if (res.isSuccess) {
      // 已经存在账户，直接登录
      String token = res.data ?? res.message;
      // 设置token
      Application.setLocalAccountToken(token);
      httpUtil.updateAuthToken(token);
      httpUtil2.updateAuthToken(token);
      await SpUtil.putString(SharedCst.localAccountToken, token);

      // 查询账户信息
      Account? acc = await MemberApi.getMyAccount(token);
      if (acc == null) {
        NavigatorUtils.goBack(context);
        ToastUtil.showToast(context, '数据错误，请退出程序重试');
        return;
      }
      // 绑定账户信息到本地账户数据提供器
      AccountLocalProvider accountLocalProvider = Provider.of<AccountLocalProvider>(context, listen: false);
      accountLocalProvider.setAccount(acc);
      LogUtil.v(accountLocalProvider.account!.toJson(), tag: _tag);
      Application.setAccount(acc);
      Application.setAccountId(acc.id);

      // 获取用户所在的大学信息
      University? university = await UniversityApi.queryUnis(token);
      if (university == null) {
        // 错误，有账户无组织
        ToastUtil.showToast(context, '数据错误');
        return;
      } else {
        // 验证成功，写入用户相关信息到本地
        SpUtil.putInt(SharedCst.orgId, university.id!);
        SpUtil.putString(SharedCst.orgName, university.name!);
        Application.setOrgName(university.name!);
        Application.setOrgId(university.id!);
      }
      _subscription?.cancel();
      // 跳转到首页
      NavigatorUtils.push(context, Routes.splash, clearStack: true);
    } else {
      if (res.code == ResultCode.invalidPhone) {
        NavigatorUtils.goBack(context);
        ToastUtil.showToast(context, '错误的手机号，非法请求');
        return;
      }
      if (res.code == ResultCode.unRegisteredPhone) {
        // 未注册流程
        NavigatorUtils.goBack(context);
        Result r = await InviteAPI.checkIsInInvitation();
        if (r.isSuccess && StrUtil.isEmpty(RegTemp.invitationCode)) {
          // 开启内测
          setState(() {
            _showInvitationCodeInput = true;
          });
          return;
        }
        RegTemp.phone = _phoneController.text;
        RegTemp.invitationCode = _iCodeController.text;
        // 跳转到个人信息页面
        NavigatorUtils.push(context, LoginRouter.registerAccSetPage);
      } else {
        NavigatorUtils.goBack(context);
        if (StrUtil.isEmpty(res.message)) {
          ToastUtil.showServiceExpToast(context);
        } else {
          ToastUtil.showToast(context, res.message!);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    isDark = ThemeUtil.isDark(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
          padding: EdgeInsets.only(top: prefix2.ScreenUtil().statusBarHeight + 20),
          // child: defaultTargetPlatform == TargetPlatform.iOS
          // ? KeyboardActions(
          //     child: _buildBody(),
          //     config: KeyboardActionsConfig(actions: []),
          //   )
          // :
          child: SingleChildScrollView(
            child: _buildBody(),
          )),
    );
  }

  _buildBody() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Container(
          //   alignment: Alignment.centerLeft,
          //   child: TextLiquidFill(
          //     text: '欢迎加入WALL',
          //     boxHeight: 60,
          //     boxWidth: 180,
          //     textAlign: TextAlign.justify,
          //     waveColor: const Color(0xFF4facfe),
          //     boxBackgroundColor: isDark ? Colours.darkScaffoldColor : Colours.lightScaffoldColor,
          //     textStyle: TextStyle(
          //         fontSize: 23.0,
          //         fontWeight: FontWeight.bold,
          //         foreground: Paint()
          //           ..shader = const LinearGradient(
          //                   begin: Alignment.topLeft,
          //                   end: Alignment.bottomRight,
          //                   colors: [Color(0xFF4facfe), Color(0xFF00f2fe)])
          //               .createShader(const Rect.fromLTWH(0, 0, 207, 23))),
          //   ),
          // ),
          ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  colors: <Color>[Color(0xFF4facfe), Color(0xFF00f2fe)],
                  tileMode: TileMode.mirror,
                ).createShader(bounds);
              },
              blendMode: BlendMode.srcIn,
              child: Padding(
                padding: const EdgeInsets.only(top: 38.0),
                child: DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 23.0,
                    fontWeight: FontWeight.bold,
                    // color: Colours.emphasizeFontColor,
                    // foreground: Paint()
                    //   ..shader = const LinearGradient(
                    //           begin: Alignment.topLeft,
                    //           end: Alignment.bottomRight,
                    //           colors: [Color(0xFF4facfe), Color(0xFF00f2fe)])
                    //       .createShader(const Rect.fromLTWH(0, 0, 207, 23))
                  ),
                  child: AnimatedTextKit(isRepeatingAnimation: true, totalRepeatCount: 2, animatedTexts: [
                    WavyAnimatedText('登录后即可加入WALL', speed: const Duration(milliseconds: 350)),
                  ]),
                ),
              )),

          // Text("登录后即可加入WALL",
          //     style: TextStyle(
          //         fontSize: 23.0,
          //         fontWeight: FontWeight.bold,
          //         foreground: Paint()
          //           ..shader = const LinearGradient(
          //                   begin: Alignment.topLeft,
          //                   end: Alignment.bottomRight,
          //                   colors: [Color(0xFF4facfe), Color(0xFF00f2fe)])
          //               .createShader(const Rect.fromLTWH(0, 0, 207, 23)))),
          Gaps.vGap5,
          _renderSubBody(),
          Gaps.vGap20,
          Container(
            decoration: BoxDecoration(
                color: isDark ? Colours.borderColorFirstDark : Colours.borderColorFirst,
                borderRadius: BorderRadius.circular(6.0)),
            child: Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  margin: const EdgeInsets.only(right: 10),
                  child: const Text('+ 86'),
                ),
                Gaps.vLine,
                Expanded(
                  child: MyTextField(
                    focusNode: _nodeText1,
                    controller: _phoneController,
                    maxLength: 11,
                    keyboardType: TextInputType.phone,
                    hintText: "请输入手机号",
                  ),
                )
              ],
            ),
          ),
          _showCodeInput
              ? Container(
                  decoration: BoxDecoration(
                      color: isDark ? Colours.borderColorFirstDark : Colours.borderColorFirst,
                      borderRadius: BorderRadius.circular(6.0)),
                  margin: const EdgeInsets.only(top: 15),
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        margin: const EdgeInsets.only(right: 10),
                        child: const Text('验证码'),
                      ),
                      Gaps.vLine,
                      Expanded(
                        child: MyTextField(
                          focusNode: _nodeText2,
                          controller: _vCodeController,
                          maxLength: 6,
                          keyboardType: TextInputType.phone,
                          hintText: "请输入验证码",
                          onChange: _verifyCode,
                        ),
                      )
                    ],
                  ),
                )
              : Gaps.empty,

          _showInvitationCodeInput
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _renderHit('应用内测中，请输入邀请码', color: Colors.lightGreen),
                    Container(
                        decoration: BoxDecoration(
                            color: isDark ? Colours.borderColorFirstDark : Colours.borderColorFirst,
                            borderRadius: BorderRadius.circular(6.0)),
                        margin: const EdgeInsets.only(top: 15),
                        child: Row(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              margin: const EdgeInsets.only(right: 10),
                              child: const Text('邀请码'),
                            ),
                            Gaps.vLine,
                            Expanded(
                              child: MyTextField(
                                focusNode: _nodeText3,
                                controller: _iCodeController,
                                maxLength: 6,
                                keyboardType: TextInputType.text,
                                hintText: "请输入邀请码",
                                onChange: _verifyInvitationCode,
                              ),
                            )
                          ],
                        ))
                  ],
                )
              : Gaps.empty,
          _renderHit('未注册的手机号通过验证后将自动注册', color: Colours.secondaryFontColor),
          Gaps.vGap30,
          _renderGetCodeLine(),
          Gaps.vGap30,
          // _renderOtherLine(),
        ],
      ),
    );
  }

  _renderSubBody() {
    return Container(
        margin: const EdgeInsets.only(top: 15),
        child: RichText(
          softWrap: true,
          maxLines: 8,
          text: TextSpan(style: const TextStyle(fontSize: 14.5), children: [
            const TextSpan(text: "登录即表示同意 ", style: TextStyle(color: Colours.normalFontColor)),
            TextSpan(
                text: "Wall服务协议",
                style: const TextStyle(color: Colours.textLinkColor, decoration: TextDecoration.underline),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => NavigatorUtils.goWebViewPage(context, "Wall服务协议", UrlCst.agreement)),
          ]),
        ));
  }

  _renderHit(String text, {Color? color}) {
    return Container(
        margin: const EdgeInsets.only(top: 15),
        child: Text(text, style: TextStyle(color: color, fontSize: 14.5)));
  }

  _renderGetCodeLine() {
    return LongFlatButton(
      text: Text(
        !_codeWaiting ? '获取短信验证码' : '重新获取 $s秒',
        style: const TextStyle(color: Colors.white),
      ),
      enabled: _canGetCode,
      onPressed: _codeWaiting
          ? null
          : () async {
              String phone = _phoneController.text;
              if (phone.isEmpty || phone.length < 11) {
                ToastUtil.showToast(context, '手机号格式不正确');
                return;
              }
              Util.showDefaultLoadingWithBounds(context);
              Result res = await MemberApi.sendPhoneVerificationCode(_phoneController.text);
              NavigatorUtils.goBack(context);

              if (!res.isSuccess) {
                ToastUtil.showToast(context, res.message);
                return;
              }
              ToastUtil.showToast(context, '发送成功');
              _nodeText1.unfocus();
              setState(() {
                s = second;
                _showCodeInput = true;
                _canGetCode = false;
                _codeWaiting = true;
              });
              _nodeText2.requestFocus();
              _subscription = Stream.periodic(const Duration(seconds: 1), (int i) {
                setState(() {
                  s = second - i - 1;
                  if (s! < 1) {
                    _canGetCode = true;
                    _codeWaiting = false;
                  }
                });
              }).take(second).listen((event) {});
            },
    );
  }

// _renderOtherLine() {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.end,
//     children: <Widget>[
//       RichText(
//         softWrap: true,
//         maxLines: 1,
//         text: TextSpan(children: [
//           TextSpan(
//               text: "其他方式登录",
//               style: TextStyles.textClickable,
//               recognizer: TapGestureRecognizer()
//                 ..onTap = () {
//                   ToastUtil.showToast(context, '社会化登录暂未开放');
//                 }),
//         ]),
//       )
//     ],
//   );
// }
}
