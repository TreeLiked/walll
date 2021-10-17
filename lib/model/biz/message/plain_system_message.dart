import 'package:json_annotation/json_annotation.dart';
import 'package:wall/model/biz/account/account.dart';
import 'package:wall/model/biz/message/asbtract_message.dart';

part 'plain_system_message.g.dart';

@JsonSerializable()
class PlainSystemMessage extends AbstractMessage {
  String? title;
  String? content;
  bool? hasCover;
  String? coverUrl;
  bool? hasLink;
  String? linkUrl;

  PlainSystemMessage();

  @override
  Map<String, dynamic> toJson() => _$PlainSystemMessageToJson(this);

  factory PlainSystemMessage.fromJson(Map<String, dynamic> json) => _$PlainSystemMessageFromJson(json);
}
