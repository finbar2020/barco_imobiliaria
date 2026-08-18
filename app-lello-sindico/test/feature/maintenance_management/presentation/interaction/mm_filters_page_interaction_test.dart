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

FilterOptionsEntity _options() {
  return FilterOptionsEntity(
    locals: [FilterLocalEntity(id: '1', name: 'Hall')],
    assets: [FilterAssetEntity(id: 'a1', name: 'Bomba')],
    responsibles: [FilterResponsibleEntity(id: 'r1', name: 'Ana')],
    employeeGroup: [FilterEmployeeGroupEntity(id: 'g1', name: 'Portaria')],
    taskType: const [],
    taskStatus: const [],
  );
}

Future<void> _openFilters(
  WidgetTester tester, {
  FilterOptionsEntity? filterOptions,
  FilterOptionsEntity? appliedFilters,
}) async {
  await pumpApp(
    tester,
    Builder(
      builder: (context) {
        return TextButton(
          onPressed: () {
            Navigator.of(context).push<FilterOptionsEntity>(
              MaterialPageRoute(
                builder: (_) => MaintenanceManagementFiltersPage(
                  filterOptions: filterOptions,
                  appliedFilters: appliedFilters,
                ),
              ),
            );
          },
          child: const Text('Abrir'),
        );
      },
    ),
    localized: true,
    locOverrides: _loc,
    surface: const Size(400, 900),
    shrinkWrap: false,
  );
  await tester.tap(find.text('Abrir'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('alterna tipo e status, limpa e busca', (tester) async {
    await _openFilters(tester);

    await tester.tap(find.text('Rotina'));
    await tester.pump();
    await tester.tap(find.text('Pendente'));
    await tester.pump();
    await tester.tap(find.text('Rotina'));
    await tester.pump();

    await tester.tap(find.text('Limpar filtro'));
    await tester.pump();

    await tester.tap(find.text('Em andamento'));
    await tester.pump();
    await tester.tap(find.text('Buscar'));
    await tester.pumpAndSettle();
    expect(find.text('Filtro'), findsNothing);
  });

  testWidgets('descarta alterações ao voltar', (tester) async {
    await _openFilters(tester);
    await tester.tap(find.text('Ordem de serviço'));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.text('Descartar alterações?'), findsOneWidget);

    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(find.text('Filtro'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Descartar'));
    await tester.pumpAndSettle();
    expect(find.text('Filtro'), findsNothing);
  });

  testWidgets('volta sem alterações e abre sheet de ambiente', (tester) async {
    await _openFilters(tester, filterOptions: _options());

    await tester.tap(find.text('Selecione').first);
    await tester.pumpAndSettle();
    expect(find.text('Por ambiente'), findsWidgets);

    await tester.tap(find.text('Hall'));
    await tester.pump();
    await tester.tap(find.text('Selecionar'));
    await tester.pumpAndSettle();
    expect(find.text('1 selecionado(s)'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close).first);
    await tester.pump();
    expect(find.text('1 selecionado(s)'), findsNothing);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Descartar'));
    await tester.pumpAndSettle();
    expect(find.text('Filtro'), findsNothing);
  });

  testWidgets('aplica filtros já selecionados e remove responsável',
      (tester) async {
    final hall = FilterLocalEntity(id: '1', name: 'Hall');
    final ana = FilterResponsibleEntity(id: 'r1', name: 'Ana');
    final applied = FilterOptionsEntity(
      locals: [hall],
      assets: const [],
      responsibles: [ana],
      employeeGroup: const [],
      taskType: [TaskType.routine],
      taskStatus: [TaskStatusType.completed],
    );
    await _openFilters(
      tester,
      filterOptions: applied,
      appliedFilters: applied,
    );

    expect(find.text('Ana'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.close).last);
    await tester.pump();
    expect(find.text('Ana'), findsNothing);

    await tester.tap(find.text('Buscar'));
    await tester.pumpAndSettle();
    expect(find.text('Filtro'), findsNothing);
  });

  testWidgets('limpa os filtros e volta aplicando a limpeza', (tester) async {
    await _openFilters(tester);
    await tester.tap(find.text('Rotina'));
    await tester.pump();
    await tester.tap(find.text('Limpar filtro'));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.text('Filtro'), findsNothing);
  });

  testWidgets('abre sheets de equipamento, grupo e responsável', (tester) async {
    await _openFilters(tester, filterOptions: _options());

    await tester.ensureVisible(find.text('Por equipamento'));
    await tester.tap(find.text('Selecione').at(1));
    await tester.pumpAndSettle();
    expect(find.text('Por equipamento'), findsWidgets);
    await tester.tap(find.text('Bomba'));
    await tester.pump();
    await tester.tap(find.text('Selecionar'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Por grupo de funcionários'));
    await tester.tap(find.text('Selecione').at(1));
    await tester.pumpAndSettle();
    expect(find.text('Por grupo de funcionários'), findsWidgets);
    await tester.tap(find.text('Portaria'));
    await tester.pump();
    await tester.tap(find.text('Selecionar'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Por Responsável'));
    await tester.tap(find.text('Selecione').last);
    await tester.pumpAndSettle();
    expect(find.text('Por Responsável'), findsWidgets);
    await tester.tap(find.widgetWithIcon(IconButton, Icons.add));
    await tester.pump();
    await tester.tap(find.text('Selecionar'));
    await tester.pumpAndSettle();

    expect(find.text('Ana'), findsOneWidget);
    await tester.tap(find.text('Concluída'));
    await tester.pump();
    await tester.tap(find.text('Concluída'));
    await tester.pump();
    await tester.tap(find.text('Buscar'));
    await tester.pumpAndSettle();
    expect(find.text('Filtro'), findsNothing);
  });
}
