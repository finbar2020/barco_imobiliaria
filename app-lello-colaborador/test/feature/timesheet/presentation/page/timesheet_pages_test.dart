import 'dart:async';

import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_element_detail.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_periods.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_point_flag_enum.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_detail_page/bloc/timesheet_detail_bloc.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_detail_page/bloc/timesheet_detail_state.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_detail_page/page/timesheet_detail_page.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_detail_page/widget/timesheet_detail_list_widget.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_page/bloc/timesheet_bloc.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_page/bloc/timesheet_state.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_page/page/timesheet_page.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_page/widget/timesheet_page_body_widget.dart';
import 'package:essentials/essentials.dart';
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

class _FakeTimesheetBloc extends Fake implements TimesheetBloc {
  _FakeTimesheetBloc(this._state);

  final TimesheetState _state;
  final _controller = StreamController<TimesheetState>.broadcast();
  int periodsRequested = 0;

  @override
  List<DateTime> availableDates = [DateTime(2026, 1, 1)];

  @override
  List<TimesheetPeriods> timesheetPeriods = [_period];

  @override
  TimesheetState get state => _state;

  @override
  Stream<TimesheetState> get stream => _controller.stream;

  @override
  void getTimesheetPeriods() => periodsRequested++;

  @override
  void getTimesheet({required DateTime period}) {}

  /// O TimesheetPageBody registra o bloc num BlocProvider, que chama close()
  /// ao desmontar a árvore.
  @override
  Future<void> close() async {}

  Future<void> dispose() => _controller.close();
}

class _FakeTimesheetDetailBloc extends Fake implements TimesheetDetailBloc {
  _FakeTimesheetDetailBloc(this._state);

  final TimesheetDetailState _state;
  final _controller = StreamController<TimesheetDetailState>.broadcast();
  DateTime? requestedPeriod;

  @override
  TimesheetDetailState get state => _state;

  @override
  Stream<TimesheetDetailState> get stream => _controller.stream;

  @override
  void getTimesheetDetail({required DateTime period}) =>
      requestedPeriod = period;

  Future<void> dispose() => _controller.close();
}

Future<void> _installBase() async {
  final locator = ApplicationContainer.instance().locator;
  if (locator.isRegistered<Environment>()) {
    await locator.reset(dispose: true);
  }
  locator.registerSingleton<Environment>(TestEnvironment());
  locator.registerSingleton<SessionBloc>(FakeSessionBloc());
}

Future<void> _pumpPage(
  WidgetTester tester,
  Widget page, {
  Object? args,
}) async {
  await pumpApp(
    tester,
    Navigator(
      onGenerateRoute: (settings) => MaterialPageRoute(
        settings: RouteSettings(name: settings.name, arguments: args),
        builder: (_) => page,
      ),
    ),
    localized: true,
    wrapInScaffold: false,
    shrinkWrap: false,
    settle: false,
    surface: const Size(500, 1000),
  );
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  setUp(_installBase);
  tearDown(resetTestApplicationContainer);

  group('TimesheetPage', () {
    late _FakeTimesheetBloc bloc;

    Future<void> install(TimesheetState state) async {
      bloc = _FakeTimesheetBloc(state);
      addTearDown(bloc.dispose);
      ApplicationContainer.instance()
          .locator
          .registerSingleton<TimesheetBloc>(bloc);
    }

    testWidgets('buscando períodos mostra o loading', (tester) async {
      await install(const TimesheetPeriodsLoadingState());
      await _pumpPage(tester, const TimesheetPage());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('sem períodos avisa que não há folhas', (tester) async {
      await install(const TimesheetPeriodsEmptyState());
      await _pumpPage(tester, const TimesheetPage());

      expect(find.text('timesheet_page_get_periods_empty'), findsOneWidget);
    });

    testWidgets('falha permite tentar novamente', (tester) async {
      await install(
        const TimesheetPeriodsFailedState(
          errorCode: '500',
          errorDescription: 'erro',
        ),
      );
      await _pumpPage(tester, const TimesheetPage());

      expect(find.text('error_handling_widget_title'), findsOneWidget);

      await tester.tap(find.text('error_handling_widget_button_reTry'));
      await tester.pump();

      expect(bloc.periodsRequested, 1);
    });

    testWidgets('períodos carregados montam o corpo da folha', (tester) async {
      await install(TimesheetPeriodsLoadedState(timesheetPeriods: [_period]));
      await _pumpPage(tester, const TimesheetPage());

      expect(find.byType(TimesheetPageBody), findsOneWidget);
    });
  });

  group('TimesheetDetailPage', () {
    late _FakeTimesheetDetailBloc bloc;

    Future<void> install(TimesheetDetailState state) async {
      bloc = _FakeTimesheetDetailBloc(state);
      addTearDown(bloc.dispose);
      ApplicationContainer.instance()
          .locator
          .registerSingleton<TimesheetDetailBloc>(bloc);
    }

    testWidgets('busca as tratativas do período recebido', (tester) async {
      await install(const TimesheetDetailLoadingState());
      await _pumpPage(
        tester,
        const TimesheetDetailPage(),
        args: TimesheetDetailPageArgs(period: DateTime(2026, 1, 31)),
      );

      expect(bloc.requestedPeriod, DateTime(2026, 1, 31));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('tratativas carregadas montam a lista', (tester) async {
      await install(
        TimesheetDetailLoadedState(
          timesheetDetail: {
            DateTime(2026, 1, 10): [
              TimesheetElementDetail(
                time: '08:00',
                timesheetFlag: TimesheetPointFlagEnum.inserted,
                date: DateTime(2026, 1, 10),
              ),
            ],
          },
        ),
      );
      await _pumpPage(
        tester,
        const TimesheetDetailPage(),
        args: TimesheetDetailPageArgs(period: DateTime(2026, 1, 31)),
      );

      expect(find.byType(TimesheetDetailListWidget), findsOneWidget);
      expect(find.text('08:00'), findsOneWidget);
      expect(find.text('timesheet_detail_back'), findsOneWidget);
    });

    testWidgets('falha exibe o tratamento de erro', (tester) async {
      await install(
        TimesheetDetailFailedState(failure: KnownFailure('500', 'erro')),
      );
      await _pumpPage(
        tester,
        const TimesheetDetailPage(),
        args: TimesheetDetailPageArgs(period: DateTime(2026, 1, 31)),
      );

      expect(find.byType(TimesheetDetailListWidget), findsNothing);
    });
  });
}
