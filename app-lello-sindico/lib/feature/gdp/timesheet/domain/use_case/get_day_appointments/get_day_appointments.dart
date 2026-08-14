import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_day_appointments_entity.dart';

abstract class GetDayAppointments
    extends UseCase<List<DayAppointmentsEntity>, GetDayAppointmentsParam> {}

class GetDayAppointmentsParam {
  final String date;

  GetDayAppointmentsParam({required this.date});
}
