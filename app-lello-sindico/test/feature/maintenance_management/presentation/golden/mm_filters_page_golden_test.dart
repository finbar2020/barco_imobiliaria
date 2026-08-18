import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/domain/entity/filter_options_entity.dart';
import 'package:lello/feature/maintenance_management/presentation/home/pages/maintenance_management_filters_page.dart';
import 'package:lello/feature/maintenance_management/presentation/home/widgets/task_card/task_card_enum.dart';
import 'package:lello/feature/maintenance_management/presentation/home/widgets/task_summary/task_summary_model.dart';

import '../../../../helpers/pump_app.dart';

const _loc = {
  'task_type_routine': 'Rotina',
  'task_type_service_order': 'Ordem de serviço',
  'concluded': 'Concluída',
  'pending': 'Pendente',
  'task_status_in_progress': 'Em andamento',
};

FilterOptionsEntity _applied() {
  return FilterOptionsEntity(
    locals: [
      FilterLocalEntity(id: '1', name: 'Hall'),
      FilterLocalEntity(id: '2', name: 'Garagem'),
      FilterLocalEntity(id: '3', name: 'Piscina'),
      FilterLocalEntity(id: '4', name: 'Playground'),
      FilterLocalEntity(id: '5', name: 'Academia'),
    ],
    assets: [FilterAssetEntity(id: 'a1', name: 'Bomba')],
    responsibles: [
      FilterResponsibleEntity(id: 'r1', name: 'Ana'),
      FilterResponsibleEntity(id: 'r2', name: ''),
    ],
    employeeGroup: [FilterEmployeeGroupEntity(id: 'g1', name: 'Portaria')],
    taskType: [TaskType.routine],
    taskStatus: [TaskStatusType.pending, TaskStatusType.inProgress],
  );
}

void main() {
  testWidgets('golden — filtros vazios', (tester) async {
    await pumpApp(
      tester,
      const MaintenanceManagementFiltersPage(),
      wrapInScaffold: false,
      localized: true,
      locOverrides: _loc,
      surface: const Size(400, 900),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/mm_filters_page_empty.png'),
    );
  });

  testWidgets('golden — filtros aplicados com excesso de chips', (tester) async {
    final applied = _applied();
    await pumpApp(
      tester,
      MaintenanceManagementFiltersPage(
        filterOptions: applied,
        appliedFilters: applied,
      ),
      wrapInScaffold: false,
      localized: true,
      locOverrides: _loc,
      surface: const Size(400, 1100),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/mm_filters_page_applied.png'),
    );
  });
}
