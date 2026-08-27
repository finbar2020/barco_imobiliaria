import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_locked_days.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/page/vacation_page.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/widget/vacation_accordion_content.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/widget/vacation_schudeled_alert_dialog.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/widget/vacation_text_field_schudele.dart';

import '../../../helpers/pump_app.dart';
import 'vacation_test_helpers.dart';

void main() {
  group('VacationTextFieldSchudele', () {
    testWidgets('mostra o rótulo traduzido e a data como dica',
        (tester) async {
      await pumpApp(
          tester,
          const VacationTextFieldSchudele(
              date: '10/01/2030', text: 'gdp_vacation_employee_start'));

      expect(find.text('gdp_vacation_employee_start'), findsOneWidget);
      expect(find.text('10/01/2030'), findsOneWidget);
      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
      await expectLater(findGoldenSurface(),
          matchesGoldenFile('goldens/vacation_text_field_schedule.png'));
    });
  });

  group('VacationScheduledAlertDialog', () {
    testWidgets('mostra o aviso e fecha ao tocar em fechar', (tester) async {
      await pumpApp(
        tester,
        Builder(
          builder: (context) => TextButton(
            onPressed: () => showDialog(
                context: context,
                builder: (_) => const VacationScheduledAlertDialog()),
            child: const Text('abrir'),
          ),
        ),
      );

      await tester.tap(find.text('abrir'));
      await tester.pumpAndSettle();

      expect(find.text('chat_error_title!'), findsOneWidget);
      expect(find.text('gdp_vacation_scheduled_vacation_alert'), findsOneWidget);
      await expectLater(find.byType(VacationScheduledAlertDialog),
          matchesGoldenFile('goldens/vacation_scheduled_alert_dialog.png'));

      await tester.tap(find.text('CLOSE'));
      await tester.pumpAndSettle();
      expect(find.byType(VacationScheduledAlertDialog), findsNothing);
    });
  });

  group('AccordionSectionContent', () {
    late PeriodConfig config;
    late VacationLockedDays locked;

    setUp(() {
      config = PeriodConfig(days: 10);
      locked = VacationLockedDays();
    });

    Future<void> pumpContent(
      WidgetTester tester, {
      int periodNumber = 0,
      PeriodConfig? previous,
      DateTime? endDate,
      VacationLockedDays? lockedDays,
      int minFirstDate = 1,
      bool useLocked = true,
    }) async {
      await pumpApp(
        tester,
        AccordionSectionContent(
          periodConfig: config,
          periodConfigPrevious: previous,
          periodNumber: periodNumber,
          vacationEndDateFormatted: endDate ?? hoje,
          lockedDays: useLocked ? (lockedDays ?? locked) : null,
          minFirstDateFromToday: minFirstDate,
        ),
        surface: const Size(400, 700),
      );
    }

    Future<void> confirmarCalendario(WidgetTester tester) async {
      expect(find.text('OK'), findsOneWidget);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
    }

    testWidgets('mostra dias, dica de início e fim vazio', (tester) async {
      await pumpContent(tester);

      expect(find.text('gdp_vacation_employee_days'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);
      expect(find.text('gdp_vacation_employee_start'), findsOneWidget);
      /// Defeito: `PeriodConfig.getStartFormatted` devolve "" (nunca null)
      /// quando não há data, então a dica "selecione a data de início" nunca
      /// é exibida — o campo fica com a dica vazia.
      expect(find.text('gdp_vacation_employee_select_start_date'), findsNothing);
      expect(find.text('gdp_vacation_employee_end'), findsOneWidget);
      await expectLater(findGoldenSurface(),
          matchesGoldenFile('goldens/vacation_accordion_content.png'));
    });

    testWidgets('primeiro período: escolhe a primeira data livre',
        (tester) async {
      // hoje+2 e hoje+3 bloqueados -> sugere hoje+4.
      locked.locked_days = [
        yyyyMMdd(hoje.add(const Duration(days: 2))),
        yyyyMMdd(hoje.add(const Duration(days: 3))),
      ];
      await pumpContent(tester);

      await tester.tap(find.byType(TextFormField).first);
      await tester.pumpAndSettle();
      await confirmarCalendario(tester);

      final esperado = hoje.add(const Duration(days: 4));
      expect(config.start, esperado);
      expect(find.text(ddMMyyyy(esperado)), findsOneWidget);
      expect(find.text(ddMMyyyy(esperado.add(const Duration(days: 9)))),
          findsOneWidget);
      expect(find.text('validation_required'), findsNothing);
    });

    testWidgets('fechar o calendário sem escolher mantém vazio e valida',
        (tester) async {
      await pumpContent(tester, minFirstDate: 5);

      await tester.tap(find.byType(TextFormField).first);
      await tester.pumpAndSettle();
      // Cancelar do calendário (pt-BR).
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      expect(config.start, isNull);
      expect(find.text('validation_required'), findsOneWidget);
    });

    testWidgets('data inicial além do limite mostra o aviso e o dispensa',
        (tester) async {
      // Período aquisitivo terminou há mais de um ano: limite já passou.
      await pumpContent(tester,
          endDate: hoje.subtract(const Duration(days: 400)));

      await tester.tap(find.byType(TextFormField).first);
      await tester.pumpAndSettle();
      expect(find.text('OK'), findsNothing);
      expect(find.text('gdp_vacation_date_limit'), findsOneWidget);

      // Segunda tentativa dispensa o aviso anterior antes de mostrar outro.
      await tester.tap(find.byType(TextFormField).first);
      await tester.pumpAndSettle();
      expect(find.text('gdp_vacation_date_limit'), findsWidgets);

      await tester.tap(find.text('gdp_vacation_date_limit').last);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 31));
      await tester.pumpAndSettle();
      expect(config.start, isNull);
    });

    testWidgets('segundo período sem o primeiro preenchido avisa',
        (tester) async {
      await pumpContent(tester, periodNumber: 1, previous: PeriodConfig(days: 10));

      await tester.tap(find.byType(TextFormField).first);
      await tester.pumpAndSettle();

      expect(find.text('gdp_vacation_not_possible_assign_date'), findsOneWidget);
      expect(find.text('OK'), findsNothing);
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();
      expect(config.start, isNull);
    });

    testWidgets('segundo período começa depois do fim do primeiro',
        (tester) async {
      final previous =
          PeriodConfig(start: hoje.add(const Duration(days: 10)), days: 10);
      // O dia seguinte ao fim está bloqueado -> pula um dia.
      locked.locked_days = [yyyyMMdd(hoje.add(const Duration(days: 20)))];
      await pumpContent(tester, periodNumber: 1, previous: previous);

      await tester.tap(find.byType(TextFormField).first);
      await tester.pumpAndSettle();
      await confirmarCalendario(tester);

      expect(config.start, hoje.add(const Duration(days: 21)));
    });

    testWidgets('terceiro período: avisa sem o anterior e sugere depois dele',
        (tester) async {
      await pumpContent(tester, periodNumber: 2, previous: PeriodConfig(days: 5));
      await tester.tap(find.byType(TextFormField).first);
      await tester.pumpAndSettle();
      expect(find.text('gdp_vacation_not_possible_assign_date'), findsOneWidget);
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      final previous =
          PeriodConfig(start: hoje.add(const Duration(days: 30)), days: 5);
      config = PeriodConfig(days: 5);
      await pumpContent(tester, periodNumber: 2, previous: previous);
      await tester.tap(find.byType(TextFormField).first);
      await tester.pumpAndSettle();
      await confirmarCalendario(tester);
      expect(config.start, hoje.add(const Duration(days: 35)));
    });

    testWidgets('índice fora de 0..2 não abre calendário', (tester) async {
      await pumpContent(tester, periodNumber: 3);
      await tester.tap(find.byType(TextFormField).first);
      await tester.pumpAndSettle();
      expect(find.text('OK'), findsNothing);
      expect(config.start, isNull);
      expect(find.text('validation_required'), findsOneWidget);
    });

    // Defeito (não testável aqui): `selectableDayPredicate` faz
    // `lockedDays!` — com dias bloqueados nulos o `showDatePicker` lança um
    // erro de null dentro do `onTap` assíncrono do campo.
  });
}
