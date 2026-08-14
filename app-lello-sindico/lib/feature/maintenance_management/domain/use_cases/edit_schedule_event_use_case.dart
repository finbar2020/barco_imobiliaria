import 'package:essentials/base/use_case.dart';
import 'package:essentials/functional/try.dart';

import '../entity/edit_schedule_event_entity.dart';
import '../repository/maintenance_management_repository.dart';

abstract class EditScheduleEventUseCase extends UseCase<
    EditScheduleEventResponseEntity, EditScheduleEventRequestEntity> {}

class EditScheduleEventUseCaseImpl implements EditScheduleEventUseCase {
  final MaintenanceManagementRepository repository;

  EditScheduleEventUseCaseImpl(this.repository);

  @override
  Future<Try<EditScheduleEventResponseEntity>> call(
      EditScheduleEventRequestEntity params) async {
    return await repository.editScheduleEvent(params);
  }
}
