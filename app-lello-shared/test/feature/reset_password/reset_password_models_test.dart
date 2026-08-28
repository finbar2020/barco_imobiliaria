import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/reset_password/data/model/password_reset_model.dart';
import 'package:shared_features/shared_features.dart' hide isNull, isNotNull;

import 'reset_password_support.dart';

void main() {
  group('PasswordResetModel', () {
    test('fromJson/toJson', () {
      final model = PasswordResetModel.fromJson(
          {'password': 'p', 'cpf': 'c', 'token': 't'});
      expect(model.password, 'p');
      expect(model.cpf, 'c');
      expect(model.token, 't');
      expect(model.toJson(), {'password': 'p', 'cpf': 'c', 'token': 't'});

      final vazio = PasswordResetModel.fromJson({});
      expect(vazio.password, isNull);
      expect(vazio.toJson(), {'password': null, 'cpf': null, 'token': null});
    });

    test('fromEntity/toEntity', () {
      expect(PasswordResetModel.fromEntity(null), isNull);

      final model = PasswordResetModel.fromEntity(buildReset())!;
      expect(model.password, 'Senha123');
      expect(model.cpf, cpfDigitos);
      expect(model.token, 'TOKEN-OK');

      final entity = model.toEntity();
      expect(entity.password, 'Senha123');
      expect(entity.cpf, cpfDigitos);
      expect(entity.token, 'TOKEN-OK');
      expect(entity.phone, isNull);
    });
  });

  test('entidades, passos, parâmetros e falhas', () {
    final reset = buildReset(phone: '11', email: 'e', codeValidationId: 'k');
    expect(reset.phone, '11');
    expect(reset.email, 'e');
    expect(reset.codeValidationId, 'k');

    expect(PasswordResetStep.values,
        [PasswordResetStep.cpf, PasswordResetStep.me, PasswordResetStep.password]);

    final params = ResetPassword2faParams(cpf: 'c', password: 'p', token: 't');
    expect(params.cpf, 'c');
    expect(params.password, 'p');
    expect(params.token, 't');

    expect(InvalidCodeRequestFailure(), isA<Failure>());
    expect(InvalidCpfFailure(), isA<Failure>());
    expect(InvalidPasswordFailure(), isA<Failure>());
    expect(InvalidResetPassword2faFailure(), isA<Failure>());
  });

  group('estados', () {
    final reset = buildReset();
    final validation = CodeValidation(id: 'K1', code: '123456');
    final failure = UnknownFailure('x');

    test('comparam pelos props', () {
      expect(ResetPasswordState(reset, PasswordResetStep.cpf, 'c').props,
          [reset, PasswordResetStep.cpf, 'c']);
      expect(ResetPasswordEmptyState(reset, PasswordResetStep.cpf, 'c'),
          ResetPasswordEmptyState(reset, PasswordResetStep.cpf, 'c'));
      expect(
          ResetPasswordResettingPasswordState(
                  reset, PasswordResetStep.cpf, 'c', validation)
              .props,
          [reset, PasswordResetStep.cpf, 'c', validation]);
      expect(
          ResetPasswordFailedState(
                  failure, reset, PasswordResetStep.cpf, 'c', validation)
              .props,
          [reset, PasswordResetStep.cpf, 'c', validation, failure]);
      expect(
          ResetPasswordSucceededState(reset, PasswordResetStep.cpf, 'c', null)
              .validation,
          isNull);
      expect(ResetPasswordRequestingCodeState(reset, PasswordResetStep.me, 'c'),
          ResetPasswordRequestingCodeState(reset, PasswordResetStep.me, 'c'));
      expect(
          ResetPasswordRequestCodeFailedState(
                  reset, PasswordResetStep.me, 'c', failure)
              .props
              .last,
          failure);
      final request = buildCodeRequest();
      expect(
          ResetPasswordRequestCodeSucceededState(
                  reset, PasswordResetStep.me, 'c', request)
              .props
              .last,
          request);
      final empty = ResetPasswordRequestPhoneState.empty();
      expect(empty.step, PasswordResetStep.cpf);
      expect(empty.cpf, '');
      expect(ResetPasswordMyUserLoadingState('c', reset, PasswordResetStep.me).cpf,
          'c');
      expect(
          ResetPasswordMyUserFailedState('c', reset, PasswordResetStep.me, failure)
              .props
              .last,
          failure);
      expect(
          ResetPasswordMyUserNoPhoneFailedState(
                  'c', reset, PasswordResetStep.me, null)
              .error,
          isNull);
      expect(
          ResetPasswordMyUserNotRegisteredFailedState(
                  'c', reset, PasswordResetStep.me, null)
              .props
              .last,
          isNull);
      final codeData = buildCodeData();
      final succeeded = ResetPasswordMyUserSucceededState(
          codeData, 's1', CodeValidationSource.phone, reset,
          PasswordResetStep.me, 'c');
      expect(succeeded.props.sublist(3),
          [codeData, 's1', CodeValidationSource.phone]);
      expect(
          ResetPasswordRequestPasswordState(
                  reset, PasswordResetStep.me, 'c', validation)
              .validation,
          validation);
      // Estados de tipos diferentes com os mesmos dados não são iguais.
      expect(ResetPasswordRequestPhoneState(reset, PasswordResetStep.cpf, 'c'),
          isNot(ResetPasswordEmptyState(reset, PasswordResetStep.cpf, 'c')));
    });
  });

  group('eventos', () {
    final reset = buildReset();
    final validation = CodeValidation(id: 'K1', code: '123456');
    final failure = UnknownFailure('x');
    final request = buildCodeRequest();
    final codeData = buildCodeData();

    test('comparam pelos props', () {
      expect(const ResetPasswordRequestEvent(appOriginEnum: AppOriginEnum.owner)
          .props, [AppOriginEnum.owner]);
      expect(const PasswordResetMyUserEvent(cpf: 'c').props, ['c']);
      expect(const PasswordResetEvent().props, isEmpty);
      expect(
          ResetPasswordResettingPasswordEvent(
                  reset: reset,
                  step: PasswordResetStep.cpf,
                  cpf: 'c',
                  validation: validation)
              .props,
          [reset, PasswordResetStep.cpf, 'c', validation]);
      expect(
          ResetPasswordFailedEvent(
                  error: failure,
                  reset: reset,
                  step: PasswordResetStep.cpf,
                  cpf: 'c',
                  validation: null)
              .props,
          [failure, reset, PasswordResetStep.cpf, 'c', null]);
      expect(
          ResetPasswordSucceededEvent(
                  reset: reset,
                  step: PasswordResetStep.cpf,
                  cpf: 'c',
                  validation: validation)
              .props,
          [reset, PasswordResetStep.cpf, 'c', validation]);
      expect(
          ResetPasswordRequestingCodeEvent(
                  reset: reset, step: PasswordResetStep.me, cpf: 'c')
              .props,
          [reset, PasswordResetStep.me, 'c']);
      expect(
          ResetPasswordRequestCodeFailedEvent(
                  reset: reset,
                  step: PasswordResetStep.me,
                  cpf: 'c',
                  error: failure)
              .props,
          [reset, PasswordResetStep.me, 'c', failure]);
      expect(
          ResetPasswordRequestCodeSucceededEvent(
                  reset: reset,
                  step: PasswordResetStep.me,
                  cpf: 'c',
                  codeRequest: request)
              .props,
          [reset, PasswordResetStep.me, 'c', request]);
      expect(
          ResetPasswordRevertEvent(
                  reset: reset, step: PasswordResetStep.me, cpf: 'c')
              .props,
          [reset, PasswordResetStep.me, 'c']);
      expect(
          ResetPasswordMyUserLoadingEvent(
                  cpf: 'c', reset: reset, step: PasswordResetStep.me)
              .props,
          ['c', reset, PasswordResetStep.me]);
      expect(
          ResetPasswordMyUserFailedEvent(
                  reset: reset,
                  step: PasswordResetStep.me,
                  cpf: 'c',
                  error: failure)
              .props,
          [reset, PasswordResetStep.me, 'c', failure]);
      expect(
          ResetPasswordMyUserNoPhoneFailedEvent(
                  reset: reset, step: PasswordResetStep.me, cpf: 'c', error: null)
              .props,
          [reset, PasswordResetStep.me, 'c', null]);
      expect(
          ResetPasswordMyUserNotRegisteredFailedEvent(
                  reset: reset, step: PasswordResetStep.me, cpf: 'c', error: null)
              .props,
          [reset, PasswordResetStep.me, 'c', null]);
      expect(
          ResetPasswordMyUserSucceededEvent(
                  codeData: codeData,
                  selectedValue: 's',
                  type: CodeValidationSource.email,
                  reset: reset,
                  step: PasswordResetStep.me,
                  cpf: 'c')
              .props,
          [codeData, 's', CodeValidationSource.email, reset, PasswordResetStep.me, 'c']);
      expect(
          ResetPasswordCodeValidatedEvent(
                  validation: validation,
                  reset: reset,
                  step: PasswordResetStep.me,
                  cpf: 'c')
              .props,
          [validation, reset, PasswordResetStep.me, 'c']);
      expect(
          PasswordResetChangeStepEvent(
                  reset: reset, step: PasswordResetStep.password, cpf: 'c')
              .props,
          [reset, PasswordResetStep.password, 'c']);
    });
  });
}
