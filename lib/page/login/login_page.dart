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

  /// ???????????????
  final int second = 90;

  /// ????????????
  int? s;
  StreamSubscription? _subscription;

  bool isDark = false;

  @override
  void initState() {
    super.initState();
    isDark = false;

    // ???????????????????????????
    VersionUtils.checkUpdate().then((res) => VersionUtils.displayUpdateDialog(res, slient: true));

    // TODO ???????????????
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    Provider.of<ThemeProvider>(context, listen: false).setTheme(Themes.light);

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
        ToastUtil.showToast(context, '??????????????????');
      }
    });
  }

  void _login() async {
    Util.showDefaultLoadingWithBounds(context, text: '????????????');

    Result r = await MemberApi.checkVerificationCode(_phoneController.text, _vCodeController.text);
    if (!r.isSuccess) {
      NavigatorUtils.goBack(context);
      ToastUtil.showToast(context, '??????????????????');
      return;
    }
    Result res = await MemberApi.login(_phoneController.text);

    if (res.isSuccess) {
      // ?????????????????????????????????
      String token = res.data ?? res.message;
      // ??????token
      Application.setLocalAccountToken(token);
      httpUtil.updateAuthToken(token);
      httpUtil2.updateAuthToken(token);
      await SpUtil.putString(SharedCst.localAccountToken, token);

      // ??????????????????
      Account? acc = await MemberApi.getMyAccount(token);
      if (acc == null) {
        NavigatorUtils.goBack(context);
        ToastUtil.showToast(context, '????????????????????????????????????');
        return;
      }
      // ????????????????????????????????????????????????
      AccountLocalProvider accountLocalProvider = Provider.of<AccountLocalProvider>(context, listen: false);
      accountLocalProvider.setAccount(acc);
      LogUtil.v(accountLocalProvider.account!.toJson(), tag: _tag);
      Application.setAccount(acc);
      Application.setAccountId(acc.id);

      // ?????????????????????????????????
      University? university = await UniversityApi.queryUnis(token);
      if (university == null) {
        // ???????????????????????????
        ToastUtil.showToast(context, '????????????');
        return;
      } else {
        // ????????????????????????????????????????????????
        SpUtil.putInt(SharedCst.orgId, university.id!);
        SpUtil.putString(SharedCst.orgName, university.name!);
        Application.setOrgName(university.name!);
        Application.setOrgId(university.id!);
      }
      _subscription?.cancel();
      // ???????????????
      NavigatorUtils.push(context, Routes.splash, clearStack: true);
    } else {
      if (res.code == ResultCode.invalidPhone) {
        NavigatorUtils.goBack(context);
        ToastUtil.showToast(context, '?????????????????????????????????');
        return;
      }
      if (res.code == ResultCode.unRegisteredPhone) {
        // ???????????????
        NavigatorUtils.goBack(context);
        Result r = await InviteAPI.checkIsInInvitation();
        if (r.isSuccess && StrUtil.isEmpty(RegTemp.invitationCode)) {
          // ????????????
          setState(() {
            _showInvitationCodeInput = true;
          });
          return;
        }
        RegTemp.phone = _phoneController.text;
        RegTemp.invitationCode = _iCodeController.text;
        // ???????????????????????????
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
          //     text: '????????????WALL',
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
                return LinearGradient(
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
                    WavyAnimatedText('?????????????????????WALL', speed: const Duration(milliseconds: 350)),
                  ]),
                ),
              )),

          // Text("?????????????????????WALL",
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
                    hintText: "??????????????????",
                  ),
                )
              ],
            ),
          ),
          _showCodeInput
              ? Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        margin: const EdgeInsets.only(right: 10),
                        child: Text('?????????'),
                      ),
                      Gaps.vLine,
                      Expanded(
                        child: MyTextField(
                          focusNode: _nodeText2,
                          controller: _vCodeController,
                          maxLength: 6,
                          keyboardType: TextInputType.phone,
                          hintText: "??????????????????",
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
                    _renderHit('????????????????????????????????????', color: Colors.lightGreen),
                    Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: Row(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              margin: const EdgeInsets.only(right: 10),
                              child: Text('?????????'),
                            ),
                            Gaps.vLine,
                            Expanded(
                              child: MyTextField(
                                focusNode: _nodeText3,
                                controller: _iCodeController,
                                maxLength: 6,
                                keyboardType: TextInputType.text,
                                hintText: "??????????????????",
                                onChange: _verifyInvitationCode,
                              ),
                            )
                          ],
                        ))
                  ],
                )
              : Gaps.empty,
          _renderHit('???????????????????????????????????????????????????', color: Colours.secondaryFontColor),
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
            const TextSpan(text: "????????????????????? ", style: TextStyle(color: Colours.normalFontColor)),
            TextSpan(
                text: "Wall????????????",
                style: const TextStyle(color: Colours.textLinkColor, decoration: TextDecoration.underline),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => NavigatorUtils.goWebViewPage(context, "Wall????????????", UrlCst.agreement)),
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
        !_codeWaiting ? '?????????????????????' : '???????????? $s???',
        style: const TextStyle(color: Colors.white),
      ),
      enabled: _canGetCode,
      onPressed: _codeWaiting
          ? null
          : () async {
              String phone = _phoneController.text;
              if (phone.isEmpty || phone.length < 11) {
                ToastUtil.showToast(context, '????????????????????????');
                return;
              }
              Util.showDefaultLoadingWithBounds(context);
              Result res = await MemberApi.sendPhoneVerificationCode(_phoneController.text);
              NavigatorUtils.goBack(context);

              if (!res.isSuccess) {
                ToastUtil.showToast(context, res.message);
                return;
              }
              ToastUtil.showToast(context, '????????????');
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
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            color: _canGetCode
                ? Colors.amber
                : (!isDark ? Colours.borderColorSecond : Colours.borderColorFirstDark)),
        child: TextButton(
          child: Text(!_codeWaiting ? '?????????????????????' : '???????????? $s(s)', style: TextStyle(color: Colors.white)),
          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          // color: _canGetCode ? Colors.amber : null,
          // padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          // disabledColor: !isDark ? Color(0xffD7D6D9) : Colours.dark_bg_color_darker,

          onPressed: _codeWaiting
              ? null
              : () async {
                  String phone = _phoneController.text;
                  if (phone.isEmpty || phone.length < 11) {
                    ToastUtil.showToast(context, '????????????????????????');
                    return Future.value(false);
                  } else {
                    Util.showDefaultLoadingWithBounds(context);
                    Result res = await MemberApi.sendPhoneVerificationCode(_phoneController.text);
                    NavigatorUtils.goBack(context);

                    if (res.isSuccess) {
                      ToastUtil.showToast(context, '????????????');
                      _nodeText1.unfocus();
                      _nodeText2.requestFocus();
                      setState(() {
                        s = second;
                        this._showCodeInput = true;
                        this._canGetCode = false;
                        _codeWaiting = true;
                      });
                      _subscription = Stream.periodic(Duration(seconds: 1), (int i) {
                        setState(() {
                          s = second - i - 1;
                          if (s! < 1) {
                            _canGetCode = true;
                            _codeWaiting = false;
                          }
                        });
                      }).take(second).listen((event) {});

                      return Future.value(true);
                    } else {
                      ToastUtil.showToast(context, res.message);
                      return Future.value(false);
                    }
                  }
                },
        ));
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
//               text: "??????????????????",
//               style: TextStyles.textClickable,
//               recognizer: TapGestureRecognizer()
//                 ..onTap = () {
//                   ToastUtil.showToast(context, '???????????????????????????');
//                 }),
//         ]),
//       )
//     ],
//   );
// }
}
