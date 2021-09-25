import 'package:json_annotation/json_annotation.dart';
import 'package:wall/model/biz/org/institute.dart';

part 'account_campus_profile.g.dart';

@JsonSerializable()
class AccountCampusProfile {
  Institute? institute;
  String? major;
  String? grade;
  String? cla;
  String? stuId;

  AccountCampusProfile();

  Map<String, dynamic> toJson() => _$AccountCampusProfileToJson(this);

  factory AccountCampusProfile.fromJson(Map<String, dynamic> json) => _$AccountCampusProfileFromJson(json);
}
