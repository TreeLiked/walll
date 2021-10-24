import 'package:city_pickers/city_pickers.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:wall/api/member_api.dart';
import 'package:wall/application.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/constant/gap_constant.dart';
import 'package:wall/model/biz/account/account.dart';
import 'package:wall/model/biz/account/account_edit_param.dart';
import 'package:wall/model/biz/common/gender.dart';
import 'package:wall/provider/account_local_provider.dart';
import 'package:wall/util/account_profille_util.dart';
import 'package:wall/util/bottom_sheet_util.dart';
import 'package:wall/util/common_util.dart';
import 'package:wall/util/navigator_util.dart';
import 'package:wall/util/str_util.dart';
import 'package:wall/util/theme_util.dart';
import 'package:wall/util/toast_util.dart';
import 'package:wall/widget/common/account_avatar_2.dart';
import 'package:wall/widget/common/button/long_flat_btn.dart';
import 'package:wall/widget/common/container/center_row_text.dart';
import 'package:wall/widget/common/custom_app_bar.dart';
import 'package:wall/widget/common/dialog/bottom_cancel_confirm.dart';

class AccountProfileEditPage extends StatefulWidget {
  const AccountProfileEditPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AccountProfileEditPageState();
  }
}

class _AccountProfileEditPageState extends State<AccountProfileEditPage> {
  final TextEditingController nickTextController = TextEditingController();
  final FocusNode nickFocusNode = FocusNode();
  final TextEditingController sigTextController = TextEditingController();
  final FocusNode sigFocusNode = FocusNode();

