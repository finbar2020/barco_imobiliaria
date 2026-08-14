import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_day_appointments_check_in_data_entity.dart';

abstract class GetCheckInData extends UseCase<
    List<TimesheetDayAppointmentsCheckInData>, GetCheckInDataParam> {}

class GetCheckInDataParam {
  final String numCra;
  final DateTime date;

  GetCheckInDataParam({required this.numCra, required this.date});
}
