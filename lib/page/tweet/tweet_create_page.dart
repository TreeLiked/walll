import 'dart:core';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wall/api/tweet_api.dart';
import 'package:wall/application.dart';
import 'package:wall/constant/app_constant.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/constant/gap_constant.dart';
import 'package:wall/model/biz/account/account.dart';
import 'package:wall/model/biz/common/media.dart';
import 'package:wall/model/biz/tweet/tweet.dart';
import 'package:wall/model/biz/tweet/tweet_account.dart';
import 'package:wall/model/biz/tweet/tweet_type.dart';
import 'package:wall/model/response/result.dart';
import 'package:wall/util/asset_util.dart';
import 'package:wall/util/bottom_sheet_util.dart';
import 'package:wall/util/coll_util.dart';
import 'package:wall/util/common_util.dart';
import 'package:wall/util/navigator_util.dart';
import 'package:wall/util/oss_util.dart';
import 'package:wall/util/perm_util.dart';
import 'package:wall/util/str_util.dart';
import 'package:wall/util/theme_util.dart';
import 'package:wall/util/toast_util.dart';
import 'package:wall/util/umeng_util.dart';
import 'package:wall/widget/common/button/long_flat_btn.dart';
import 'package:wall/widget/common/container/average_row.dart';

class TweetCreatePage extends StatefulWidget {
  const TweetCreatePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TweetCreatePageState();
  }
}

class _TweetCreatePageState extends State<TweetCreatePage> {
  static const String _tag = "_TweetCreatePageState";
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  // 开启回复
  bool _enableReply = true;

  // 是否匿名
  bool _anonymous = false;

  String _typeText = "选择标签";

  // 标签tag
  String? _typeName;

  // 是否禁用发布按钮
  bool _isPushBtnEnabled = false;
  bool _publishing = false;

  // 选中的图片
  List<XFile>? _imageFileList;

  final int _maxImageCount = 9;

  // 屏幕宽度
  double? sw;
  double spacing = 15;
  double? singleImageWidth;

  bool _isDark = false;

