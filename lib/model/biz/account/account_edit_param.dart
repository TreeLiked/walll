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
  static const String AVATAR = "AVATAR";
  static const String NICK = "NICK";
  static const String SIGNATURE = "SIGNATURE";
  static const String NAME = "NAME";
  static const String MOBILE = "MOBILE";
  static const String EMAIL = "EMAIL";
  static const String GENDER = "GENDER";
  static const String PROVINCE = "PROVINCE";
  static const String CITY = "CITY";
  static const String DISTRICT = "DISTRICT";
  static const String QQ = "QQ";
  static const String WECHAT = "WECHAT";
  static const String BIRTHDAY = "BIRTHDAY";

  static const String INSTITUTE = "INSTITUTE";
  static const String GRADE = "GRADE";
  static const String MAJOR = "MAJOR";
  static const String CLA = "CLA";
  static const String STU_ID = "STU_ID";
}
