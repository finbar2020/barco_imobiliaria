import 'package:essentials/base/use_case.dart';
import 'package:essentials/functional/try.dart';

import '../entity/task_files_entity.dart';
import '../repository/maintenance_management_repository.dart';

class GetTaskFilesRequest {
  final String taskId;

  GetTaskFilesRequest({required this.taskId});
}

abstract class GetTaskFilesUseCase
    extends UseCase<TaskFilesResponseEntity, GetTaskFilesRequest> {}

class GetTaskFilesUseCaseImpl implements GetTaskFilesUseCase {
  final MaintenanceManagementRepository repository;

  GetTaskFilesUseCaseImpl(this.repository);

  @override
  Future<Try<TaskFilesResponseEntity>> call(GetTaskFilesRequest request) {
    return repository.getTaskFiles(request.taskId);
  }
}