  void _updatePushBtnState() {
    int len = _controller.text.length;
    if (((len > 0 && len < AppCst.tweetCreateMaxStrLen) || CollUtil.isListNotEmpty(_imageFileList))) {
      if (StrUtil.notEmpty(_typeName)) {
        if (_isPushBtnEnabled == false) {
          setState(() {
            _isPushBtnEnabled = true;
          });
        }
      }
    } else {
      if (_isPushBtnEnabled == true) {
        setState(() {
          _isPushBtnEnabled = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    UMengUtil.userGoPage(UMengUtil.pageTweetIndexCreate);
  }

  @override
  Widget build(BuildContext context) {
    LogUtil.d("create page build", tag: _tag);

    _isDark = ThemeUtil.isDark(context);

    sw = Application.screenWidth!;

    singleImageWidth = (sw! - 10 - spacing * 3) / 3;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colours.getScaffoldColor(context),
          title: Text('发布动态',
              style:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colours.getEmphasizedTextColor(context))),
          centerTitle: true,
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Text("取消", style: TextStyle(color: Colours.getEmphasizedTextColor(context), fontSize: 15))),
          elevation: 0,
          toolbarOpacity: 0.8,
          actions: <Widget>[
            Container(
                height: 15.0,
                width: 69.0,
                margin: const EdgeInsets.symmetric(vertical: 11.0, horizontal: 7.0),
                child: LongFlatButton(
                  radius: 16.0,
                  text: const Text('发布', style: TextStyle(color: Colors.white, fontSize: 15.0)),
                  bgColor: _isPushBtnEnabled && !_publishing ? Colours.mainColor : Colours.secondaryFontColor,
                  // bgColor: Colors.red,
                  needGradient: false,
                  enabled: _isPushBtnEnabled && !_publishing,
                  onPressed: _isPushBtnEnabled && !_publishing
                      ? () {
                          _assembleAndPushSchoolTweet();
                        }
                      : () {
                          if (StrUtil.isEmpty(_controller.text) && CollUtil.isListEmpty(_imageFileList)) {
                            ToastUtil.showToast(context, "请输入内容或至少选择一张图片");
                            return;
                          }
                          ToastUtil.showToast(context, "正在上传内容，请稍后");
                        },
                ))
          ],
        ),
        body: Stack(fit: StackFit.expand, children: [
          SafeArea(
              bottom: true,
              child: SingleChildScrollView(
                  child: GestureDetector(
                      onTap: () => _hideKeyB(),
                      onPanDown: (_) => _hideKeyB(),
                      child: Container(
                          // color: ColorConstant.MAIN_BG,
                          margin: const EdgeInsets.only(bottom: 5.0, left: 5.0, right: 5.0),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(top: 5.0),
                              constraints: BoxConstraints(
                                maxHeight: Application.screenHeight! * 0.3,
                              ),
                              child: TextField(
                                keyboardAppearance: Theme.of(context).brightness,
                                controller: _controller,
                                focusNode: _focusNode,
                                cursorColor: Colors.blue,
                                maxLengthEnforced: true,
                                maxLength: AppCst.tweetCreateMaxStrLen,
                                keyboardType: TextInputType.multiline,
                                autocorrect: false,
                                maxLines: 4,
                                style: TextStyle(
                                    height: 1.4,
                                    fontSize: 15.5,
                                    color: Colours.getEmphasizedTextColor(context),
                                    letterSpacing: 1.1),
                                decoration: const InputDecoration(
                                    hintText: '发现新鲜事\n温馨提示：请勿发布广告、色情、政治等标签无关内容并遵守相关条律，维护良好交流环境',
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(fontSize: 13.5, color: Colors.grey),
                                    contentPadding: EdgeInsets.all(5)),
                                onChanged: (val) {
                                  _updatePushBtnState();
                                },
                              ),
                            ),
                            _renderImageWidgets(context),

                            _renderTweetExtraOpt(context)
                            // Container(
                            //   margin: EdgeInsets.only(
                            //       top: picWidgets.length < 4
                            //           ? tipMargin
                            //           : picWidgets.length < 7
                            //               ? tipMargin - singleImageWidth
                            //               : tipMargin - singleImageWidth * 2),
                            //   width: sw,
                            //   alignment: Alignment.bottomCenter,
                            //   child: Text('请勿发布广告、色情、政治等标签无关或违法内容\n否则您的账号会被永久封禁',
                            //       textAlign: TextAlign.center, style: TextStyles.textGray12, softWrap: true),
                            // ),
                          ])))))
        ]));
  }

  void _assembleAndPushSchoolTweet() async {
    if (_controller.text.length > AppCst.tweetCreateMaxStrLen) {
      ToastUtil.showToast(context, '内容超出最大字符限制');
      return;
    }
    if (_typeName == null) {
      ToastUtil.showToast(context, '请选择内容类型');
      return;
    }

    double totalSize = 0;
    if (CollUtil.isListNotEmpty(_imageFileList)) {
      Util.showDefaultLoadingWithBounds(context);
      for (int i = 0; i < _imageFileList!.length; i++) {
        Uint8List bd = await _imageFileList![i].readAsBytes();
        int byte = bd.lengthInBytes;
        double mb = byte / 1024 / 1024;
        totalSize += mb;
      }
      NavigatorUtils.goBack(context);
    }

    if (totalSize > AppCst.tweetCreateImageMaxSizeTotal) {
      ToastUtil.showToast(context, '图片过大');
      return;
    }

    _focusNode.unfocus();
    setState(() {
      _isPushBtnEnabled = false;
      _publishing = true;
    });
    BaseTweet _baseTweet = BaseTweet();
    _baseTweet.sentTime = DateTime.now();

    bool uploadError = false;
    if (CollUtil.isListNotEmpty(_imageFileList)) {
      Util.showDefaultLoadingWithBounds(context, text: '上传媒体');
      for (int i = 0; i < _imageFileList!.length; i++) {
        try {
          var imgData = await _imageFileList![i].readAsBytes();
          String? result = await OssUtil.uploadImage(_imageFileList![i].name, imgData, OssUtil.destTweet);
          if (result != null) {
            _baseTweet.medias ??= [];
            Media m = Media();
            m.module = Media.moduleTweet;
            m.name = _imageFileList![i].name;
            m.mediaType = Media.typeImage;
            m.url = result;
            m.index = i;
            _baseTweet.medias!.add(m);
          } else {
            uploadError = true;
            break;
          }
        } catch (exp) {
          uploadError = true;
          LogUtil.d("$exp", tag: _tag);
        } finally {
          LogUtil.d("第$i张图片上传完成", tag: _tag);
        }
      }
      Navigator.pop(context);
    }
    if (uploadError) {
      ToastUtil.showToast(context, '发布出错，请稍后重试');
      return;
    }
    Util.showDefaultLoadingWithBounds(context, text: '正在发布');
    _baseTweet.type = _typeName;
    _baseTweet.body = _controller.text;
    TweetAccount ta = TweetAccount();
    Account temp = Application.getAccount!;
    ta.id = temp.id ?? "";
    _baseTweet.account = ta;
    _baseTweet.enableReply = _enableReply;
    _baseTweet.anonymous = _anonymous;
    _baseTweet.orgId = Application.getOrgId;
    LogUtil.d("Tweet to push: ${_baseTweet.toJson()}", tag: _tag);

    Result pushRes = await TweetApi.pushTweet(_baseTweet);
    Navigator.of(context).pop();
    LogUtil.d("Tweet push result: ${pushRes.toJson()}", tag: _tag);
    if (pushRes.isSuccess) {
      NavigatorUtils.goBack(context);
    } else {
      ToastUtil.showToast(context, pushRes.message);
    }
    setState(() {
      _publishing = false;
    });
    _updatePushBtnState();
  }

  void _reverseAnonymous() {
    setState(() {
      _anonymous = !_anonymous;
    });
  }

  void _reverseEnableReply() {
    setState(() {
      _enableReply = !_enableReply;
    });
  }

  Future<void> loadAssets() async {
    try {
      List<XFile>? _fileList = await ImagePicker().pickMultiImage();
      if (_fileList == null) {
        return;
      }
      int addLen = _fileList.length;
      if (addLen > _maxImageCount ||
          (CollUtil.isListNotEmpty(_imageFileList) && (_imageFileList!.length + addLen) > _maxImageCount)) {
        ToastUtil.showToast(context, '最多只可以选择9张图片哦');
        return;
      }
      setState(() {
        _imageFileList ??= [];
        _imageFileList!.addAll(_fileList);
      });
    } on Exception catch (e) {
      LogUtil.d("$e", tag: _tag);
      ToastUtil.showToast(context, '系统错误');
      return;
    }
  }

  void pickImage(BuildContext context) async {
    bool hasP = await PermissionUtil.checkAndRequestPhotos(context, needCamera: true);
    if (!hasP) {
      return;
    }
    await loadAssets();
    _updatePushBtnState();
  }

  void _hideKeyB() {
    setState(() {
      _focusNode.unfocus();
    });
  }

  _getImageSelWidget(BuildContext context, int index) {
    return GestureDetector(
        onTap: () async {
          pickImage(context);
        },
        child: Container(
            // padding: const EdgeInsets.all(30),
            margin: EdgeInsets.only(right: index % 3 == 2 ? 0 : 10, bottom: 10),
            height: singleImageWidth,
            width: singleImageWidth,
            alignment: Alignment.center,
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(8.0), color: Colours.getFirstBorderColor(context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: const [
                LoadAssetSvg("common/camera", color: Colours.mainColor, width: 30),
                Gaps.vGap15,
                Text('选择图片或视频', style: TextStyle(color: Colours.secondaryFontColor, fontSize: 12))
              ],
            )));
  }

  _renderImageWidgets(BuildContext context) {
    if (CollUtil.isListEmpty(_imageFileList)) {
      return _getImageSelWidget(context, 0);
    }
    return Semantics(
        child: GridView.builder(
            shrinkWrap: true,
            itemCount: _imageFileList!.length == _maxImageCount ? _maxImageCount : _imageFileList!.length + 1,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, mainAxisSpacing: 3, crossAxisSpacing: 3, childAspectRatio: 1),
            itemBuilder: (context, index) => _renderSingleImageBean(
                context, index == _imageFileList!.length ? null : _imageFileList![index], index)));
  }

  _renderSingleImageBean(BuildContext context, XFile? imgFile, int index) {
    if (_imageFileList!.length != _maxImageCount && _imageFileList!.length == index) {
      return _getImageSelWidget(context, index);
    }
    return Container(
        margin: EdgeInsets.only(right: index % 3 == 2 ? 0 : 10, bottom: 10),
        height: singleImageWidth,
        width: singleImageWidth,
        child: Stack(children: [
          SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0), child: Image.file(File(imgFile!.path), fit: BoxFit.cover))),
          Positioned(
              top: 5,
              right: 5,
              child: GestureDetector(
                  child: Container(
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.redAccent),
                    child: const Icon(Icons.remove, color: Colors.white, size: 16),
                  ),
                  onTap: () {
                    setState(() {
                      _imageFileList!.removeAt(index);
                    });
                  }))
        ]));
  }

  _renderTweetExtraOpt(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      // constraints: BoxConstraints(
      //   maxHeight: Application.screenHeight * 0.1,
      // ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          GestureDetector(
              onTap: () => _reverseEnableReply(),
              child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
                  child: Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: <Widget>[
                    Icon(_enableReply ? Icons.lock_open : Icons.lock,
                        color: _enableReply ? Colours.mainColor : Colors.grey, size: 16),
                    Text(" ${_enableReply ? '允许评论' : '禁止评论'}",
                        style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500))
                  ]))),
          GestureDetector(
            onTap: () => _reverseAnonymous(),
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Icon(_anonymous ? Icons.visibility_off : Icons.visibility,
                      color: !_anonymous ? Colours.mainColor : Colors.grey, size: 16),
                  Text(" ${_anonymous ? '匿名' : '公开'}",
                      style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              GestureDetector(
                onTap: () => _forwardSelPage(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: Colours.getFirstBorderColor(context), borderRadius: BorderRadius.circular(8.0)),
                  child: Text(
                    "# $_typeText",
                    style: TextStyle(fontSize: 13, color: StrUtil.notEmpty(_typeName) ? Colors.blue : Colors.grey),
                  ),
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }

  void _forwardSelPage(BuildContext context) {
    BottomSheetUtil.showBottomSheet(context, 0.85, _buildTypeSelection(),
        topLine: false, topWidget: _buildTopWidget(context));
  }

  _buildTopWidget(BuildContext context) {
    Color c = Colours.getEmphasizedTextColor(context);
    return Container(
        height: 50,
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: AverageRow(children: [
          InkWell(child: Icon(Icons.close, color: c, size: 19), onTap: () => NavigatorUtils.goBack(context)),
          Container(
              alignment: Alignment.center,
              child: Text("请选择内容标签",
                  style: TextStyle(
                      fontSize: 15, color: Colours.getEmphasizedTextColor(context), fontWeight: FontWeight.bold))),
          Gaps.empty
        ]));
  }

  _buildTypeSelection() {
    List<TweetTypeEntity> entities = TweetTypeUtil.getPushableTweetTypeMap().values.toList();
    return Container(
        // color: Colours.getTweetScaffoldColor(context),
        // padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
        // padding: const EdgeInsets.all(10.0),
        // child: GridView.builder(
        //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //         crossAxisCount: 1, childAspectRatio: 2, crossAxisSpacing: 15.0, mainAxisSpacing: 35.0),
        //     itemCount: entities.length,
        //     physics: const NeverScrollableScrollPhysics(),
        //     shrinkWrap: true,
        //     itemBuilder: (context, index) {
        //       如果显示到最后一个并且Icon总数小于200时继续获取数据
        // return _buildSingleTypeItem(
        //     entities[index], StrUtil.notEmpty(_typeName) && _typeName == entities[index].name);
        // }),
        child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (ctx, idx) =>
                _buildSingleTypeItem(entities[idx], StrUtil.notEmpty(_typeName) && _typeName == entities[idx].name),
            shrinkWrap: true,
            itemCount: entities.length));
  }

  _buildSingleTypeItem(TweetTypeEntity entity, bool selected) {
    return ListTile(
        onTap: () {
          setState(() {
            _selectTypeCallback(entity.name);
            NavigatorUtils.goBack(context);
          });
        },
        leading: Icon(
          entity.iconData,
          size: 30,
          color: entity.iconColor,
        ),
        title: Text('# ' + entity.zhTag,
            style:
                TextStyle(color: Colours.getEmphasizedTextColor(context), fontSize: 14.5, fontWeight: FontWeight.w500)),
        subtitle:
            Text(entity.intro, maxLines: 2, style: const TextStyle(color: Colours.secondaryFontColor, fontSize: 13)));
  }

  void _selectTypeCallback(String typeName) {
    if (!StrUtil.isEmpty(typeName)) {
      setState(() {
        _typeName = typeName;
        _typeText = TweetTypeUtil.parseType(typeName).zhTag;
        _updatePushBtnState();
      });
    }
  }
}
