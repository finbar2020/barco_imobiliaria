import 'package:essentials/essentials.dart';

part 'maintenance_task_events_request_model.g.dart';

@JsonSerializable()
class MaintenanceTaskEventsRequestFiltersModel {
  final List<String> typeTask;
  final List<String> procedureGroupLabels;
  final String displayBy;
  final List<String> status;
  final String dayCurrent;
  final List<String> assetIds;
  final List<String> localIds;
  final List<String> responsibleIds;

  MaintenanceTaskEventsRequestFiltersModel({
    required this.typeTask,
    required this.procedureGroupLabels,
    required this.displayBy,
    required this.status,
    required this.dayCurrent,
    required this.assetIds,
    required this.localIds,
    required this.responsibleIds,
  });

  factory MaintenanceTaskEventsRequestFiltersModel.fromJson(Map<String, dynamic> json) =>
      _$MaintenanceTaskEventsRequestFiltersModelFromJson(json);

  Map<String, dynamic> toJson() => _$MaintenanceTaskEventsRequestFiltersModelToJson(this);
}

@JsonSerializable()
class MaintenanceTaskEventsRequestModel {
  final String dtstart;
  final String untilDate;
  final MaintenanceTaskEventsRequestFiltersModel filters;
  final String? pageName;

  MaintenanceTaskEventsRequestModel({
    required this.dtstart,
    required this.untilDate,
    required this.filters,
    this.pageName,
  });

  factory MaintenanceTaskEventsRequestModel.fromJson(Map<String, dynamic> json) =>
      _$MaintenanceTaskEventsRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$MaintenanceTaskEventsRequestModelToJson(this);
}
