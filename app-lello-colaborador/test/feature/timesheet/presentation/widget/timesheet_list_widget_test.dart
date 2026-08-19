import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/core/navigation/application_route.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_element.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_status_enum.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_page/widget/timesheet_list_widget.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_application_container.dart';

Future<void> _installContainer() async {
  final locator = ApplicationContainer.instance().locator;
  if (locator.isRegistered<Environment>()) {
    await locator.reset(dispose: true);
  }
  locator.registerSingleton<Environment>(TestEnvironment());
  locator.registerSingleton<SessionBloc>(FakeSessionBloc());
}

TimesheetElement _element({
  required int day,
  List<String> times = const ['08:00', '12:00'],
  String journey = '08:00',
  bool hasTreatment = false,
  bool dayOff = false,
}) =>
    TimesheetElement(
      date: DateTime(2026, 1, day),
      times: times,
      journey: journey,
      hasTreatment: hasTreatment,
      dayOff: dayOff,
    );

Timesheet _timesheet(List<TimesheetElement> elements) => Timesheet(
      dateFrom: DateTime(2026, 1, 1),
      dateTo: DateTime(2026, 1, 31),
      timesheetStatus: TimesheetStatusEnum.notAssigned,
      timesheetElements: elements,
    );

Future<void> _pump(WidgetTester tester, Timesheet timesheet) => pumpApp(
      tester,
      SingleChildScrollView(child: TimesheetListWidget(timesheet: timesheet)),
      localized: true,
      shrinkWrap: false,
      surface: const Size(500, 800),
    );

void main() {
  setUp(_installContainer);
  tearDown(resetTestApplicationContainer);

  group('TimesheetListWidget', () {
    testWidgets('exibe cabeçalho e os dias da folha', (tester) async {
      await _pump(
        tester,
        _timesheet([_element(day: 10), _element(day: 11)]),
      );

      expect(find.text('timesheet_page_date'), findsOneWidget);
      expect(find.text('timesheet_page_points'), findsOneWidget);
      expect(find.text('timesheet_page_journey'), findsOneWidget);
      expect(find.text('10/01'), findsOneWidget);
      expect(find.text('11/01'), findsOneWidget);
      expect(find.text('08:00 - 12:00'), findsNWidgets(2));
    });

    testWidgets('exibe mensagem quando não há dias na folha', (tester) async {
      await _pump(tester, _timesheet(const []));

      expect(find.text('timesheet_page_empty'), findsOneWidget);
      expect(find.text('timesheet_page_date'), findsNothing);
    });

    testWidgets('exibe folga no lugar das batidas', (tester) async {
      await _pump(
        tester,
        _timesheet([_element(day: 12, times: const [], dayOff: true)]),
      );

      expect(find.text('timesheet_day_off'), findsOneWidget);
    });

    testWidgets('exibe traço quando o dia não tem batidas', (tester) async {
      await _pump(
        tester,
        _timesheet([_element(day: 13, times: const [])]),
      );

      expect(find.text(' - '), findsOneWidget);
    });

    testWidgets('marca com seta apenas os dias com tratativa', (tester) async {
      await _pump(
        tester,
        _timesheet([
          _element(day: 14, hasTreatment: true),
          _element(day: 15),
        ]),
      );

      expect(find.byIcon(Icons.keyboard_arrow_right), findsOneWidget);
    });

    testWidgets('dia sem tratativa não navega para o detalhe', (tester) async {
      final routes = <String>[];
      await pumpApp(
        tester,
        Navigator(
          onGenerateRoute: (settings) {
            routes.add(settings.name ?? '');
            return MaterialPageRoute(
              builder: (_) => TimesheetListWidget(
                timesheet: _timesheet([_element(day: 16)]),
              ),
            );
          },
        ),
        localized: true,
        shrinkWrap: false,
        surface: const Size(500, 800),
      );

      await tester.tap(find.text('16/01'));
      await tester.pumpAndSettle();

      expect(routes, isNot(contains(ApplicationRoute.timesheetDetail)));
    });

    testWidgets('dia com tratativa navega para o detalhe', (tester) async {
      final routes = <String>[];
      await pumpApp(
        tester,
        Navigator(
          onGenerateRoute: (settings) {
            routes.add(settings.name ?? '');
            return MaterialPageRoute(
              builder: (_) => settings.name == ApplicationRoute.timesheetDetail
                  ? const SizedBox()
                  : TimesheetListWidget(
                      timesheet: _timesheet(
                        [_element(day: 17, hasTreatment: true)],
                      ),
                    ),
            );
          },
        ),
        localized: true,
        shrinkWrap: false,
        surface: const Size(500, 800),
      );

      await tester.tap(find.text('17/01'));
      await tester.pumpAndSettle();

      expect(routes, contains(ApplicationRoute.timesheetDetail));
    });
  });
}
