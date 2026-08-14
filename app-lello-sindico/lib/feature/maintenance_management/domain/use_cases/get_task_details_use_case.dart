import 'package:essentials/base/use_case.dart';
import 'package:essentials/functional/try.dart';

import '../entity/task_details_entity.dart';
import '../repository/maintenance_management_repository.dart';

class GetTaskDetailsRequest {
  final String taskId;

  GetTaskDetailsRequest({required this.taskId});
}

abstract class GetTaskDetailsUseCase
    extends UseCase<TaskDetailsEntity, GetTaskDetailsRequest> {}

class GetTaskDetailsUseCaseImpl implements GetTaskDetailsUseCase {
  final MaintenanceManagementRepository repository;

  GetTaskDetailsUseCaseImpl(this.repository);

  @override
  Future<Try<TaskDetailsEntity>> call(GetTaskDetailsRequest request) {
    return repository.getTaskDetails(request.taskId);
  }
}
