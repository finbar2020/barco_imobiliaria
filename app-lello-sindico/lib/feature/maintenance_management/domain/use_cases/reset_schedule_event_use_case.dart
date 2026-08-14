import 'package:essentials/base/use_case.dart';
import 'package:essentials/functional/try.dart';

import '../entity/reset_schedule_event_entity.dart';
import '../repository/maintenance_management_repository.dart';

abstract class ResetScheduleEventUseCase
    extends UseCase<ResetScheduleEventEntity, String> {}

class ResetScheduleEventUseCaseImpl implements ResetScheduleEventUseCase {
  final MaintenanceManagementRepository repository;

  ResetScheduleEventUseCaseImpl(this.repository);

  @override
  Future<Try<ResetScheduleEventEntity>> call(String scheduleEventId) async {
    return await repository.resetScheduleEvent(scheduleEventId);
  }
}
