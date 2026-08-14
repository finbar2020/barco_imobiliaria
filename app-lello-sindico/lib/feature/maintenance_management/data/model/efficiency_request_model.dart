import 'package:essentials/essentials.dart';

part 'efficiency_request_model.g.dart';

@JsonSerializable()
class EfficiencyFiltersModel {
  final List<String> typeTask;
  final String dayCurrent;
  final List<String> procedureGroupLabels;
  final List<String> procedureGroupIds;
  final List<String> responsibleIds;
  final String displayBy;
  final List<String> status;

  EfficiencyFiltersModel({
    required this.typeTask,
    required this.dayCurrent,
    required this.procedureGroupLabels,
    required this.procedureGroupIds,
    required this.responsibleIds,
    required this.displayBy,
    required this.status,
  });

  factory EfficiencyFiltersModel.fromJson(Map<String, dynamic> json) =>
      _$EfficiencyFiltersModelFromJson(json);

  Map<String, dynamic> toJson() => _$EfficiencyFiltersModelToJson(this);
}

@JsonSerializable()
class EfficiencyRequestModel {
  final String dtStart;
  final String untilDate;
  final EfficiencyFiltersModel filters;
  final String? pageName;

  EfficiencyRequestModel({
    required this.dtStart,
    required this.untilDate,
    required this.filters,
    this.pageName,
  });

  factory EfficiencyRequestModel.fromJson(Map<String, dynamic> json) =>
      _$EfficiencyRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$EfficiencyRequestModelToJson(this);
}
