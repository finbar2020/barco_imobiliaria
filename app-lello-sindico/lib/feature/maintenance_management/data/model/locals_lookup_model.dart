import 'package:essentials/essentials.dart';

part 'locals_lookup_model.g.dart';

@JsonSerializable()
class LocalLookupModel {
  final String id;
  final String name;
  @JsonKey(name: 'hierarchy_locals')
  final String hierarchyLocals;

  LocalLookupModel({
    required this.id,
    required this.name,
    required this.hierarchyLocals,
  });

  factory LocalLookupModel.fromJson(Map<String, dynamic> json) =>
      _$LocalLookupModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocalLookupModelToJson(this);
}

@JsonSerializable()
class LocalsLookupModel {
  final List<LocalLookupModel> locals;

  LocalsLookupModel({
    required this.locals,
  });

  factory LocalsLookupModel.fromJson(Map<String, dynamic> json) =>
      _$LocalsLookupModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocalsLookupModelToJson(this);
}
