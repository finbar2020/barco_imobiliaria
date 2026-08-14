import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_locked_days.dart';

abstract class GetLockedDays
    extends UseCase<VacationLockedDays, GetLockedDaysParam> {}

class GetLockedDaysParam {
  final String condominiumId;
  final String employeeId;
  final DateTime? startDate;
  final DateTime? endDate;

  GetLockedDaysParam({
    required this.condominiumId,
    required this.employeeId,
    required this.startDate,
    required this.endDate,
  });
}
