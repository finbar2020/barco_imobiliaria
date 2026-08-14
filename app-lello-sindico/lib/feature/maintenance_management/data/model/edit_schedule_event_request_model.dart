import 'package:json_annotation/json_annotation.dart';

part 'edit_schedule_event_request_model.g.dart';

@JsonSerializable()
class EditScheduleEventRequestModel {
  @JsonKey(name: 'idSchedule')
  final String idSchedule;

  @JsonKey(name: 'idScheduleEvent')
  final String idScheduleEvent;

  @JsonKey(name: 'dtStart')
  final String dtStart;

  @JsonKey(name: 'timeStart')
  final String? timeStart;

  @JsonKey(name: 'timeEnd')
  final String? timeEnd;

  @JsonKey(name: 'allDay')
  final bool allDay;

  @JsonKey(name: 'repeat')
  final bool repeat;

  @JsonKey(name: 'until')
  final String? until;

  @JsonKey(name: 'procedureGroupId')
  final String? procedureGroupId;

  @JsonKey(name: 'procedureId')
  final String? procedureId;

  @JsonKey(name: 'localId')
  final String? localId;

  @JsonKey(name: 'assetId')
  final String? assetId;

  @JsonKey(name: 'updateType')
  final String updateType;

  @JsonKey(name: 'rrule')
  final EditScheduleEventRRuleModel? rrule;

  EditScheduleEventRequestModel({
    required this.idSchedule,
    required this.idScheduleEvent,
    required this.dtStart,
    this.timeStart,
    this.timeEnd,
    required this.allDay,
    required this.repeat,
    this.until,
    this.procedureGroupId,
    this.procedureId,
    this.localId,
    this.assetId,
    required this.updateType,
    this.rrule,
  });

  factory EditScheduleEventRequestModel.fromJson(Map<String, dynamic> json) =>
      _$EditScheduleEventRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$EditScheduleEventRequestModelToJson(this);
}

@JsonSerializable()
class EditScheduleEventRRuleModel {
  @JsonKey(name: 'frequency')
  final String frequency;

  @JsonKey(name: 'byDays')
  final List<String>? byDays;

  EditScheduleEventRRuleModel({
    required this.frequency,
    this.byDays,
  });

  factory EditScheduleEventRRuleModel.fromJson(Map<String, dynamic> json) =>
      _$EditScheduleEventRRuleModelFromJson(json);

  Map<String, dynamic> toJson() => _$EditScheduleEventRRuleModelToJson(this);
}
