import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_occurrence_vacation_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/repository/timesheet_repository.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_occurrence_vacation/get_occurrence_vacation.dart';

class GetOccurrenceVacationImpl extends GetOccurrenceVacation {
  final TimesheetRepository repository;

  GetOccurrenceVacationImpl({required this.repository});

  @override
  Future<Try<List<TimesheetOccurrenceVacationEntity>>> call(
      GetOccurrenceVacationParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.getOccurrenceVacation(params.date);
  }

  Failure? _validate(GetOccurrenceVacationParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.date.isEmpty) return InvalidParamFailure();
    return null;
  }
}
