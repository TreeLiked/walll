import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wall/api/member_api.dart';
import 'package:wall/model/biz/account/account_edit_param.dart';
import 'package:wall/model/response/result.dart';
import 'package:wall/util/common_util.dart';
import 'package:wall/util/oss_util.dart';
import 'package:wall/util/perm_util.dart';
import 'package:wall/util/toast_util.dart';

class AccountProfileUtil {
  AccountProfileUtil._();

  static Future<String?> updateAvatar(BuildContext context) async {
    bool hasP = await PermissionUtil.checkAndRequestPhotos(context);
    if (!hasP) {
      ToastUtil.showToast(context, '未获取相册权限');
      return null;
    }
    XFile? _image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (_image == null) {
      return null;
    }
    File? file = await ImageCropper.cropImage(
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
    if (file == null) {
      return null;
    }
    Util.showDefaultLoadingWithBounds(context, text: '正在更新');
    String? resultUrl = await OssUtil.uploadImage(file.path, file.readAsBytesSync(), OssUtil.destAvatar);
    if (resultUrl == null) {
      ToastUtil.showToast(context, '头像上传失败');
      Navigator.pop(context);
      return null;
    }
    Result r = await MemberApi.modAccount(AccountEditParam(AccountEditKey.avatar, resultUrl));
    if (!r.isSuccess) {
      ToastUtil.showToast(context, '头像更新失败');
      Navigator.pop(context);
      return null;
    }
    Navigator.pop(context);
    return resultUrl;
  }

  static Future<void> updateProfileItem(BuildContext context, AccountEditParam param, final callback,
      {bool autoLoading = true}) async {
    if (autoLoading) {
      Util.showDefaultLoadingWithBounds(context, text: "正在更新");
    }
    Result r = await MemberApi.modAccount(param);
    if (autoLoading) {
      Navigator.pop(context);
    }
    if (r.isSuccess) {
      callback(true);
    } else {
      if (param.key == AccountEditKey.nick) {
        ToastUtil.showToast(context, '昵称重复，换一个试试吧');
      } else {
        ToastUtil.showToast(context, '更新失败，请稍候重试');
      }
    }
  }
}