  bool isDark = false;
  BuildContext? _context;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      _getAccountProfile();
    });
  }

  // 获取更详细在的资料
  Future<void> _getAccountProfile() async {
    Util.showDefaultLoadingWithBounds(_context!);
    Account? acc = await MemberApi.getAccountProfile(Application.getAccountId!);
    NavigatorUtils.goBack(_context!);
    if (acc == null) {
      NavigatorUtils.goBack(_context!);
      return;
    }
    Provider.of<AccountLocalProvider>(context, listen: false).setAccount(acc);
  }

  @override
  Widget build(BuildContext context) {
    isDark = ThemeUtil.isDark(context);
    _context = context;

    return Scaffold(
        appBar: const CustomAppBar(title: '编辑个人资料', isBack: true),
        body: Consumer<AccountLocalProvider>(builder: (_, accProvider, __) {
          var account = accProvider.account!;
          return SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.only(top: 30.0, left: 15.0, right: 15.0),
            child: Column(children: [
              CenterRowWidget(
                  child: Stack(children: [
                AccountAvatar2(
                    size: 90,
                    avatarUrl: account.avatarUrl!,
                    onTap: () async {
                      String? resultUrl = await AccountProfileUtil.updateAvatar(context);
                      if (resultUrl != null) {
                        setState(() {
                          accProvider.account!.avatarUrl = resultUrl;
                        });
                      }
                    }),
                Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                        padding: const EdgeInsets.all(5),
                        alignment: Alignment.center,
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colours.getReversedBlackOrWhite(context),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3))
                            ]),
                        child: const Icon(Icons.camera_enhance_sharp, size: 17)))
              ])),
              Gaps.vGap50,
              _buildRowItem(context, '昵称', account.nick, nickTextController, (newNick) async {
                if (StrUtil.isEmpty(newNick) || newNick.trim().isEmpty) {
                  ToastUtil.showToast(context, '昵称不能为空哦');
                }
                String content = newNick.toString();
                await AccountProfileUtil.updateProfileItem(
                    context,
                    AccountEditParam(AccountEditKey.nick, content),
                    (_) => _render(() {
                          accProvider.account!.nick = content;
                          nickFocusNode.unfocus();
                        }));
              }, focusNode: nickFocusNode),
              Gaps.vGap30,
              _buildRowItem(context, '签名', account.signature, sigTextController, (newSig) async {
                if (StrUtil.isEmpty(newSig)) {
                  newSig = "";
                }
                String content = newSig.toString();
                await AccountProfileUtil.updateProfileItem(
                    context,
                    AccountEditParam(AccountEditKey.nick, content),
                    (_) => _render(() {
                          accProvider.account!.signature = content;
                          sigFocusNode.unfocus();
                        }));
              }, maxLines: 5, focusNode: sigFocusNode),
              _buildGenderItem(context, accProvider),
              _buildBirthItem(context, accProvider),
              _buildAreaItem(context, accProvider),
            ]),
          ));
        }));
  }

  _buildRowItem(BuildContext context, String title, String? textHolder, TextEditingController controller,
      ValueChanged<String> onSubmit,
      {int maxLines = 1, required FocusNode focusNode}) {
    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Padding(padding: const EdgeInsets.only(top: 5.0), child: _renderTitle(context, title)),
      Gaps.hGap30,
      Expanded(
        child: TextField(
            keyboardAppearance: Theme.of(context).brightness,
            focusNode: focusNode,
            controller: controller,
            maxLines: maxLines,
            minLines: 1,
            style: const TextStyle(fontSize: 15),
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.text,
            onSubmitted: onSubmit,
            onEditingComplete: () => onSubmit(controller.text),
            cursorColor: Colours.getEmphasizedTextColor(context),
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0),
                hintText: textHolder ?? "",
                hintStyle: const TextStyle(color: Colours.secondaryFontColor, fontSize: 15),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 0.4)),
                enabledBorder: InputBorder.none,
                isDense: true)),
      )
    ]);
  }

  _buildGenderItem(BuildContext context, AccountLocalProvider provider) {
    var gender = Gender.parseGender(provider.account!.profile!.gender);

    void updateGender(Gender ng) {
      if (gender.name == ng.name) {
        NavigatorUtils.goBack(context);
        return;
      }
      AccountProfileUtil.updateProfileItem(context, AccountEditParam(AccountEditKey.gender, ng.name), (_) {
        _render(() => provider.account!.profile!.gender = ng.name);
        ToastUtil.showToast(context, '更新成功');
        NavigatorUtils.goBack(context);
      });
    }

    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Container(
            margin: const EdgeInsets.only(top: 35.0),
            child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              _renderTitle(context, '性别'),
              Gaps.hGap30,
              _renderContent(context, gender.zhTag),
              _renderSuffixIcon()
            ])),
        onTap: () => BottomSheetUtil.showBottomSheet(
            context,
            0.3,
            BottomLeftRightDialog(
                average: true,
                content: '请选择您的性别',
                leftItem: LongFlatButton(
                    text: const Text('女', style: TextStyle(color: Colors.white)),
                    enabled: true,
                    needGradient: false,
                    onPressed: () => updateGender(Gender.female),
                    bgColor: Colours.feMaleMainColor),
                rightBgColor: Colours.maleMainColor,
                rightText: '男',
                onClickRight: () => updateGender(Gender.male))));
  }

  _buildBirthItem(BuildContext context, AccountLocalProvider provider) {
    var birth = provider.account!.profile!.birthday;
    var birthStr = birth != null ? DateUtil.formatDate(birth, format: DateFormats.y_mo_d) : "未设置";

    void _updateBirth(DateTime newBirth) {
      String dateFormat = DateUtil.formatDate(newBirth, format: DateFormats.full);
      AccountProfileUtil.updateProfileItem(context, AccountEditParam(AccountEditKey.birthday, dateFormat), (res) {
        _render(() => provider.account!.profile!.birthday = newBirth);
      });
    }

    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Container(
            margin: const EdgeInsets.only(top: 35.0),
            child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Text('生日',
                  style: TextStyle(
                      color: Colours.getEmphasizedTextColor(context), fontSize: 15, fontWeight: FontWeight.w400)),
              Gaps.hGap30,
              _renderContent(context, birthStr),
              _renderSuffixIcon(),
            ])),
        onTap: () {
          DatePicker.showDatePicker(context,
              theme: DatePickerTheme(
                  itemStyle: TextStyle(color: Colours.getEmphasizedTextColor(context), fontSize: 18),
                  cancelStyle: const TextStyle(color: Colors.grey, fontSize: 15.0),
                  doneStyle: const TextStyle(color: Colours.mainColor, fontSize: 16.0, fontWeight: FontWeight.bold),
                  backgroundColor: Colours.getScaffoldColor(context)),
              showTitleActions: true,
              currentTime: provider.account!.birthDay ?? DateTime.now(),
              locale: LocaleType.zh,
              minTime: DateTime(1900, 1, 1),
              maxTime: DateTime.now(),
              onConfirm: (date) => _updateBirth(date));
        });
  }

  _buildAreaItem(BuildContext context, AccountLocalProvider provider) {
    String _assembleAreaStr(province, city, district) {
      if (StrUtil.isEmpty(province)) {
        return '未设置';
      } else {
        if (StrUtil.isEmpty(city)) {
          return province;
        } else {
          if (StrUtil.isEmpty(district)) {
            return province + " - " + city;
          } else {
            return province + " - " + city + " - " + district;
          }
        }
      }
    }

    var accProfile = provider.account!.profile!;
    var areaStr = _assembleAreaStr(accProfile.province, accProfile.city, accProfile.district);

    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Container(
            margin: const EdgeInsets.only(top: 35.0),
            child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Text('地区',
                  style: TextStyle(
                      color: Colours.getEmphasizedTextColor(context), fontSize: 15, fontWeight: FontWeight.w400)),
              Gaps.hGap30,
              _renderContent(context, areaStr),
              _renderSuffixIcon(),
            ])),
        onTap: () async {
          Result? result = await CityPickers.showFullPageCityPicker(
              context: context,
              theme: ThemeData(
                  scaffoldBackgroundColor: Colours.getScaffoldColor(context),
                  appBarTheme: AppBarTheme(
                      // backgroundColor: Colours.getScaffoldColor(context),
                      elevation: 0,
                      color: Colours.getScaffoldColor(context),
                      iconTheme: IconThemeData(color: Colours.getEmphasizedTextColor(context), size: 13),
                      titleTextStyle: TextStyle(
                          color: Colours.getEmphasizedTextColor(context), fontSize: 16, fontWeight: FontWeight.bold))));
          if (result == null) {
            return;
          }
          bool update = false;
          if (result.provinceName != null && result.provinceName != accProfile.province) {
            update = true;
            AccountProfileUtil.updateProfileItem(
                context,
                AccountEditParam(AccountEditKey.province, result.provinceName!),
                (_) => _render(() => provider.account!.profile!.province = result.provinceName),
                autoLoading: false);
          }
          if (result.cityName != null && result.cityName != accProfile.city) {
            update = true;
            AccountProfileUtil.updateProfileItem(context, AccountEditParam(AccountEditKey.city, result.cityName!),
                (_) => _render(() => provider.account!.profile!.city = result.cityName),
                autoLoading: false);
          }
          if (result.areaName != null && result.areaName != accProfile.district) {
            update = true;
            AccountProfileUtil.updateProfileItem(context, AccountEditParam(AccountEditKey.district, result.areaName!),
                (_) => _render(() => provider.account!.profile!.district = result.areaName),
                autoLoading: false);
          }
          if (update) {
            ToastUtil.showToast(context, '修改成功');
          }
        });
  }

  _renderTitle(BuildContext context, String title) {
    return Text(title,
        style: TextStyle(color: Colours.getEmphasizedTextColor(context), fontSize: 15, fontWeight: FontWeight.w400));
  }

  _renderContent(BuildContext context, String content) {
    return Text(content, style: const TextStyle(color: Colours.secondaryFontColor, fontSize: 15));
  }

  _renderSuffixIcon() {
    return Expanded(
        child: Container(
            alignment: Alignment.centerRight,
            child: const Icon(Icons.keyboard_arrow_right, color: Colours.secondaryFontColor)));
  }

  void _render(Function f) {
    setState(() {
      f();
    });
  }
}
