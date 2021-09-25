import 'package:json_annotation/json_annotation.dart';

part 'media.g.dart';

@JsonSerializable()
class Media {
  static const String moduleTopic = "TOPIC";
  static const String moduleCircle = "CIRCLE";
  static const String moduleTweet = "TWEET";
  static const String moduleAvatar = "AVATAR";

  static const String typeImage = "IMAGE";
  static const String typeVideo = "VIDEO";

  int? index;
  String? module;
  String? mediaType;
  String? url;
  String? name;

  Map<String, dynamic> toJson() => _$MediaToJson(this);

  factory Media.fromJson(Map<String, dynamic> json) => _$MediaFromJson(json);

  Media();

  Media.fromUrl(this.module, this.url, {this.name});
}
