import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/domain/entity/filter_options_entity.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/get_maintenance_task_events_use_case.dart';
import 'package:lello/feature/maintenance_management/presentation/home/widgets/task_card/task_card_enum.dart';
import 'package:lello/feature/maintenance_management/presentation/home/widgets/task_summary/task_summary_model.dart';

void main() {
  group('Filters Integration Test', () {
    test('should create GetMaintenanceTaskEventsParams with filter IDs', () {
      final appliedFilters = FilterOptionsEntity(
        taskType: [TaskType.routine, TaskType.serviceOrder],
        taskStatus: [TaskStatusType.pending, TaskStatusType.inProgress],
        locals: [
          FilterLocalEntity(id: 'local-1', name: 'Churrasqueira'),
          FilterLocalEntity(id: 'local-2', name: 'Piscina'),
        ],
        assets: [
          FilterAssetEntity(id: 'asset-1', name: 'Bomba da Piscina'),
          FilterAssetEntity(id: 'asset-2', name: 'Portão Eletrônico'),
        ],
        responsibles: [
          FilterResponsibleEntity(id: 'resp-1', name: 'João Silva'),
          FilterResponsibleEntity(id: 'resp-2', name: 'Maria Santos'),
        ],
        employeeGroup: [],
      );

      final params = GetMaintenanceTaskEventsParams(
        dtStart: DateTime(2024, 1, 1),
        untilDate: DateTime(2024, 1, 7),
        typeTask: ['ROTINA', 'ORDEM_SERVICO'],
        status: ['PENDENTE', 'EM_ANDAMENTO'],
        dayCurrent: DateTime.now(),
        procedureGroupLabels: [],
        displayBy: 'GRUPO',
        assetIds: appliedFilters.assets.map((asset) => asset.id).toList(),
        localIds: appliedFilters.locals.map((local) => local.id).toList(),
        responsibleIds:
            appliedFilters.responsibles.map((resp) => resp.id).toList(),
      );

      expect(params.assetIds, equals(['asset-1', 'asset-2']));
      expect(params.localIds, equals(['local-1', 'local-2']));
      expect(params.responsibleIds, equals(['resp-1', 'resp-2']));
      expect(params.typeTask, equals(['ROTINA', 'ORDEM_SERVICO']));
      expect(params.status, equals(['PENDENTE', 'EM_ANDAMENTO']));
    });

    test('should handle null filters gracefully', () {
      final params = GetMaintenanceTaskEventsParams(
        dtStart: DateTime(2024, 1, 1),
        untilDate: DateTime(2024, 1, 7),
        typeTask: ['ROTINA'],
        status: ['PENDENTE'],
        dayCurrent: DateTime.now(),
        assetIds: null,
        localIds: null,
        responsibleIds: null,
      );

      expect(params.assetIds, isNull);
      expect(params.localIds, isNull);
      expect(params.responsibleIds, isNull);
    });

    test('should handle empty filter lists', () {
      final appliedFilters = FilterOptionsEntity(
        taskType: [TaskType.routine],
        taskStatus: [TaskStatusType.pending],
        locals: [],
        assets: [],
        responsibles: [],
        employeeGroup: [],
      );

      final assetIds = appliedFilters.assets.map((asset) => asset.id).toList();
      final localIds = appliedFilters.locals.map((local) => local.id).toList();
      final responsibleIds =
          appliedFilters.responsibles.map((resp) => resp.id).toList();

      expect(assetIds, isEmpty);
      expect(localIds, isEmpty);
      expect(responsibleIds, isEmpty);
    });
  });
}
