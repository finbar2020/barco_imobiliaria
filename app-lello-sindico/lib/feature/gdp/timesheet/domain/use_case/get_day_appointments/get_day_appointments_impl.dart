import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_day_appointments_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/repository/timesheet_repository.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_day_appointments/get_day_appointments.dart';

class GetDayAppointmentsImpl extends GetDayAppointments {
  final TimesheetRepository repository;

  GetDayAppointmentsImpl({required this.repository});

  @override
  Future<Try<List<DayAppointmentsEntity>>> call(
      GetDayAppointmentsParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.getDayAppointments(params.date);
  }

  Failure? _validate(GetDayAppointmentsParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.date.isEmpty) return InvalidParamFailure();
    return null;
  }
}
