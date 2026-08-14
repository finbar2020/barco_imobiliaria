import 'package:essentials/base/use_case.dart';
import 'package:essentials/functional/try.dart';

import '../entity/create_task_entity.dart';
import '../repository/maintenance_management_repository.dart';

abstract class CreateTaskUseCase
    extends UseCase<CreateTaskResponseEntity, CreateTaskRequestEntity> {}

class CreateTaskUseCaseImpl implements CreateTaskUseCase {
  final MaintenanceManagementRepository repository;

  CreateTaskUseCaseImpl(this.repository);

  @override
  Future<Try<CreateTaskResponseEntity>> call(CreateTaskRequestEntity request) =>
      repository.createTask(request);
}
