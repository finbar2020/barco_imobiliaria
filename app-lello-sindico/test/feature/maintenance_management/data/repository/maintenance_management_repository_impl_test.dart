import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/core/aws_uploader/aws_uploader.dart';
import 'package:lello/feature/maintenance_management/data/data_source/maintenance_management_remote_data_source.dart';
import 'package:lello/feature/maintenance_management/data/model/maintenance_task_event_model.dart';
import 'package:lello/feature/maintenance_management/data/model/maintenance_task_events_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/maintenance_task_events_response_model.dart';
import 'package:lello/feature/maintenance_management/data/model/task_summary_model.dart';
import 'package:lello/feature/maintenance_management/data/repository/maintenance_management_repository_impl.dart';
import 'package:lello/feature/maintenance_management/domain/entity/maintenance_task_events_response_entity.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/get_maintenance_task_events_use_case.dart';

class _FakeRemote extends Fake implements MaintenanceManagementRemoteDataSource {
  MaintenanceTaskEventsRequestModel? lastRequest;
  Object? error;

  @override
  Future<MaintenanceTaskEventsResponseModel> getMaintenanceTaskEvents(
    MaintenanceTaskEventsRequestModel request,
  ) async {
    lastRequest = request;
    if (error != null) {
      throw error!;
    }
    return MaintenanceTaskEventsResponseModel(
      taskSummaryDay: TaskSummaryModel(
        total: 2,
        done: 1,
        notStarted: 1,
        draft: 0,
      ),
      taskFormulary: [
        MaintenanceTaskEventModel(
          idTask: 't-1',
          typeTask: 'ROTINA',
          name: 'Bomba da piscina',
          fullDescription: 'Checagem semanal',
          responsibleUserable: 'Maria',
          timeStart: '09:00',
          timeDescription: '09:00',
          dtstart: '2026-01-15T00:00:00.000Z',
          dtstartFormatted: '15/01/2026',
          status: 'PENDENTE',
          allDay: false,
        ),
      ],
    );
  }
}

class _FakeUploader extends Fake implements AwsUploader {}

void main() {
  late _FakeRemote remote;
  late GetMaintenanceTaskEventsUseCaseImpl useCase;

  setUp(() {
    remote = _FakeRemote();
    final repository = MaintenanceManagementRepositoryImpl(
      remote,
      _FakeUploader(),
    );
    useCase = GetMaintenanceTaskEventsUseCaseImpl(repository);
  });

  test(
    'integra use case → repository → remote: monta request e mapeia entity',
    () async {
      final result = await useCase(
        GetMaintenanceTaskEventsParams(
          dtStart: DateTime(2026, 1, 1),
          untilDate: DateTime(2026, 1, 7),
          typeTask: const ['ROTINA', 'ORDEM_SERVICO'],
          status: const ['PENDENTE'],
          dayCurrent: DateTime(2026, 1, 3),
          assetIds: const ['asset-1'],
          localIds: const ['local-1'],
          responsibleIds: const ['resp-1'],
          displayBy: 'GRUPO',
          pageName: 'agenda',
        ),
      );

      expect(result, isA<Success<MaintenanceTaskEventsResponseEntity>>());
      final entity = (result as Success<MaintenanceTaskEventsResponseEntity>).get();
      expect(entity.taskSummaryDay.total, 2);
      expect(entity.taskFormulary, hasLength(1));
      expect(entity.taskFormulary.first.name, 'Bomba da piscina');
      expect(entity.taskFormulary.first.idTask, 't-1');

      final request = remote.lastRequest!;
      expect(request.dtstart, '01/01/2026');
      expect(request.untilDate, '07/01/2026');
      expect(request.pageName, 'agenda');
      expect(request.filters.typeTask, ['ROTINA', 'ORDEM_SERVICO']);
      expect(request.filters.status, ['PENDENTE']);
      expect(request.filters.assetIds, ['asset-1']);
      expect(request.filters.localIds, ['local-1']);
      expect(request.filters.responsibleIds, ['resp-1']);
      expect(request.filters.displayBy, 'GRUPO');
    },
  );

  test('integra falha do remote em Rejection', () async {
    remote.error = Exception('timeout');
    final result = await useCase(
      GetMaintenanceTaskEventsParams(
        dtStart: DateTime(2026, 1, 1),
        untilDate: DateTime(2026, 1, 7),
        typeTask: const ['ROTINA'],
        status: const ['PENDENTE'],
        dayCurrent: DateTime(2026, 1, 3),
      ),
    );
    expect(result, isA<Rejection<MaintenanceTaskEventsResponseEntity>>());
  });
}
