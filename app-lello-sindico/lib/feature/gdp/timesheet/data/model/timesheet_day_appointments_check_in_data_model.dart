import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/gdp/timesheet/data/model/timesheet_day_appointments_check_in_data_day_model.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_day_appointments_check_in_data_entity.dart';

part 'timesheet_day_appointments_check_in_data_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TimesheetDayAppointmentsCheckInDataModel {
  String name;
  String craNumber;
  List<TimesheetDayAppointmentsCheckInDataDayModel> checkInDays;

  TimesheetDayAppointmentsCheckInDataModel({
    required this.name,
    required this.craNumber,
    required this.checkInDays,
  });

  factory TimesheetDayAppointmentsCheckInDataModel.fromJson(
          Map<String, dynamic> json) =>
      _$TimesheetDayAppointmentsCheckInDataModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$TimesheetDayAppointmentsCheckInDataModelToJson(this);

  TimesheetDayAppointmentsCheckInData toEntity() =>
      TimesheetDayAppointmentsCheckInData(
        name: name,
        craNumber: craNumber,
        checkInDays: checkInDays.map((e) => e.toEntity()).toList(),
      );
}
