import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/gdp/timesheet/data/model/timesheet_day_appointments_check_in_data_day_item_model.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_day_appointments_check_in_data_day_entity.dart';

part 'timesheet_day_appointments_check_in_data_day_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TimesheetDayAppointmentsCheckInDataDayModel {
  DateTime date;
  List<TimesheetDayAppointmentsCheckInDataDayItemModel> checkInRecords;

  TimesheetDayAppointmentsCheckInDataDayModel({
    required this.date,
    required this.checkInRecords,
  });

  factory TimesheetDayAppointmentsCheckInDataDayModel.fromJson(
          Map<String, dynamic> json) =>
      _$TimesheetDayAppointmentsCheckInDataDayModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$TimesheetDayAppointmentsCheckInDataDayModelToJson(this);

  TimesheetDayAppointmentsCheckInDataDay toEntity() =>
      TimesheetDayAppointmentsCheckInDataDay(
        date: date,
        checkInRecords: checkInRecords.map((e) => e.toEntity()).toList(),
      );
}
