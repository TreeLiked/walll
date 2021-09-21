import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:wall/constant/gap_constant.dart';
import 'package:wall/model/biz/login/register_temp.dart';
import 'package:wall/util/navigator_util.dart';
import 'package:wall/util/str_util.dart';
import 'package:wall/util/theme_util.dart';
import 'package:wall/util/toast_util.dart';
import 'package:wall/widget/common/my_app_bar.dart';

class RegisterAccSetPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterAccSetPageState();
  }
}

class _RegisterAccSetPageState extends State<RegisterAccSetPage> {

  final TextEditingController _nickController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();

  File? _avatarFile;

  bool _canGoNext = false;

  @override
  void initState() {
    super.initState();
    _nickController.addListener(() {
      String nick = _nickController.text;
      bool go = true;
      if (nick.isEmpty || nick.length > 16) {
        go = false;
      }
      if (_avatarFile == null) {
        go = false;
      }
      setState(() {
        _canGoNext = go;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = ThemeUtil.isDark(context);
    return Scaffold(
        appBar: const MyAppBar(
          isBack: true,
          centerTitle: "基本信息",
        ),
        body: KeyboardActions(
          child: _buildBody(),
          config: KeyboardActionsConfig(keyboardActionsPlatform: KeyboardActionsPlatform.IOS, actions: [
          ]
          ),
        ));
  }

  _goChoiceAvatar() async {
    bool has = await PermissionUtil.checkAndRequestPhotos(context);
    if (has) {
      var image = await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 80);
      if (image != null) {
        final cropKey = GlobalKey<CropState>();
        File file = await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ImageCropContainer(cropKey: cropKey, file: File(image.path))));
        if (file != null) {
          this._avatarFile?.delete();
          setState(() {
            this._avatarFile = file;
            if (!StrUtil.isEmpty(_nickController.text)) {
              this._canGoNext = true;
            }
          });
          // Utils.showDefaultLoading(context);
          // String resultUrl =
          //     await OssUtil.uploadImage(file.path, file, toTweet: false);
          // if (resultUrl != "-1") {
          //   Result r = await MemberApi.modAccount(
          //       AccountEditParam(AccountEditParam.AVATAR, resultUrl));
          //   if (r != null && r.isSuccess) {
          //     setState(() {
          //       provider.account.avatarUrl = resultUrl;
          //     });
          //   } else {
          //     ToastUtil.showToast(context, '上传失败，请稍候重试');
          //   }
          // } else {
          //   ToastUtil.showToast(context, '上传失败，请稍候重试');
          // }
          // Navigator.pop(context);
        }
        // file?.delete();
      }
    }
  }

  _buildBody() {
    bool isDark = ThemeUtils.isDark(context);
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Gaps.vGap16,
          Gaps.vGap16,
          Container(
            alignment: Alignment.center,
            child: _avatarFile == null
                ? GestureDetector(
                    onTap: _goChoiceAvatar,
                    child: Container(
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(color: Color(0xffD7D6D9), shape: BoxShape.circle),
                        child: LoadAssetImage(
                          "profile_sel",
                          format: 'png',
                          width: SizeConstant.TWEET_PROFILE_SIZE - 10,
                          fit: BoxFit.cover,
                          color: isDark ? Colors.black54 : Colors.white,
                        )))
                : GestureDetector(
                    onTap: _goChoiceAvatar,
                    child: ClipOval(
                        child: Image.file(
                      _avatarFile,
                      width: SizeConstant.TWEET_PROFILE_SIZE * 1.5,
                      height: SizeConstant.TWEET_PROFILE_SIZE * 1.5,
                      fit: BoxFit.cover,
                      repeat: ImageRepeat.noRepeat,
                    ))),
          ),
          Container(
            decoration: BoxDecoration(
                color: !isDark ? Color(0xfff7f8f8) : Colours.dark_bg_color_darker,
                borderRadius: BorderRadius.circular(8.0)),
            // padding: const EdgeInsets.only(left: 20),
            margin: const EdgeInsets.only(top: 25),
            child: Row(
              children: <Widget>[
                Gaps.vGap10,
                Expanded(
                  child: MyTextField(
                    focusNode: _nodeText1,
                    config: Utils.getKeyboardActionsConfig(context, [
                      _nodeText1,
                    ]),
                    bgColor: Colors.transparent,
                    controller: _nickController,
                    maxLength: 16,
                    keyboardType: TextInputType.text,
                    hintText: "请输入昵称(16个字符以内)",
                  ),
                )
              ],
            ),
          ),
          Gaps.vGap12,
          Container(
            width: double.infinity,
            // padding: const EdgeInsets.symmetric(horizontal: 5.0),
//            color: _canGoNext ? Colors.amber : Color(0xffD7D6D9),
            margin: const EdgeInsets.only(top: 15),
            child: MyFlatButton('下一步', Colors.white,
                // disabledColor: !isDark ? Color(0xffD7D6D9) : Colours.dark_bg_color_darker,
                disabled: !_canGoNext,
                verticalPadding: 10.0,
                fillColor:
                    _canGoNext ? Colors.amber : (!isDark ? Color(0xffD7D6D9) : Colours.dark_bg_color_darker),
                // child: Text('下一步', style: TextStyle(color: Colors.white)),
                // padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                onTap: _canGoNext ? _chooseOrg : null),
          ),
          Gaps.vGap15,
          Gaps.line,
          Gaps.vGap16,
          Text('请选择头像并起一个独特的昵称叭～', maxLines: 5, softWrap: true, style: TextStyles.textGray14)
        ],
      ),
    );
  }

  _chooseOrg() async {
    String nick = _nickController.text;
    if (nick == null || nick == "") {
      ToastUtil.showToast(context, '请输入昵称');
      return;
    }
    if (nick.trim().length == 0) {
      ToastUtil.showToast(context, '昵称不能全部为空');
      return;
    }
    // checkNick
    Utils.showDefaultLoadingWithBounds(context);
    MemberApi.checkNickRepeat(nick.trim()).then((res) async {
      if (!res.isSuccess) {
        NavigatorUtils.goBack(context);
        ToastUtil.showToast(context, '昵称重复了，换一个试试吧');
      } else {
        RegTemp.nick = nick;
        String url =
            await OssUtil.uploadImage(_avatarFile.path, _avatarFile.readAsBytesSync(), OssUtil.DEST_AVATAR);
        NavigatorUtils.goBack(context);
        if (url != "-1") {
          RegTemp.regTemp.avatarUrl = url;
          NavigatorUtils.push(context, LoginRouter.loginOrgPage);
        } else {
          ToastUtil.showToast(context, '服务错误，请稍后重试');
        }
      }
    });
  }
}
