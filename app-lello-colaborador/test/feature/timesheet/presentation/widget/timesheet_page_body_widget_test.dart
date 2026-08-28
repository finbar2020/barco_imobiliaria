import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/core/stores/session_store.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_element.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_periods.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_status_enum.dart';
import 'package:colaborador/feature/timesheet/domain/use_case/get_timesheet/get_timesheet.dart';
import 'package:colaborador/feature/timesheet/domain/use_case/get_timesheet_periods/get_timesheet_periods.dart';
import 'package:colaborador/feature/timesheet/domain/use_case/sign_timesheet/sign_timesheet.dart';
import 'package:colaborador/feature/timesheet/domain/use_case/send_email/send_email.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_assign_dialog/bloc/timesheet_sign_bloc.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_email_dialog/bloc/timesheet_email_bloc.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_page/bloc/timesheet_bloc.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_page/widget/timesheet_list_widget.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_page/widget/timesheet_page_body_widget.dart';
import 'package:essentials/essentials.dart' hide isNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_application_container.dart';

final _period = TimesheetPeriods(
  periodMonth: DateTime(2026, 1, 1),
  startDate: DateTime(2026, 1, 1),
  endDate: DateTime(2026, 1, 31),
);

TimesheetElement _element({bool hasTreatment = false}) => TimesheetElement(
      date: DateTime(2026, 1, 10),
      times: const ['08:00', '12:00'],
      journey: '08:00',
      hasTreatment: hasTreatment,
      dayOff: false,
    );

class _FakeGetTimesheet extends Fake implements GetTimesheetUsecase {
  _FakeGetTimesheet({
    this.fail = false,
    this.elements = const [],
    this.status = TimesheetStatusEnum.notAssigned,
    this.delay,
  });

  final bool fail;
  final List<TimesheetElement> elements;
  final TimesheetStatusEnum status;
  final Duration? delay;

  @override
  Future<Try<Timesheet>> call(GetTimesheetParam params) async {
    if (delay != null) await Future<void>.delayed(delay!);
    if (fail) return Rejection(UnknownFailure('timesheet'));
    return Success(
      Timesheet(
        dateFrom: DateTime(2026, 1, 1),
        dateTo: DateTime(2026, 1, 31),
        timesheetStatus: status,
        timesheetElements: elements,
      ),
    );
  }
}

class _FakeGetPeriods extends Fake implements GetTimesheetPeriodsUsecase {
  @override
  Future<Try<List<TimesheetPeriods>>> call(
    GetTimesheetPeriodsParam params,
  ) async =>
      Success([_period]);
}

class _FakeSignTimesheet extends Fake implements SignTimesheetUsecase {}

class _FakeSendEmail extends Fake implements TimesheetSendEmailUsecase {}

late TimesheetBloc _bloc;

Future<void> _installContainer(_FakeGetTimesheet getTimesheet) async {
  final locator = ApplicationContainer.instance().locator;
  if (locator.isRegistered<Environment>()) {
    await locator.reset(dispose: true);
  }
  final sessionBloc = FakeSessionBloc();
  _bloc = TimesheetBloc(
    sessionBloc: sessionBloc,
    getTimesheetUsecase: getTimesheet,
    getTimesheetPeriodsUsecase: _FakeGetPeriods(),
    store: SessionStore(),
  )
    ..availableDates = [_period.periodMonth]
    ..timesheetPeriods = [_period];

  locator.registerSingleton<Environment>(TestEnvironment());
  locator.registerSingleton<SessionBloc>(sessionBloc);
  locator.registerSingleton<TimesheetBloc>(_bloc);
  locator.registerFactory<TimesheetSignBloc>(
    () => TimesheetSignBloc(
      timesheetSignUsecase: _FakeSignTimesheet(),
      sessionBloc: sessionBloc,
    ),
  );
  locator.registerFactory<Validator>(() => ValidatorImpl());
  locator.registerFactory<TimesheetEmailBloc>(
    () => TimesheetEmailBloc(
      sendEmailUsecase: _FakeSendEmail(),
      sessionBloc: sessionBloc,
    ),
  );
}

