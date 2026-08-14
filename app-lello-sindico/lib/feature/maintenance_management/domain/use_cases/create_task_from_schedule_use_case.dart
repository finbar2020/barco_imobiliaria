import 'package:essentials/functional/try.dart';
import '../entity/create_task_from_schedule_entity.dart';
import '../repository/maintenance_management_repository.dart';

abstract class CreateTaskFromScheduleUseCase {
  Future<Try<CreateTaskFromScheduleResponseEntity>> call(
      CreateTaskFromScheduleRequestEntity request);
}

class CreateTaskFromScheduleUseCaseImpl
    implements CreateTaskFromScheduleUseCase {
  final MaintenanceManagementRepository repository;

  CreateTaskFromScheduleUseCaseImpl(this.repository);

  @override
  Future<Try<CreateTaskFromScheduleResponseEntity>> call(
      CreateTaskFromScheduleRequestEntity request) {
    return repository.createTaskFromSchedule(request);
  }
}
