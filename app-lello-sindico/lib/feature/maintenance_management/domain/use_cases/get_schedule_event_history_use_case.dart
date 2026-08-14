import 'package:essentials/functional/try.dart';
import '../entity/schedule_event_history_entity.dart';
import '../repository/maintenance_management_repository.dart';

class GetScheduleEventHistoryUseCase {
  final MaintenanceManagementRepository _repository;

  GetScheduleEventHistoryUseCase(this._repository);

  Future<Try<ScheduleEventHistoryEntity>> call(String eventId) async {
    print(
        'DEBUG: GetScheduleEventHistoryUseCase chamado com eventId: $eventId');
    final result = await _repository.getScheduleEventHistory(eventId);
    return result;
  }
}
