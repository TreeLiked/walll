import 'package:event_bus/event_bus.dart';
import 'package:json_annotation/json_annotation.dart';

part 'im_dto.g.dart';

// ws 命令消息总线
final EventBus wsCommandEventBus = EventBus();

@JsonSerializable()
class ImDTO {
  static const int commandTweetCreated = 200;
  static const int commonTweetPraised = 201;
  static const int commonTweetReplied = 202;
  static const int commondTweetDeleted = 203;

  static const int commandPullMessage = 900;

  int? command;
  dynamic data;

  ImDTO();

  Map<String, dynamic> toJson() => _$ImDTOToJson(this);

  factory ImDTO.fromJson(Map<String, dynamic> json) => _$ImDTOFromJson(json);
}
