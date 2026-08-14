import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_month_resume_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/repository/timesheet_repository.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_month_resume/get_month_resume.dart';

class GetMonthResumeImpl extends GetMonthResume {
  final TimesheetRepository repository;

  GetMonthResumeImpl({required this.repository});

  @override
  Future<Try<TimesheetMonthResumeEntity>> call(
      GetMonthResumeParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.getMonthResume(params.date);
  }

  Failure? _validate(GetMonthResumeParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.date.isEmpty) return InvalidParamFailure();
    return null;
  }
}
