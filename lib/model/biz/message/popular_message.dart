import 'package:json_annotation/json_annotation.dart';
import 'package:wall/model/biz/account/account.dart';
import 'package:wall/model/biz/message/asbtract_message.dart';


part 'popular_message.g.dart';

@JsonSerializable()
class PopularMessage extends AbstractMessage {
  late int tweetId;

  String? tweetBody;
  String? coverUrl;

  PopularMessage();

  @override
  Map<String, dynamic> toJson() => _$PopularMessageToJson(this);

  factory PopularMessage.fromJson(Map<String, dynamic> json) => _$PopularMessageFromJson(json);

}
