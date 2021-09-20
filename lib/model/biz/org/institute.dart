
import 'package:json_annotation/json_annotation.dart';
part 'institute.g.dart';

@JsonSerializable()
class Institute {
  int? id;
  String? name;

  Institute();

  Map<String, dynamic> toJson() => _$InstituteToJson(this);

  factory Institute.fromJson(Map<String, dynamic> json) => _$InstituteFromJson(json);
}
