import 'dart:async';

import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_email_dialog/bloc/timesheet_email_bloc.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_email_dialog/bloc/timesheet_email_state.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_email_dialog/page/timesheet_email_dialog.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_email_dialog/widget/timesheet_email_failed_body.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_email_dialog/widget/timesheet_email_fill_body.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_email_dialog/widget/timesheet_email_loading_body.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_email_dialog/widget/timesheet_email_success_body.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_application_container.dart';

class _FakeEmailBloc extends Fake implements TimesheetEmailBloc {
  _FakeEmailBloc(this._state);

  final TimesheetEmailState _state;
  final _controller = StreamController<TimesheetEmailState>.broadcast();
  final sent = <String>[];
  final retried = <String>[];

  @override
  TimesheetEmailState get state => _state;

  @override
  Stream<TimesheetEmailState> get stream => _controller.stream;

  @override
  void sendEmail({required String email, required DateTime period}) =>
      sent.add(email);

  @override
  void tryAgain({String? email, required DateTime period}) =>
      retried.add(email ?? '');

  @override
  Future<void> close() async {}

  Future<void> dispose() => _controller.close();
}

late _FakeEmailBloc _bloc;

Future<void> _install(TimesheetEmailState state) async {
  final locator = ApplicationContainer.instance().locator;
  if (locator.isRegistered<Environment>()) {
    await locator.reset(dispose: true);
  }
  _bloc = _FakeEmailBloc(state);
  locator.registerSingleton<Environment>(TestEnvironment());
  locator.registerFactory<Validator>(() => ValidatorImpl());
  locator.registerSingleton<TimesheetEmailBloc>(_bloc);
}

Future<void> _pumpDialog(WidgetTester tester) async {
  await pumpApp(
    tester,
    TimesheetEmailDialogBody(period: DateTime(2026, 1, 31)),
    localized: true,
    wrapInScaffold: false,
    shrinkWrap: false,
    settle: false,
    surface: const Size(420, 800),
  );
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void main() {
  tearDown(() async {
    await _bloc.dispose();
    await resetTestApplicationContainer();
  });

  group('TimesheetEmailDialogBody', () {
    testWidgets('estado inicial pede o email', (tester) async {
      await _install(const TimesheetEmailInitialState(email: 'ana@lello.com'));
      await _pumpDialog(tester);

      expect(find.byType(TimesheetEmailFillBody), findsOneWidget);
      expect(find.text('ana@lello.com'), findsOneWidget);
    });

    testWidgets('envia o email digitado para o bloc', (tester) async {
      await _install(const TimesheetEmailInitialState());
      await _pumpDialog(tester);

      await tester.enterText(find.byType(TextFormField), 'ana@lello.com');
      await tester.tap(find.text('SEND'));
      await tester.pump();

      expect(_bloc.sent, ['ana@lello.com']);
    });

    testWidgets('enviando mostra o corpo de loading', (tester) async {
      await _install(
        const TimesheetEmailLoadingState(email: 'ana@lello.com'),
      );
      await _pumpDialog(tester);

      expect(find.byType(TimesheetEmailLoadingBody), findsOneWidget);
    });

    testWidgets('sucesso mostra a confirmação', (tester) async {
      await _install(
        const TimesheetEmailSuccessState(email: 'ana@lello.com'),
      );
      await _pumpDialog(tester);

      expect(find.byType(TimesheetEmailSuccessBody), findsOneWidget);
    });

    testWidgets('falha permite tentar novamente com o mesmo email',
        (tester) async {
      await _install(
        const TimesheetEmailFailedState(email: 'ana@lello.com'),
      );
      await _pumpDialog(tester);

      expect(find.byType(TimesheetEmailFailedBody), findsOneWidget);
    });
  });
}
