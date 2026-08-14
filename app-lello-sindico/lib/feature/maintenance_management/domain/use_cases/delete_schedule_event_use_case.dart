import 'package:essentials/base/use_case.dart';
import 'package:essentials/functional/try.dart';

import '../entity/delete_schedule_event_entity.dart';
import '../repository/maintenance_management_repository.dart';

abstract class DeleteScheduleEventUseCase extends UseCase<
    DeleteScheduleEventResponseEntity, DeleteScheduleEventRequestEntity> {}

class DeleteScheduleEventUseCaseImpl implements DeleteScheduleEventUseCase {
  final MaintenanceManagementRepository repository;

  DeleteScheduleEventUseCaseImpl(this.repository);

  @override
  Future<Try<DeleteScheduleEventResponseEntity>> call(
      DeleteScheduleEventRequestEntity params) async {
    return await repository.deleteScheduleEvent(params);
  }
}
