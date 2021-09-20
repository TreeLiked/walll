import 'package:json_annotation/json_annotation.dart';

part 'account_profile.g.dart';

@JsonSerializable()
class AccountProfile {
  int? id;
  String? accId;
  String? name;
  String? mobile;
  String? email;
  String? gender;
  DateTime? birthday;
  String? province;
  String? city;
  String? district;
  String? qq;
  String? wechat;
  int? age;
  bool? displayHistoryTweet;

  AccountProfile();

  Map<String, dynamic> toJson() => _$AccountProfileToJson(this);

  factory AccountProfile.fromJson(Map<String, dynamic> json) => _$AccountProfileFromJson(json);
}
