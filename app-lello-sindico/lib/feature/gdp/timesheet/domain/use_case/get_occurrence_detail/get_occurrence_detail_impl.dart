import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_ocurrence_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/repository/timesheet_repository.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_occurrence_detail/get_occurrence_detail.dart';

class GetOccurrenceDetailImpl extends GetOccurrenceDetail {
  final TimesheetRepository repository;

  GetOccurrenceDetailImpl({required this.repository});

  @override
  Future<Try<List<TimesheetOccurrenceEntity>>> call(
      GetOccurrenceDetailParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.getOccurrenceDetail(params.date, params.type);
  }

  Failure? _validate(GetOccurrenceDetailParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.date.isEmpty) return InvalidParamFailure();
    if (param.type.isEmpty) return InvalidParamFailure();
    return null;
  }
}
