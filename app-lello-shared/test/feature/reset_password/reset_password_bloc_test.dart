import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/shared_features.dart' hide isNull, isNotNull;

import 'reset_password_support.dart';

void main() {
  late ResetPasswordBloc bloc;
  final reset = buildReset();
  final failure = UnknownFailure('x');
  final validation = CodeValidation(id: 'K1', code: '123456');
  final request = buildCodeRequest();
  final codeData = buildCodeData();

  setUp(() {
    bloc = ResetPasswordBloc();
  });

  tearDown(() => bloc.close());

  test('começa no passo do CPF sem dados', () {
    expect(bloc.state, isA<ResetPasswordRequestPhoneState>());
    expect(bloc.state.step, PasswordResetStep.cpf);
    expect(bloc.state.cpf, '');
  });

  test('cada evento emite o estado correspondente', () async {
    final states = <ResetPasswordState>[];
    final sub = bloc.stream.listen(states.add);

    bloc
      ..add(PasswordResetChangeStepEvent(
          reset: reset, step: PasswordResetStep.me, cpf: 'c'))
      ..add(ResetPasswordCodeValidatedEvent(
          validation: validation,
          reset: reset,
          step: PasswordResetStep.me,
          cpf: 'c'))
      ..add(ResetPasswordFailedEvent(
          error: failure,
          reset: reset,
          step: PasswordResetStep.me,
          cpf: 'c',
          validation: validation))
      ..add(ResetPasswordMyUserFailedEvent(
          reset: reset, step: PasswordResetStep.me, cpf: 'c', error: failure))
      ..add(ResetPasswordMyUserLoadingEvent(
          cpf: 'c', reset: reset, step: PasswordResetStep.me))
      ..add(ResetPasswordMyUserNoPhoneFailedEvent(
          reset: reset, step: PasswordResetStep.me, cpf: 'c', error: null))
      ..add(ResetPasswordMyUserNotRegisteredFailedEvent(
          reset: reset, step: PasswordResetStep.me, cpf: 'c', error: null))
      ..add(ResetPasswordMyUserSucceededEvent(
          codeData: codeData,
          selectedValue: '',
          type: null,
          reset: reset,
          step: PasswordResetStep.me,
          cpf: 'c'))
      ..add(ResetPasswordRevertEvent(
          reset: reset, step: PasswordResetStep.cpf, cpf: 'c'))
      ..add(ResetPasswordRequestCodeFailedEvent(
          reset: reset, step: PasswordResetStep.me, cpf: 'c', error: failure))
      ..add(ResetPasswordRequestCodeSucceededEvent(
          reset: reset,
          step: PasswordResetStep.me,
          cpf: 'c',
          codeRequest: request))
      ..add(ResetPasswordRequestingCodeEvent(
          reset: reset, step: PasswordResetStep.me, cpf: 'c'))
      ..add(ResetPasswordResettingPasswordEvent(
          reset: reset,
          step: PasswordResetStep.password,
          cpf: 'c',
          validation: validation))
      ..add(ResetPasswordSucceededEvent(
          reset: reset,
          step: PasswordResetStep.password,
          cpf: 'c',
          validation: validation));
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();

    expect(states.map((s) => s.runtimeType).toList(), [
      ResetPasswordState,
      ResetPasswordRequestPasswordState,
      ResetPasswordFailedState,
      ResetPasswordMyUserFailedState,
      ResetPasswordMyUserLoadingState,
      ResetPasswordMyUserNoPhoneFailedState,
      ResetPasswordMyUserNotRegisteredFailedState,
      ResetPasswordMyUserSucceededState,
      ResetPasswordRequestPhoneState,
      ResetPasswordRequestCodeFailedState,
      ResetPasswordRequestCodeSucceededState,
      ResetPasswordRequestingCodeState,
      ResetPasswordResettingPasswordState,
      ResetPasswordSucceededState,
    ]);
    expect(states.first.step, PasswordResetStep.me);
    expect((states[1] as ResetPasswordRequestPasswordState).validation,
        validation);
    expect((states[2] as ResetPasswordFailedState).error, failure);
    expect((states[3] as ResetPasswordMyUserFailedState).error, failure);
    expect((states[7] as ResetPasswordMyUserSucceededState).codeData, codeData);
    expect((states[9] as ResetPasswordRequestCodeFailedState).error, failure);
    expect((states[10] as ResetPasswordRequestCodeSucceededState).codeRequest,
        request);
    expect((states.last as ResetPasswordSucceededState).validation, validation);
    expect(states.last.step, PasswordResetStep.password);
  });
}
