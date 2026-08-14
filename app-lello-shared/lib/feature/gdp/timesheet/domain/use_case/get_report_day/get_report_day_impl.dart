import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_report_day.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/repository/timesheet_repository.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/use_case/get_report_day/get_report_day.dart';

class GetReportDayImpl extends GetReportDay {
  final TimesheetGDPRepository repository;

  GetReportDayImpl({required this.repository});

  @override
  Future<Try<TimesheetReportDay>> call(GetReportDayParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.getReportDay(params.condominiumId, params.filter);
  }

  Failure? _validate(GetReportDayParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
