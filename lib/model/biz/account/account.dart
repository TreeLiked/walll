import 'package:json_annotation/json_annotation.dart';

import 'account_profile.dart';

part 'account.g.dart';

@JsonSerializable()
class Account {
  String? id;
  String? nick;
  String? signature;

  // User user;
  String? avatarUrl;

  // AccountStatus status;
  // AccountRole role;
  String? mobile;
  int? regType;
  String? openId;

  DateTime? birthDay;

  String? gender;

  String? province;
  String? city;
  String? district;
  String? qq;
  String? weixin;

  AccountProfile? profile;

  Account();

  Account.fromId(this.id);

  Map<String, dynamic> toJson() => _$AccountToJson(this);

  factory Account.fromJson(Map<String, dynamic> json) => _$AccountFromJson(json);
}