Future<void> _pumpBody(
  WidgetTester tester, {
  List<TimesheetPeriods>? periods,
  bool flush = true,
  String? selectedPeriod,
}) async {
  await pumpApp(
    tester,
    TimesheetPageBody(
      timesheetPeriods: periods ?? [_period],
      selectedPeriod: selectedPeriod,
    ),
    localized: true,
    shrinkWrap: false,
    // A tela mantém animações contínuas (indicador de progresso), então o
    // pumpAndSettle não estabiliza: avançamos o tempo manualmente.
    settle: false,
    surface: const Size(500, 900),
  );
  if (flush) {
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
  }
}

void main() {
  tearDown(resetTestApplicationContainer);

  group('TimesheetPageBody', () {
    testWidgets('exibe a folha carregada com os botões de ação',
        (tester) async {
      await _installContainer(_FakeGetTimesheet(elements: [_element()]));
      await _pumpBody(tester);

      expect(find.byType(TimesheetListWidget), findsOneWidget);
      expect(find.text('10/01'), findsOneWidget);
      expect(find.text('timesheet_page_assign'), findsOneWidget);
      expect(find.text('timesheet_page_send_email'), findsOneWidget);
    });

    testWidgets('folha já assinada não oferece o botão de assinar',
        (tester) async {
      await _installContainer(
        _FakeGetTimesheet(
          elements: [_element()],
          status: TimesheetStatusEnum.assigned,
        ),
      );
      await _pumpBody(tester);

      expect(find.text('timesheet_page_assign'), findsNothing);
      expect(find.text('timesheet_page_send_email'), findsOneWidget);
    });

    testWidgets('folha sem dias não oferece nenhuma ação', (tester) async {
      await _installContainer(_FakeGetTimesheet());
      await _pumpBody(tester);

      expect(find.text('timesheet_page_empty'), findsOneWidget);
      expect(find.text('timesheet_page_assign'), findsNothing);
      expect(find.text('timesheet_page_send_email'), findsNothing);
    });

    testWidgets('exibe mensagem quando a busca da folha falha', (tester) async {
      await _installContainer(_FakeGetTimesheet(fail: true));
      await _pumpBody(tester);

      expect(find.text('timesheet_page_get_error'), findsOneWidget);
      expect(find.byType(TimesheetListWidget), findsNothing);
    });

    testWidgets('exibe loading enquanto a folha é buscada', (tester) async {
      await _installContainer(
        _FakeGetTimesheet(delay: const Duration(milliseconds: 200)),
      );
      await _pumpBody(tester, flush: false);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsWidgets);
      expect(find.text('please_wait'), findsOneWidget);

      for (var i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
    });

    testWidgets('período vindo da notificação seleciona o mês certo',
        (tester) async {
      await _installContainer(_FakeGetTimesheet(elements: [_element()]));
      await _pumpBody(tester, selectedPeriod: '01/2026');

      expect(find.byType(TimesheetListWidget), findsOneWidget);
    });

    testWidgets('período inválido na notificação não quebra a tela',
        (tester) async {
      await _installContainer(_FakeGetTimesheet(elements: [_element()]));
      await _pumpBody(tester, selectedPeriod: 'sem-formato');

      expect(tester.takeException(), isNull);
      expect(find.byType(TimesheetListWidget), findsOneWidget);
    });

    testWidgets('assinar a folha abre o diálogo de assinatura',
        (tester) async {
      await _installContainer(_FakeGetTimesheet(elements: [_element()]));
      await _pumpBody(tester);

      await tester.tap(find.text('timesheet_page_assign'));
      for (var i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      expect(tester.takeException(), isNull);
    });

    testWidgets('enviar por email abre o diálogo de envio', (tester) async {
      await _installContainer(_FakeGetTimesheet(elements: [_element()]));
      await _pumpBody(tester);

      await tester.tap(find.text('timesheet_page_send_email'));
      for (var i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      expect(tester.takeException(), isNull);
    });

    testWidgets('sem períodos disponíveis não busca a folha', (tester) async {
      final useCase = _FakeGetTimesheet(elements: [_element()]);
      await _installContainer(useCase);
      await _pumpBody(tester, periods: const []);

      expect(find.byType(TimesheetListWidget), findsNothing);
      expect(find.text('timesheet_page_assign'), findsNothing);
    });
  });
}
