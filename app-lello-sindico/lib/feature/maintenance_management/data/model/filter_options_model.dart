import 'package:essentials/essentials.dart';

part 'filter_options_model.g.dart';

@JsonSerializable()
class FilterLocalModel {
  final String id;
  final String name;

  FilterLocalModel({
    required this.id,
    required this.name,
  });

  factory FilterLocalModel.fromJson(Map<String, dynamic> json) =>
      _$FilterLocalModelFromJson(json);

  Map<String, dynamic> toJson() => _$FilterLocalModelToJson(this);
}

@JsonSerializable()
class FilterAssetModel {
  final String id;
  final String name;

  FilterAssetModel({
    required this.id,
    required this.name,
  });

  factory FilterAssetModel.fromJson(Map<String, dynamic> json) =>
      _$FilterAssetModelFromJson(json);

  Map<String, dynamic> toJson() => _$FilterAssetModelToJson(this);
}

@JsonSerializable()
class FilterResponsibleModel {
  final String id;
  final String name;

  FilterResponsibleModel({
    required this.id,
    required this.name,
  });

  factory FilterResponsibleModel.fromJson(Map<String, dynamic> json) =>
      _$FilterResponsibleModelFromJson(json);

  Map<String, dynamic> toJson() => _$FilterResponsibleModelToJson(this);
}

@JsonSerializable()
class FilterEmployeeGroupModel {
  final String id;
  final String name;

  FilterEmployeeGroupModel({
    required this.id,
    required this.name,
  });

  factory FilterEmployeeGroupModel.fromJson(Map<String, dynamic> json) =>
      _$FilterEmployeeGroupModelFromJson(json);

  Map<String, dynamic> toJson() => _$FilterEmployeeGroupModelToJson(this);
}

@JsonSerializable()
class FilterOptionsModel {
  final List<FilterLocalModel> locals;
  final List<FilterAssetModel> assets;
  final List<FilterResponsibleModel> responsibles;
  @JsonKey(name: 'employee_group')
  final List<FilterEmployeeGroupModel> employeeGroup;

  FilterOptionsModel({
    required this.locals,
    required this.assets,
    required this.responsibles,
    required this.employeeGroup,
  });

  factory FilterOptionsModel.fromJson(Map<String, dynamic> json) =>
      _$FilterOptionsModelFromJson(json);

  Map<String, dynamic> toJson() => _$FilterOptionsModelToJson(this);
}
