import 'package:essentials/functional/try.dart';
import 'package:essentials/functional/failure.dart';
import '../repository/maintenance_management_repository.dart';
import '../entity/task_report_entity.dart';

abstract class GetTaskReportUseCase {
  Future<Try<TaskReportEntity>> call(String eventId);
}

class GetTaskReportUseCaseImpl implements GetTaskReportUseCase {
  final MaintenanceManagementRepository _repository;

  GetTaskReportUseCaseImpl({
    required MaintenanceManagementRepository repository,
  }) : _repository = repository;

  @override
  Future<Try<TaskReportEntity>> call(String eventId) async {
    if (eventId.isEmpty) {
      return Rejection(UnknownFailure('Event ID cannot be empty'));
    }

    try {
      return await _repository.getTaskReport(eventId);
    } catch (e) {
      return Rejection(UnknownFailure('Failed to get task report: $e'));
    }
  }
}
