import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/timesheet/domain/repository/timesheet_repository.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_manual_appointments/get_manual_appointments.dart';

class GetManualAppointmentsImpl extends GetManualAppointments {
  final TimesheetRepository repository;

  GetManualAppointmentsImpl({required this.repository});

  @override
  Future<Try<List<String>>> call(GetManualAppointmentsParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.getManualAppointments(params.numCra, params.date);
  }

  Failure? _validate(GetManualAppointmentsParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.numCra.isEmpty) return InvalidParamFailure();
    return null;
  }
}
