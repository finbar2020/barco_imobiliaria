import 'package:essentials/essentials.dart';
import 'package:intl/intl.dart';
import '../entity/schedule_events_detail_response_entity.dart';
import '../repository/maintenance_management_repository.dart';

class GetScheduleEventsParams {
  final DateTime date;
  final List<String>? typeTask;
  final List<String>? status;
  final List<String>? assetIds;
  final List<String>? localIds;
  final List<String>? responsibleIds;
  final String? pageName;

  GetScheduleEventsParams({
    required this.date,
    this.typeTask,
    this.status,
    this.assetIds,
    this.localIds,
    this.responsibleIds,
    this.pageName,
  });
}

abstract class GetScheduleEventsUseCase extends UseCase<
    ScheduleEventsDetailResponseEntity, GetScheduleEventsParams> {}

class GetScheduleEventsUseCaseImpl implements GetScheduleEventsUseCase {
  final MaintenanceManagementRepository repository;

  GetScheduleEventsUseCaseImpl(this.repository);

  @override
  Future<Try<ScheduleEventsDetailResponseEntity>> call(
      GetScheduleEventsParams params) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final formattedDate = dateFormat.format(params.date);

    return repository.getScheduleEvents(
      dtStart: formattedDate,
      untilDate: formattedDate,
      dayCurrent: formattedDate,
      typeTask: params.typeTask,
      status: params.status,
      assetIds: params.assetIds,
      localIds: params.localIds,
      responsibleIds: params.responsibleIds,
      pageName: params.pageName,
    );
  }
}
