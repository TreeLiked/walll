import 'package:json_annotation/json_annotation.dart';

part 'page_param.g.dart';

@JsonSerializable()
class PageParam {
  // 当前页
  late int currentPage;

  // 查询数量
  int pageSize;

  // 限制查询的推文类型
  List<String>? types;

  // 是否限定查询的组织
  int? orgId;

  PageParam(this.currentPage,  {this.pageSize = 10, this.types, this.orgId});

  Map<String, dynamic> toJson() => _$PageParamToJson(this);
}
