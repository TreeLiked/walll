import 'package:json_annotation/json_annotation.dart';
import 'package:wall/model/biz/account/account_role.dart';

part 'account_display_info.g.dart';

@JsonSerializable()
class AccountDisplayInfo {
  bool? displayHistoryTweet;
  String? nick;
  String? signature;

  AccountRole? role;

  String? avatarUrl;
  String? email;
  bool displayName = false;
  String? name;
  bool displaySex = false;
  String? gender;
  bool displayAge = false;
  int? age;
  bool displayQQ = false;
  String? qq;
  bool displayWeChat = false;
  String? wechat;
  bool displayPhone = false;
  String? mobile;
  bool displayRegion = false;
  String? province;
  String? city;
  String? district;

  /// 学院信息
  bool displayInstitute = false;
  bool displayMajor = false;
  bool displayCla = false;
  bool displayGrade = false;
  String? instituteName;
  String? major;
  String? grade;
  String? cla;

  AccountDisplayInfo();

  Map<String, dynamic> toJson() => _$AccountDisplayInfoToJson(this);

  factory AccountDisplayInfo.fromJson(Map<String, dynamic> json) => _$AccountDisplayInfoFromJson(json);
}
