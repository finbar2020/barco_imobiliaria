import 'package:json_annotation/json_annotation.dart';
import 'package:shared_features/feature/gdp/data/model/employee_model.dart';
import 'package:shared_features/feature/gdp/timesheet/data/model/timesheet_event_model.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet.dart';

part 'timesheet_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TimesheetModel {
  EmployeeModel? employee;
  DateTime? date;
  List<String>? time;
  List<String>? schedules;
  List<String>? justifications;
  String? comments;
  String? signature;
  List<String>? events;
  TimesheetEventModel? eventControl;
  int? lunchHours;
  int? workedHours;
  int? extraHours50;
  int? extraHours60;
  int? extraHours75;
  int? extraHours80;
  int? extraHours100;
  int? extraHours140;
  int? extraHours200;
  int? lateHours;
  int? earlyDepartureHours;
  String? statusDay;
  DateTime? monthClosing;

  TimesheetModel();

  factory TimesheetModel.fromJson(Map<String, dynamic> json) =>
      _$TimesheetModelFromJson(json);

  Map<String, dynamic> toJson() => _$TimesheetModelToJson(this);

  static TimesheetModel? fromEntity(Timesheet? entity) => entity == null
      ? null
      : (TimesheetModel()
        ..employee = EmployeeModel.fromEntity(entity.employee)
        ..date = entity.date
        ..time = entity.time
        ..schedules = entity.schedules
        ..justifications = entity.justifications
        ..comments = entity.comments
        ..signature = entity.signature
        ..events = entity.events
        ..eventControl = TimesheetEventModel.fromEntity(entity.eventControl)
        ..lunchHours = entity.lunchHours
        ..workedHours = entity.workedHours
        ..extraHours50 = entity.extraHours50
        ..extraHours60 = entity.extraHours60
        ..extraHours75 = entity.extraHours75
        ..extraHours80 = entity.extraHours80
        ..extraHours100 = entity.extraHours100
        ..extraHours140 = entity.extraHours140
        ..extraHours200 = entity.extraHours200
        ..lateHours = entity.lateHours
        ..earlyDepartureHours = entity.earlyDepartureHours
        ..statusDay = entity.statusDay
        ..monthClosing = entity.monthClosing);

  Timesheet toEntity() => Timesheet()
    ..employee = this.employee?.toEntity()
    ..date = this.date
    ..time = this.time
    ..schedules = this.schedules
    ..justifications = this.justifications
    ..comments = this.comments
    ..signature = this.signature
    ..events = this.events
    ..eventControl = this.eventControl?.toEntity()
    ..lunchHours = this.lunchHours
    ..workedHours = this.workedHours
    ..extraHours50 = this.extraHours50
    ..extraHours60 = this.extraHours60
    ..extraHours75 = this.extraHours75
    ..extraHours80 = this.extraHours80
    ..extraHours100 = this.extraHours100
    ..extraHours140 = this.extraHours140
    ..extraHours200 = this.extraHours200
    ..lateHours = this.lateHours
    ..earlyDepartureHours = this.earlyDepartureHours
    ..statusDay = this.statusDay
    ..monthClosing = this.monthClosing;
}
