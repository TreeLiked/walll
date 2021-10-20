import 'package:json_annotation/json_annotation.dart';

part 'account_edit_param.g.dart';

@JsonSerializable()
class AccountEditParam {
  final String key;
  final String value;

  const AccountEditParam(this.key, this.value);

  Map<String, dynamic> toJson() => _$AccountEditParamToJson(this);
}

class AccountEditKey {
  static const String avatar = "AVATAR";
  static const String nick = "NICK";
  static const String signature = "SIGNATURE";
  static const String name = "NAME";
  static const String mobile = "MOBILE";
  static const String email = "EMAIL";
  static const String gender = "GENDER";
  static const String province = "PROVINCE";
  static const String city = "CITY";
  static const String district = "DISTRICT";
  static const String qq = "QQ";
  static const String weChat = "WECHAT";
  static const String birthday = "BIRTHDAY";

  static const String institute = "INSTITUTE";
  static const String grade = "GRADE";
  static const String major = "MAJOR";
  static const String cal = "CLA";
  static const String stuId = "STU_ID";
}
