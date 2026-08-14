import 'package:essentials/essentials.dart';
import '../entity/calendar_days_response_entity.dart';
import '../repository/maintenance_management_repository.dart';

class GetCalendarDaysParams {
  final int month;
  final int year;
  final List<String>? typeTask;
  final List<String>? status;
  final List<String>? assetIds;
  final List<String>? localIds;
  final List<String>? responsibleIds;

  GetCalendarDaysParams({
    required this.month,
    required this.year,
    this.typeTask,
    this.status,
    this.assetIds,
    this.localIds,
    this.responsibleIds,
  });
}

abstract class GetCalendarDaysUseCase
    extends UseCase<CalendarDaysResponseEntity, GetCalendarDaysParams> {}

class GetCalendarDaysUseCaseImpl implements GetCalendarDaysUseCase {
  final MaintenanceManagementRepository repository;

  GetCalendarDaysUseCaseImpl(this.repository);

  @override
  Future<Try<CalendarDaysResponseEntity>> call(GetCalendarDaysParams params) {
    return repository.getCalendarDays(
      month: params.month,
      year: params.year,
      typeTask: params.typeTask,
      status: params.status,
      assetIds: params.assetIds,
      localIds: params.localIds,
      responsibleIds: params.responsibleIds,
    );
  }
}
