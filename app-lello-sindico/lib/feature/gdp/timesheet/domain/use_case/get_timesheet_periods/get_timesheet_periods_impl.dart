import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_periods.dart';
import 'package:lello/feature/gdp/timesheet/domain/repository/timesheet_repository.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_timesheet_periods/get_timesheet_periods.dart';

class GetTimesheetPeriodsUsecaseImpl extends GetTimesheetPeriodsUsecase {
  final TimesheetRepository repository;

  GetTimesheetPeriodsParam? _cacheParam;
  List<TimesheetPeriods>? _cacheData;

  GetTimesheetPeriodsUsecaseImpl({required this.repository});
  @override
  Future<Try<List<TimesheetPeriods>>> call(
      GetTimesheetPeriodsParam params) async {
    if (_cacheParam?.condoId == params.condoId &&
        _cacheData?.isNotEmpty == true) {
      return Success(_cacheData!);
    }

    final error = validate(params);
    if (error != null) return Rejection(error);

    var result = await repository.getTimesheetPeriods(params.condoId);

    _cacheParam = params;
    _cacheData = result.fold((l) => null, (r) => r);

    return result;
  }

  Failure? validate(GetTimesheetPeriodsParam? params) {
    if (params == null) return InvalidParamFailure();
    if (params.condoId.isEmpty) return InvalidParamFailure();

    return null;
  }
}
