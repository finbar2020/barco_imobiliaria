import 'package:essentials/base/use_case.dart';
import 'package:essentials/functional/try.dart';

import '../entity/efficiency_entity.dart';
import '../repository/maintenance_management_repository.dart';

class GetTaskSummaryRequest {
  final String dtStart;
  final String untilDate;

  GetTaskSummaryRequest({
    required this.dtStart,
    required this.untilDate,
  });
}

abstract class GetTaskSummaryUseCase
    extends UseCase<TaskSummaryEntity, GetTaskSummaryRequest> {}

class GetTaskSummaryUseCaseImpl implements GetTaskSummaryUseCase {
  final MaintenanceManagementRepository repository;

  GetTaskSummaryUseCaseImpl(this.repository);

  @override
  Future<Try<TaskSummaryEntity>> call(GetTaskSummaryRequest request) =>
      repository.getTaskSummary(request.dtStart, request.untilDate);
}
