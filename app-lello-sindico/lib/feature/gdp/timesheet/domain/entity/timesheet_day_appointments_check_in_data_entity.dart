import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_day_appointments_check_in_data_day_entity.dart';

class TimesheetDayAppointmentsCheckInData {
  String name;
  String craNumber;
  List<TimesheetDayAppointmentsCheckInDataDay> checkInDays;

  TimesheetDayAppointmentsCheckInData({
    required this.name,
    required this.craNumber,
    required this.checkInDays,
  });
}
