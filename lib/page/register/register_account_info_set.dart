import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:wall/api/member_api.dart';
import 'package:wall/config/routes/login_router.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/constant/gap_constant.dart';
import 'package:wall/model/biz/login/register_temp.dart';
import 'package:wall/util/asset_util.dart';
import 'package:wall/util/common_util.dart';
import 'package:wall/util/navigator_util.dart';
import 'package:wall/util/oss_util.dart';
import 'package:wall/util/perm_util.dart';
import 'package:wall/util/str_util.dart';
import 'package:wall/util/theme_util.dart';
import 'package:wall/util/toast_util.dart';
import 'package:wall/widget/common/button/long_flat_btn.dart';
import 'package:wall/widget/common/colorful_border.dart';
import 'package:wall/widget/common/my_app_bar.dart';
import 'package:wall/widget/common/my_text_field_with_shadow.dart';

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
          config: KeyboardActionsConfig(keyboardActionsPlatform: KeyboardActionsPlatform.IOS, actions: []),
        ));
  }

  _goChoiceAvatar() async {
    print('111-------------------');
    bool hasPer = await PermissionUtil.checkAndRequestPhotos(context);
    print('222-------------------$hasPer');

    if (!hasPer) {
      ToastUtil.showToast(context, "未获取相册权限");
      return;
    }
    XFile? _image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (_image == null) {
      return;
    }
    File? _croppedFile = await ImageCropper.cropImage(
        sourcePath: _image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        cropStyle: CropStyle.circle,
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: '编辑',
            toolbarColor: Colors.white,
            toolbarWidgetColor: Colors.black,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
            title: '编辑',
            hidesNavigationBar: true,
            aspectRatioPickerButtonHidden: true,
            doneButtonTitle: '完成',
            cancelButtonTitle: '取消',
            aspectRatioLockEnabled: true));
    if (_croppedFile == null) {
      return;
    }
    setState(() {
      _avatarFile = _croppedFile;
      if (!StrUtil.isEmpty(_nickController.text)) {
        _canGoNext = true;
      }
    });
  }

  _buildBody() {
    bool isDark = ThemeUtil.isDark(context);
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Gaps.vGap25,
          Container(
              alignment: Alignment.center,
              child: ColorfulBorderWidget(
                  child: GestureDetector(
                      onTap: _goChoiceAvatar,
                      child: Container(
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                              color: isDark ? Colours.darkScaffoldColor : Colours.lightScaffoldColor,
                              shape: BoxShape.circle),
                          child: _avatarFile == null
                              ? const LoadAssetSvg("crm/female_profile_default", width: 75)
                              : ClipOval(
                                  child: Image.file(_avatarFile!,
                                      width: 75,
                                      height: 75,
                                      fit: BoxFit.cover,
                                      repeat: ImageRepeat.noRepeat)))))),
          Container(
            decoration: BoxDecoration(
                // color: !isDark ? Color(0xfff7f8f8) : Colours.dark_bg_color_darker,
                borderRadius: BorderRadius.circular(8.0)),
            // padding: const EdgeInsets.only(left: 20),
            margin: const EdgeInsets.only(top: 25),
            child: Row(
              children: <Widget>[
                Gaps.vGap10,
                Expanded(
                  child: MyShadowTextField(
                    focusNode: _nodeText1,
                    // config: Utils.getKeyboardActionsConfig(context, [
                    //   _nodeText1,
                    // ]),
                    bgColor: Colors.transparent,
                    controller: _nickController,
                    maxLength: 16,
                    keyboardType: TextInputType.text,
                    hintText: "请输入昵称",
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
            child: LongFlatButton(
              text: const Text('下一步', style: TextStyle(color: Colors.white)),
              // disabledColor: !isDark ? Color(0xffD7D6D9) : Colours.dark_bg_color_darker,
              enabled: _canGoNext,
              onPressed: _chooseOrg,
            ),
          ),
          Gaps.vGap15,
          Gaps.line,
          Gaps.vGap16,
          const Text(
            '请输入昵称',
            maxLines: 5,
            softWrap: true,
            style: TextStyle(color: Colours.secondaryFontColor, fontSize: 15.0),
          )
        ],
      ),
    );
  }

  _chooseOrg() async {
    String nick = _nickController.text;
    if (nick == "") {
      ToastUtil.showToast(context, '请输入昵称');
      return;
    }
    if (nick.trim().isEmpty) {
      ToastUtil.showToast(context, '昵称不能为空');
      return;
    }
    // checkNick
    Util.showDefaultLoadingWithBounds(context);
    MemberApi.checkNickRepeat(nick.trim()).then((res) async {
      if (!res.isSuccess) {
        NavigatorUtils.goBack(context);
        ToastUtil.showToast(context, '昵称重复了，换一个试试吧');
      } else {
        RegTemp.nick = nick;
        String? url =
            await OssUtil.uploadImage(_avatarFile!.path, _avatarFile!.readAsBytesSync(), OssUtil.destAvatar);
        NavigatorUtils.goBack(context);
        if (url != null) {
          RegTemp.avatarUrl = url;
          NavigatorUtils.push(context, LoginRouter.registerOrgSetPage);
        } else {
          ToastUtil.showToast(context, '服务错误，请稍后重试');
        }
      }
    });
  }
}
