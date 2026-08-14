import 'package:essentials/essentials.dart';
import '../entity/maintenance_task_events_response_entity.dart';
import '../repository/maintenance_management_repository.dart';

class GetMaintenanceTaskEventsParams {
  final DateTime dtStart;
  final DateTime untilDate;
  final List<String> typeTask;
  final List<String> status;
  final DateTime dayCurrent;
  final List<String>? procedureGroupLabels;
  final String? displayBy;
  final List<String>? assetIds;
  final List<String>? localIds;
  final List<String>? responsibleIds;
  final String? pageName;

  GetMaintenanceTaskEventsParams({
    required this.dtStart,
    required this.untilDate,
    required this.typeTask,
    required this.status,
    required this.dayCurrent,
    this.procedureGroupLabels,
    this.displayBy,
    this.assetIds,
    this.localIds,
    this.responsibleIds,
    this.pageName,
  });
}

abstract class GetMaintenanceTaskEventsUseCase extends UseCase<
    MaintenanceTaskEventsResponseEntity, GetMaintenanceTaskEventsParams> {}

class GetMaintenanceTaskEventsUseCaseImpl
    implements GetMaintenanceTaskEventsUseCase {
  final MaintenanceManagementRepository repository;

  GetMaintenanceTaskEventsUseCaseImpl(this.repository);

  @override
  Future<Try<MaintenanceTaskEventsResponseEntity>> call(
      GetMaintenanceTaskEventsParams params) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return repository.getMaintenanceTaskEvents(
      dtstart: dateFormat.format(params.dtStart),
      untilDate: dateFormat.format(params.untilDate),
      typeTask: params.typeTask,
      status: params.status,
      dayCurrent: dateFormat.format(params.dayCurrent),
      procedureGroupLabels: params.procedureGroupLabels,
      displayBy: params.displayBy,
      assetIds: params.assetIds,
      localIds: params.localIds,
      responsibleIds: params.responsibleIds,
      pageName: params.pageName,
    );
  }
}
