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
  testWidgets('fecha o modal de erro ao criar tarefa', (tester) async {
    var tried = false;
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          final theme = Theme.of(context);
          return TextButton(
            onPressed: () => CreateTaskErrorModal.show(
              context: context,
              theme: theme,
              palette: LelloTheme.palleteOf(theme),
              onTryAgain: () {
                tried = true;
                Navigator.of(context).pop();
              },
            ),
            child: const Text('Abrir'),
          );
        },
      ),
    );

    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    expect(find.text('Não foi possível criar a tarefa'), findsOneWidget);
    await tester.tap(find.text('Tentar novamente'));
    await tester.pumpAndSettle();
    expect(tried, isTrue);
    expect(find.text('Não foi possível criar a tarefa'), findsNothing);
  });

  testWidgets('confirma o descarte da etapa', (tester) async {
    var discarded = false;
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          return TextButton(
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (dialogContext) => InitStepDiscardDialog(
                  onConfirm: () {
                    discarded = true;
                    Navigator.pop(dialogContext);
                  },
                  onCancel: () => Navigator.pop(dialogContext),
                ),
              );
            },
            child: const Text('Abrir'),
          );
        },
      ),
    );

    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Descartar'));
    await tester.pumpAndSettle();
    expect(discarded, isTrue);
    expect(find.text('Descartar alterações?'), findsNothing);
  });

  testWidgets('cancela o descarte da etapa', (tester) async {
    var discarded = false;
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          return TextButton(
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (dialogContext) => InitStepDiscardDialog(
                  onConfirm: () {
                    discarded = true;
                    Navigator.pop(dialogContext);
                  },
                  onCancel: () => Navigator.pop(dialogContext),
                ),
              );
            },
            child: const Text('Abrir'),
          );
        },
      ),
    );

    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(discarded, isFalse);
    expect(find.text('Descartar alterações?'), findsNothing);
  });

  testWidgets('confirma o início da etapa', (tester) async {
    bool? started;
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          return TextButton(
            onPressed: () async {
              started = await TaskStartStepConfirmationModal.show(
                context: context,
                stepName: 'Checklist',
              );
            },
            child: const Text('Abrir'),
          );
        },
      ),
    );

    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sim, iniciar etapa agora'));
    await tester.pumpAndSettle();
    expect(started, isTrue);
  });

  testWidgets('cancela o início da etapa', (tester) async {
    bool? started;
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          return TextButton(
            onPressed: () async {
              started = await TaskStartStepConfirmationModal.show(
                context: context,
                stepName: 'Checklist',
              );
            },
            child: const Text('Abrir'),
          );
        },
      ),
    );

    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Não, voltar'));
    await tester.pumpAndSettle();
    expect(started, isFalse);
  });

  testWidgets('seleciona opções no sheet simples', (tester) async {
    Set<String>? selected;
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          return TextButton(
            onPressed: () async {
              selected = await showModalBottomSheet<Set<String>>(
                context: context,
                builder: (_) => const SelectionBottomSheet(
                  title: 'Status',
                  options: ['Pendente', 'Concluída'],
                  selectedItems: {'Pendente'},
                ),
              );
            },
            child: const Text('Abrir'),
          );
        },
      ),
      shrinkWrap: false,
      surface: const Size(400, 500),
    );

    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Concluída'));
    await tester.pump();
    await tester.tap(find.text('Pendente'));
    await tester.pump();
    await tester.tap(find.text('Selecionar'));
    await tester.pumpAndSettle();
    expect(selected, {'Concluída'});
  });

  testWidgets('filtra e seleciona ambiente', (tester) async {
    final hall = FilterLocalEntity(id: '1', name: 'Hall');
    final garage = FilterLocalEntity(id: '2', name: 'Garagem');
    Set<FilterLocalEntity>? selected;
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          return TextButton(
            onPressed: () async {
              selected = await showModalBottomSheet<Set<FilterLocalEntity>>(
                context: context,
                builder: (_) => EnvironmentBottomSheet(
                  options: [hall, garage],
                  selectedItems: {hall},
                ),
              );
            },
            child: const Text('Abrir'),
          );
        },
      ),
      shrinkWrap: false,
      surface: const Size(400, 560),
    );

    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'gara');
    await tester.pump();
    expect(find.text('Hall'), findsNothing);
    await tester.tap(find.text('Garagem'));
    await tester.pump();
    await tester.tap(find.text('Selecionar'));
    await tester.pumpAndSettle();
    expect(selected, contains(garage));
  });

  testWidgets('filtra equipamento e grupo', (tester) async {
    await pumpApp(
      tester,
      Material(
        child: AssetBottomSheet(
          options: [
            FilterAssetEntity(id: '1', name: 'Elevador'),
            FilterAssetEntity(id: '2', name: 'Portão'),
          ],
          selectedItems: const {},
        ),
      ),
      shrinkWrap: false,
      surface: const Size(400, 480),
    );

    await tester.enterText(find.byType(TextField), 'port');
    await tester.pump();
    expect(find.text('Elevador'), findsNothing);
    await tester.tap(find.text('Portão'));
    await tester.pump();
    expect(find.byType(CheckboxListTile), findsOneWidget);
  });

  testWidgets('adiciona responsável e grupo de funcionários', (tester) async {
    await pumpApp(
      tester,
      Material(
        child: ResponsibleBottomSheet(
          options: [FilterResponsibleEntity(id: '1', name: 'Ana Silva')],
          selectedItems: const {},
        ),
      ),
      shrinkWrap: false,
      surface: const Size(400, 500),
    );

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(find.byIcon(Icons.close), findsOneWidget);
    await tester.tap(find.byIcon(Icons.close));
    await tester.pump();
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('filtra grupo de funcionários', (tester) async {
    await pumpApp(
      tester,
      Material(
        child: EmployeeGroupBottomSheet(
          options: [
            FilterEmployeeGroupEntity(id: '1', name: 'Zeladoria'),
            FilterEmployeeGroupEntity(id: '2', name: 'Portaria'),
          ],
          selectedItems: const {},
        ),
      ),
      shrinkWrap: false,
      surface: const Size(400, 480),
    );

    await tester.enterText(find.byType(TextField), 'porta');
    await tester.pump();
    expect(find.text('Zeladoria'), findsNothing);
    await tester.tap(find.text('Portaria'));
    await tester.pump();
    expect(find.byType(CheckboxListTile), findsOneWidget);
  });
}
