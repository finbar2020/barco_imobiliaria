import 'package:essentials/ui/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/domain/entity/filter_options_entity.dart';
import 'package:lello/feature/maintenance_management/presentation/create_task/widgets/create_task_error_modal.dart';
import 'package:lello/feature/maintenance_management/presentation/home/widgets/filters/asset_bottom_sheet.dart';
import 'package:lello/feature/maintenance_management/presentation/home/widgets/filters/employee_group_bottom_sheet.dart';
import 'package:lello/feature/maintenance_management/presentation/home/widgets/filters/environment_bottom_sheet.dart';
import 'package:lello/feature/maintenance_management/presentation/home/widgets/filters/responsible_bottom_sheet.dart';
import 'package:lello/feature/maintenance_management/presentation/home/widgets/filters/selection_bottom_sheet.dart';
import 'package:lello/feature/maintenance_management/presentation/task/pages/init_step/widgets/init_step_discard_dialog.dart';
import 'package:lello/feature/maintenance_management/presentation/task/pages/task_start_step_confirmation_modal.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('golden — modal de erro ao criar tarefa', (tester) async {
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          final theme = Theme.of(context);
          return CreateTaskErrorModal(
            theme: theme,
            palette: LelloTheme.palleteOf(theme),
            onTryAgain: () {},
          );
        },
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/create_task_error_modal.png'),
    );
  });

  testWidgets('golden — diálogo para descartar etapa', (tester) async {
    await pumpApp(
      tester,
      InitStepDiscardDialog(onConfirm: () {}, onCancel: () {}),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/init_step_discard_dialog.png'),
    );
  });

  testWidgets('golden — confirmação de início de etapa', (tester) async {
    await pumpApp(
      tester,
      const TaskStartStepConfirmationModal(stepName: 'Checklist'),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/task_start_step_confirmation.png'),
    );
  });

  testWidgets('golden — sheet de seleção simples', (tester) async {
    await pumpApp(
      tester,
      const Material(
        child: SelectionBottomSheet(
          title: 'Status',
          options: ['Pendente', 'Concluída'],
          selectedItems: {'Pendente'},
        ),
      ),
      shrinkWrap: false,
      surface: const Size(400, 420),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/selection_bottom_sheet.png'),
    );
  });

  testWidgets('golden — sheet de ambiente', (tester) async {
    final hall = FilterLocalEntity(id: '1', name: 'Hall');
    await pumpApp(
      tester,
      Material(
        child: EnvironmentBottomSheet(
          options: [hall, FilterLocalEntity(id: '2', name: 'Garagem')],
          selectedItems: {hall},
        ),
      ),
      shrinkWrap: false,
      surface: const Size(400, 480),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/environment_bottom_sheet.png'),
    );
  });

  testWidgets('golden — sheet de equipamento', (tester) async {
    await pumpApp(
      tester,
      Material(
        child: AssetBottomSheet(
          options: [FilterAssetEntity(id: '1', name: 'Elevador')],
          selectedItems: const {},
        ),
      ),
      shrinkWrap: false,
      surface: const Size(400, 420),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/asset_bottom_sheet.png'),
    );
  });

  testWidgets('golden — sheet de grupo de funcionários', (tester) async {
    await pumpApp(
      tester,
      Material(
        child: EmployeeGroupBottomSheet(
          options: [FilterEmployeeGroupEntity(id: '1', name: 'Zeladoria')],
          selectedItems: const {},
        ),
      ),
      shrinkWrap: false,
      surface: const Size(400, 420),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/employee_group_bottom_sheet.png'),
    );
  });

  testWidgets('golden — sheet de responsável', (tester) async {
    await pumpApp(
      tester,
      Material(
        child: ResponsibleBottomSheet(
          options: [FilterResponsibleEntity(id: '1', name: 'Ana Silva')],
          selectedItems: const {},
        ),
      ),
      shrinkWrap: false,
      surface: const Size(400, 460),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/responsible_bottom_sheet.png'),
    );
  });
}
