import 'package:json_annotation/json_annotation.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_report_day.dart';

part 'timesheet_report_day_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TimesheetReportDayModel {
  int? totalAmount;
  int? presentAmount;
  int? dayOffAmount;
  int? vacationAmount;
  int? unmarkedAmount;
  int? shiftNotStartedAmount;
  int? attestationAmount;
  int? clearanceAmount;
  int? extraHours;

  TimesheetReportDayModel();

  factory TimesheetReportDayModel.fromJson(Map<String, dynamic> json) =>
      _$TimesheetReportDayModelFromJson(json);

  Map<String, dynamic> toJson() => _$TimesheetReportDayModelToJson(this);

  static TimesheetReportDayModel? fromEntity(TimesheetReportDay? entity) =>
      entity == null
          ? null
          : (TimesheetReportDayModel()
            ..totalAmount = entity.totalAmount
            ..presentAmount = entity.presentAmount
            ..dayOffAmount = entity.dayOffAmount
            ..vacationAmount = entity.vacationAmount
            ..unmarkedAmount = entity.unmarkedAmount
            ..shiftNotStartedAmount = entity.shiftNotStartedAmount
            ..attestationAmount = entity.attestationAmount
            ..clearanceAmount = entity.clearanceAmount
            ..extraHours = entity.extraHours);

  TimesheetReportDay toEntity() => TimesheetReportDay()
    ..totalAmount = this.totalAmount
    ..presentAmount = this.presentAmount
    ..dayOffAmount = this.dayOffAmount
    ..vacationAmount = this.vacationAmount
    ..unmarkedAmount = this.unmarkedAmount
    ..shiftNotStartedAmount = this.shiftNotStartedAmount
    ..attestationAmount = this.attestationAmount
    ..clearanceAmount = this.clearanceAmount
    ..extraHours = this.extraHours;
}
