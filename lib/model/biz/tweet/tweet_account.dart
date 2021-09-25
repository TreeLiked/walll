
import 'package:json_annotation/json_annotation.dart';

part 'tweet_account.g.dart';
@JsonSerializable()
class TweetAccount {

  /// 主键
  String? id;

  /// 昵称
  String? nick;

  /// 个性签名
  String? signature;

  /// 头像链接
  String? avatarUrl;

  /// 学院
  String? institute;

  /// 班级
  String? cla;

  String? gender;

  TweetAccount();


  Map<String, dynamic> toJson() => _$TweetAccountToJson(this);

  factory TweetAccount.fromJson(Map<String, dynamic> json) => _$TweetAccountFromJson(json);

}