import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_day_appointments_check_in_data_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/repository/timesheet_repository.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_check_in_data/get_check_in_data.dart';

class GetCheckInDataImpl extends GetCheckInData {
  final TimesheetRepository repository;

  GetCheckInDataImpl({required this.repository});

  @override
  Future<Try<List<TimesheetDayAppointmentsCheckInData>>> call(
      GetCheckInDataParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.getCheckInData(params.numCra, params.date);
  }

  Failure? _validate(GetCheckInDataParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.numCra.isEmpty) return InvalidParamFailure();
    return null;
  }
}
