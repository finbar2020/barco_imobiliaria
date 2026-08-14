import 'package:json_annotation/json_annotation.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_event.dart';

part 'timesheet_event_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TimesheetEventModel {
  String? id;
  String? registrationNumber;
  String? reference;
  int? minutes;
  String? createdBy;
  bool? flagProcessed;
  String? typeEvent;
  DateTime? effectiveDate;
  DateTime? processDate;
  DateTime? createdDate;
  DateTime? changedDate;

  TimesheetEventModel();

  factory TimesheetEventModel.fromJson(Map<String, dynamic> json) =>
      _$TimesheetEventModelFromJson(json);

  Map<String, dynamic> toJson() => _$TimesheetEventModelToJson(this);

  static TimesheetEventModel? fromEntity(TimesheetEvent? entity) =>
      entity == null
          ? null
          : (TimesheetEventModel()
            ..id = entity.id
            ..registrationNumber = entity.registrationNumber
            ..reference = entity.reference
            ..minutes = entity.minutes
            ..createdBy = entity.createdBy
            ..flagProcessed = entity.flagProcessed
            ..typeEvent = entity.typeEvent
            ..effectiveDate = entity.effectiveDate
            ..processDate = entity.processDate
            ..createdDate = entity.createdDate
            ..changedDate = entity.changedDate);

  TimesheetEvent toEntity() => TimesheetEvent()
    ..id = this.id
    ..registrationNumber = this.registrationNumber
    ..reference = this.reference
    ..minutes = this.minutes
    ..createdBy = this.createdBy
    ..flagProcessed = this.flagProcessed
    ..typeEvent = this.typeEvent
    ..effectiveDate = this.effectiveDate
    ..processDate = this.processDate
    ..createdDate = this.createdDate
    ..changedDate = this.changedDate;
}
