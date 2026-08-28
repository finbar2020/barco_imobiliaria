import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/shared_features.dart' hide isNull, isNotNull;

import '../../helpers/firebase_mocks.dart';
import 'reset_password_support.dart';

void main() {
  late ResetPasswordHarness harness;
  late ResetPasswordController controller;
  late ResetPasswordBloc bloc;
  late List<ResetPasswordState> states;

  setUp(() async {
    harness = await installResetPasswordHarness();
    controller = harness.buildController();
    bloc = controller.resetPasswordBloc;
    states = [];
    bloc.stream.listen(states.add);
    // Deixa a assinatura do sms_autofill chegar.
    await Future<void>.delayed(Duration.zero);
  });

  tearDown(() => bloc.close());

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  test('constantes e assinatura do app', () {
    expect(ResetPasswordController.CODE_LENGTH, 6);
    expect(ResetPasswordController.stepOrder,
        [PasswordResetStep.cpf, PasswordResetStep.me, PasswordResetStep.password]);
    expect(controller.appSignature, 'ASSINATURA');
    expect(harness.smsCalls.single.method, 'getAppSignature');
    controller.dispose();
  });

  group('beginTakeMyUser', () {
    test('sucesso emite carregando e depois os contatos', () async {
      harness.mockDados2fa(
          emails: [contact('e1', 'ana@lello.com')],
          sms: [contact('s1', '(11) 98888-7777')]);

      await controller.beginTakeMyUser(cpf: cpfValido);
      await settle();

      expect(harness.requestedPaths, ['/code_request/2fa/$cpfDigitos']);
      expect(harness.http.requests.single.url.queryParameters['idEmpresa'], '1');
      expect(states.first, isA<ResetPasswordMyUserLoadingState>());
      final succeeded = states.last as ResetPasswordMyUserSucceededState;
      expect(succeeded.codeData.emailContacts.single.value, 'ana@lello.com');
      expect(succeeded.selectedValue, '');
      expect(succeeded.type, isNull);
      expect(succeeded.cpf, cpfValido);
    });

    test('usa o idEmpresa informado', () async {
      harness.idEmpresa = 7;
      controller = harness.buildController();
      harness.mockDados2fa(sms: [contact('s1', '1')]);

      await controller.beginTakeMyUser(cpf: cpfDigitos);

      expect(harness.http.requests.single.url.queryParameters['idEmpresa'], '7');
      await controller.resetPasswordBloc.close();
    });

    test('sem contatos avisa que não há telefone', () async {
      harness.mockDados2fa();

      await controller.beginTakeMyUser(cpf: cpfValido);
      await settle();

      expect(states.last, isA<ResetPasswordMyUserNoPhoneFailedState>());
      expect((states.last as ResetPasswordMyUserNoPhoneFailedState).error,
          isNull);
    });

    test('usuário não cadastrado', () async {
      harness.mockDados2fa(sms: [contact('s1', '1')], registered: false);

      await controller.beginTakeMyUser(cpf: cpfValido);
      await settle();

      expect(states.last, isA<ResetPasswordMyUserNotRegisteredFailedState>());
    });

    test('erro da API emite falha', () async {
      harness.mockDados2fa(status: 500, body: apiFailureBody());

      await controller.beginTakeMyUser(cpf: cpfValido);
      await settle();

      final failed = states.last as ResetPasswordMyUserFailedState;
      expect(failed.error, isNotNull);
      expect(failed.cpf, cpfValido);
    });
  });

  group('beginResetPassword', () {
    setUp(() {
      bloc.state.reset
        ..cpf = cpfDigitos
        ..password = 'Senha123'
        ..token = 'TOKEN-OK';
      bloc.state.cpf = cpfValido;
    });

    test('sucesso registra o evento e emite sucesso', () async {
      harness.mockChangePassword();
      fakeAnalytics.reset();

      await controller.beginResetPassword(appOriginEnum: AppOriginEnum.owner);
      await settle();

      expect(harness.requestedPaths, ['/change_password']);
      expect(states.first, isA<ResetPasswordResettingPasswordState>());
      expect((states.first as ResetPasswordResettingPasswordState).validation,
          isNull);
      final succeeded = states.last as ResetPasswordSucceededState;
      expect(succeeded.reset.cpf, cpfDigitos);
      expect(succeeded.cpf, cpfValido);
      expect(fakeAnalytics.eventNames, isNotEmpty);
    });

    test('registra o evento do síndico e do colaborador', () async {
      harness.mockChangePassword();
      for (final origin in [AppOriginEnum.manager, AppOriginEnum.employee]) {
        fakeAnalytics.reset();
        await controller.beginResetPassword(appOriginEnum: origin);
        expect(fakeAnalytics.eventNames, isNotEmpty);
      }
      controller.logEventBasedOnAppOrigin(appOriginEnum: AppOriginEnum.owner);
    });

    test('preserva a validação quando o estado já foi validado', () async {
      harness.mockChangePassword();
      final validation = CodeValidation(id: 'K1', code: '123456');
      controller.setValidation(validation: validation);
      await settle();

      await controller.beginResetPassword(appOriginEnum: AppOriginEnum.owner);
      await settle();

      expect((states.last as ResetPasswordSucceededState).validation,
          validation);
    });

    test('falha emite o estado de falha', () async {
      harness.mockChangePassword(status: 500, body: apiFailureBody());

      await controller.beginResetPassword(appOriginEnum: AppOriginEnum.owner);
      await settle();

      final failed = states.last as ResetPasswordFailedState;
      expect(failed.error, isA<UnknownFailure>());
    });
  });

  group('beginRequestCode', () {
    test('sem telefone, e-mail ou chave não faz nada', () async {
      await controller.beginRequestCode();
      await settle();

      expect(states, isEmpty);
      expect(harness.http.requests, isEmpty);
    });

    test('por telefone pede o código e emite sucesso', () async {
      harness.mockRequest2fa();
      bloc.state.cpf = cpfValido;
      bloc.state.reset
        ..phone = '11988887777'
        ..codeValidationId = 'K1';

      await controller.beginRequestCode();
      await settle();

      expect(harness.requestedPaths, ['/code_request/2fa/request']);
      final query = harness.http.requests.single.url.queryParameters;
      expect(query['hashToken'], 'K1');
      expect(query['hashDevice'], 'ASSINATURA');
      expect(states.first, isA<ResetPasswordRequestingCodeState>());
      final succeeded = states.last as ResetPasswordRequestCodeSucceededState;
      expect(succeeded.codeRequest.source, CodeValidationSource.phone);
      expect(succeeded.codeRequest.value, '11988887777');
      expect(succeeded.codeRequest.cpf, cpfDigitos);
      expect(succeeded.codeRequest.id, 'K1');
      expect(succeeded.codeRequest.origin, CodeValidationOrigin.forgotPassword);
      expect(succeeded.reset.cpf, cpfValido);
      expect(succeeded.reset.email, '');
    });

    test('por e-mail usa a fonte de e-mail', () async {
      harness.mockRequest2fa();
      bloc.state.reset
        ..email = 'ana@lello.com'
        ..codeValidationId = 'E1';

      await controller.beginRequestCode();
      await settle();

      final succeeded = states.last as ResetPasswordRequestCodeSucceededState;
      expect(succeeded.codeRequest.source, CodeValidationSource.email);
      expect(succeeded.codeRequest.value, 'ana@lello.com');
    });

    test('falha ao pedir o código emite o erro', () async {
      harness.mockRequest2fa(status: 500, body: apiFailureBody());
      bloc.state.reset.phone = '11988887777';

      await controller.beginRequestCode();
      await settle();

      expect(states.last, isA<ResetPasswordRequestCodeFailedState>());
    });
  });

  test('setPhone e setValidation atualizam o estado', () async {
    controller.setPhone('11');
    expect(bloc.state.reset.phone, '11');

    final validation = CodeValidation(id: 'K1', code: '1');
    controller.setValidation(validation: validation);
    await settle();

    final validated = bloc.state as ResetPasswordRequestPasswordState;
    expect(validated.validation, validation);
  });

  test('revert no estado inicial devolve verdadeiro sem emitir', () async {
    expect(controller.revert(), isTrue);
    await settle();
    expect(states, isEmpty);
  });

  test('revert em outro estado limpa a senha e volta ao início', () async {
    controller.nextStep(currentStep: PasswordResetStep.cpf);
    await settle();
    bloc.state.reset
      ..password = 'x'
      ..codeValidationId = 'k';

    expect(controller.revert(), isFalse);
    await settle();

    expect(bloc.state, isA<ResetPasswordRequestPhoneState>());
    expect(bloc.state.reset.password, isNull);
    expect(bloc.state.reset.codeValidationId, isNull);
  });

  test('nextStep e previousStep percorrem os passos', () async {
    controller.nextStep(currentStep: PasswordResetStep.cpf);
    await settle();
    expect(bloc.state.step, PasswordResetStep.me);

    controller.nextStep(currentStep: PasswordResetStep.me);
    await settle();
    expect(bloc.state.step, PasswordResetStep.password);

    expect(controller.previousStep(currentStep: PasswordResetStep.password),
        isFalse);
    await settle();
    expect(bloc.state.step, PasswordResetStep.me);

    expect(controller.previousStep(currentStep: PasswordResetStep.cpf), isTrue);
  });

  /// Corrigido: no último passo (`password`) não há próximo passo — a
  /// conclusão do fluxo é feita por `beginResetPassword` — então `nextStep`
  /// não adiciona mais o `PasswordResetEvent` sem handler (que lançava
  /// `StateError` em debug) e simplesmente não faz nada.
  test('nextStep no último passo não emite nada', () async {
    controller.nextStep(currentStep: PasswordResetStep.password);
    await settle();

    expect(states, isEmpty);
    expect(bloc.state, isA<ResetPasswordRequestPhoneState>());
  });
}
