import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_day_appointments_check_in_data_day_item_entity.dart';

class TimesheetDayAppointmentsCheckInDataDay {
  DateTime date;
  List<TimesheetDayAppointmentsCheckInDataDayItem> checkInRecords;

  TimesheetDayAppointmentsCheckInDataDay({
    required this.date,
    required this.checkInRecords,
  });
}
