import 'package:json_annotation/json_annotation.dart';

part 'formulary_by_month_request_model.g.dart';

@JsonSerializable()
class FormularyByMonthFiltersModel {
  final List<String> typeTask;
  final List<String> status;
  final String dayCurrent;
  final List<String> responsibleIds;
  final List<String> localIds;
  final List<String> assetIds;

  const FormularyByMonthFiltersModel({
    required this.typeTask,
    required this.status,
    required this.dayCurrent,
    required this.responsibleIds,
    required this.localIds,
    required this.assetIds,
  });

  factory FormularyByMonthFiltersModel.fromJson(Map<String, dynamic> json) =>
      _$FormularyByMonthFiltersModelFromJson(json);

  Map<String, dynamic> toJson() => _$FormularyByMonthFiltersModelToJson(this);
}

@JsonSerializable()
class FormularyByMonthRequestModel {
  final String dtStart;
  final String untilDate;
  final FormularyByMonthFiltersModel filters;

  const FormularyByMonthRequestModel({
    required this.dtStart,
    required this.untilDate,
    required this.filters,
  });

  factory FormularyByMonthRequestModel.fromJson(Map<String, dynamic> json) =>
      _$FormularyByMonthRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$FormularyByMonthRequestModelToJson(this);
}
