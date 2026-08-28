import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/bloc/timesheet_menu/timesheet_menu_bloc.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/bloc/timesheet_menu/timesheet_menu_state.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/page/timesheet_not_allowed_warning.dart';
import 'package:shared_features/shared_features.dart' hide isNull, isNotNull;

import '../../../helpers/pump_app.dart';
import '../../../helpers/test_container.dart';
import 'timesheet_test_helpers.dart';

void main() {
  late TimesheetStack stack;
  late TestSharedContainer container;
  late RecordingNavigatorObserver observer;
  final session = FakeSharedSession();

  setUp(() {
    stack = TimesheetStack();
    observer = RecordingNavigatorObserver();
    container = TestSharedContainer()
      ..registerLazy<TimesheetMenuBloc>(() => stack.menuBloc(session: session));
  });

  tearDown(() => container.reset());

  TimesheetMenuBloc bloc() => container.resolve<TimesheetMenuBloc>();

  testWidgets('mostra o carregamento e depois o aviso com os botões',
      (tester) async {
    stack.happyPath();
    stack.http.on('GET', '/timesheet/employees/C1', body: []);
    await pumpPage(tester, TimesheetNotAllowedWarning(appContainer: container),
        observer: observer, settle: false);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();
    expect(bloc().state, isA<TimesheetMenuWarningState>());
    expect(find.text('gdp_timesheet_warning_title'), findsOneWidget);
    expect(find.text('gdp_timesheet_warning_subtitle'), findsOneWidget);
    expect(find.text('Solicite o Ponto Digital'), findsOneWidget);
    expect(find.text('back'), findsOneWidget);
    expect(TimesheetNotAllowedWarningArgs(bloc()).timesheetMenuBloc,
        same(bloc()));

    await expectLater(find.byType(MaterialApp),
        matchesGoldenFile('goldens/timesheet_not_allowed_warning.png'));

    await tester.tap(find.text('back'));
    await tester.pumpAndSettle();
    expect(observer.popped, isNotEmpty);
  });

  testWidgets('solicitar o ponto digital vai para a tela de email enviado',
      (tester) async {
    stack.happyPath();
    await pumpPage(tester, TimesheetNotAllowedWarning(appContainer: container),
        observer: observer);

    await tester.tap(find.text('Solicite o Ponto Digital'));
    await tester.pumpAndSettle();

    expect(bloc().state, isA<TimesheetRequestLoadedState>());
    expect(stack.http.requests.last.url.path, '/timesheet/request/C1');
    expect(findRoute(SharedApplicationRoute.gdpTimesheetRequestSuccess),
        findsOneWidget);
    expect(find.byType(TimesheetNotAllowedWarning), findsNothing);
  });

  testWidgets('erro ao solicitar mostra a mensagem e mantém o botão',
      (tester) async {
    stack.happyPath();
    stack.http.on('POST', '/timesheet/request/C1', status: 500);
    await pumpPage(tester, TimesheetNotAllowedWarning(appContainer: container),
        observer: observer);

    await tester.tap(find.text('Solicite o Ponto Digital'));
    await tester.pumpAndSettle();
    expect(bloc().state, isA<TimesheetRequestLoadFailedState>());
    expect(
        find.text(
            'Ocorreu um erro ao enviar o email, tente novamente mais tarde'),
        findsOneWidget);
    expect(find.text('Solicite o Ponto Digital'), findsOneWidget);
    expect(observer.pushedNames,
        isNot(contains(SharedApplicationRoute.gdpTimesheetRequestSuccess)));
  });

  testWidgets('enquanto solicita mostra o indicador no lugar do botão',
      (tester) async {
    stack.happyPath();
    await pumpPage(tester, TimesheetNotAllowedWarning(appContainer: container),
        observer: observer);
    final b = bloc();
    // ignore: invalid_use_of_visible_for_testing_member
    b.emit(TimesheetRequestLoadingState(
        b.state.list, b.state.report, null, 'C1', null));
    await tester.pump();
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Solicite o Ponto Digital'), findsNothing);
    expect(find.text('back'), findsOneWidget);
  });
}
