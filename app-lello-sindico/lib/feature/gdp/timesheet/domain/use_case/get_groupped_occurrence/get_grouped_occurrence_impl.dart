import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_ocurrence_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/repository/timesheet_repository.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_groupped_occurrence/get_grouped_occurrence.dart';

class GetGroupedOccurrenceImpl extends GetGroupedOccurrence {
  final TimesheetRepository repository;

  GetGroupedOccurrenceImpl({required this.repository});

  @override
  Future<Try<List<TimesheetOccurrenceEntity>>> call(
      GetGroupedOccurrenceParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.getGrouppedOccurrence(params.date, params.type);
  }

  Failure? _validate(GetGroupedOccurrenceParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.date.isEmpty) return InvalidParamFailure();
    if (param.type.isEmpty) return InvalidParamFailure();
    return null;
  }
}
