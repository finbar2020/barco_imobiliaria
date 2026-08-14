import 'package:essentials/base/use_case.dart';
import 'package:essentials/functional/try.dart';

import '../entity/task_formularies_entity.dart';
import '../repository/maintenance_management_repository.dart';

class GetTaskFormulariesRequest {
  final String taskId;

  GetTaskFormulariesRequest({required this.taskId});
}

abstract class GetTaskFormulariesUseCase
    extends UseCase<TaskFormulariesResponseEntity, GetTaskFormulariesRequest> {}

class GetTaskFormulariesUseCaseImpl implements GetTaskFormulariesUseCase {
  final MaintenanceManagementRepository repository;

  GetTaskFormulariesUseCaseImpl(this.repository);

  @override
  Future<Try<TaskFormulariesResponseEntity>> call(
      GetTaskFormulariesRequest request) {
    return repository.getTaskFormularies(request.taskId);
  }
}
