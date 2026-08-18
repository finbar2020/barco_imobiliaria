import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/presentation/agenda/widgets/schedule_events_summary/schedule_events_summary_model.dart';

import '../../../helpers/pump_app.dart';

void main() {
  testWidgets('name, statusLabel e color cobrem os três status', (tester) async {
    Color? done;
    Color? pending;
    Color? draft;
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          final theme = Theme.of(context);
          expect(ScheduleEventStatusType.done.name(context), 'Concluída');
          expect(ScheduleEventStatusType.notStarted.name(context), 'Não iniciada');
          expect(
            ScheduleEventStatusType.draft.name(context),
            'Em andamento',
          );
          expect(
            ScheduleEventStatusType.done.statusLabel(context),
            'Concluída',
          );
          expect(
            ScheduleEventStatusType.notStarted.statusLabel(context),
            'Pendente',
          );
          expect(
            ScheduleEventStatusType.draft.statusLabel(context),
            'Em andamento',
          );
          done = ScheduleEventStatusType.done.color(theme);
          pending = ScheduleEventStatusType.notStarted.color(theme);
          draft = ScheduleEventStatusType.draft.color(theme);
          return const SizedBox.shrink();
        },
      ),
      localized: true,
      locOverrides: const {
        'concluded': 'Concluída',
        'not_started': 'Não iniciada',
        'task_status_in_progress': 'Em andamento',
        'task_status_completed': 'Concluída',
        'task_status_pending': 'Pendente',
      },
    );
    expect(done, isNotNull);
    expect(pending, isNot(done));
    expect(draft, isNot(done));
  });
}
