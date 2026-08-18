import 'package:colaborador/feature/timesheet/domain/use_case/send_email/send_email.dart';
import 'package:colaborador/feature/timesheet/domain/use_case/sign_timesheet/sign_timesheet.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_assign_dialog/bloc/timesheet_sign_bloc.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_assign_dialog/bloc/timesheet_sign_state.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_email_dialog/bloc/timesheet_email_bloc.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_email_dialog/bloc/timesheet_email_state.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fixtures.dart';

class _FakeSign extends Fake implements SignTimesheetUsecase {
  bool fail = false;
  String? lastCondo;

  @override
  Future<Try<bool>> call(SignTimesheetParam params) async {
    lastCondo = params.condoId;
    if (fail) return Rejection(UnknownFailure('x'));
    return Success(true);
  }
}

class _FakeEmail extends Fake implements TimesheetSendEmailUsecase {
  bool fail = false;

  @override
  Future<Try<bool>> call(TimesheetSendEmailParam params) async {
    if (fail) return Rejection(UnknownFailure('x'));
    return Success(true);
  }
}

void main() {
  final period = DateTime(2026, 1, 10);

  group('TimesheetSignBloc', () {
    test('assina com sucesso', () async {
      final useCase = _FakeSign();
      final bloc = TimesheetSignBloc(
        timesheetSignUsecase: useCase,
        sessionBloc: FakeSessionBloc(),
      );
      addTearDown(bloc.close);
      bloc.timesheetSign(period);
      final state = await bloc.stream.firstWhere(
        (s) => s is TimesheetSignSuccessState || s is TimesheetSignFailedState,
      );
      expect(state, isA<TimesheetSignSuccessState>());
      expect(useCase.lastCondo, 'c1');
    });

    test('emite failed', () async {
      final bloc = TimesheetSignBloc(
        timesheetSignUsecase: _FakeSign()..fail = true,
        sessionBloc: FakeSessionBloc(),
      );
      addTearDown(bloc.close);
      bloc.timesheetSign(period);
      final state = await bloc.stream.firstWhere(
        (s) => s is TimesheetSignSuccessState || s is TimesheetSignFailedState,
      );
      expect(state, isA<TimesheetSignFailedState>());
    });
  });

  group('TimesheetEmailBloc', () {
    test('envia e-mail', () async {
      final bloc = TimesheetEmailBloc(
        sendEmailUsecase: _FakeEmail(),
        sessionBloc: FakeSessionBloc(),
      );
      addTearDown(bloc.close);
      bloc.sendEmail(email: 'ana@lello.com', period: period);
      final state = await bloc.stream.firstWhere(
        (s) => s is TimesheetEmailSuccessState || s is TimesheetEmailFailedState,
      );
      expect(state, isA<TimesheetEmailSuccessState>());
      expect((state as TimesheetEmailSuccessState).email, 'ana@lello.com');
    });

    test('tryAgain volta ao initial', () async {
      final bloc = TimesheetEmailBloc(
        sendEmailUsecase: _FakeEmail()..fail = true,
        sessionBloc: FakeSessionBloc(),
      );
      addTearDown(bloc.close);
      bloc.sendEmail(email: 'ana@lello.com', period: period);
      await bloc.stream.firstWhere((s) => s is TimesheetEmailFailedState);
      bloc.tryAgain(email: 'ana@lello.com', period: period);
      final state = await bloc.stream.firstWhere(
        (s) => s is TimesheetEmailInitialState,
      );
      expect((state as TimesheetEmailInitialState).email, 'ana@lello.com');
    });
  });
}
