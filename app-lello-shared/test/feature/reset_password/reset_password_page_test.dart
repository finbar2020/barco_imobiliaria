import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/shared_features.dart' hide isNull, isNotNull;

import '../../helpers/pump_app.dart';
import 'reset_password_support.dart';

void main() {
  late ResetPasswordHarness harness;
  late RecordingNavigatorObserver observer;

  setUp(() async {
    harness = await installResetPasswordHarness(loginUsername: cpfValido);
    observer = RecordingNavigatorObserver();
  });

  Future<void> pumpReset(
    WidgetTester tester, {
    AppOriginEnum origin = AppOriginEnum.owner,
    bool settle = true,
  }) async {
    await pumpPage(
      tester,
      ResetPasswordPage(appOriginEnum: origin),
      arguments: harness.container,
      observer: observer,
      routes: {
        SharedApplicationRoute.resetPasswordWarning: (_) =>
            ResetPasswordWarningPage(appContainer: harness.container),
        SharedApplicationRoute.resetPasswordSuccess: (_) =>
            ResetPasswordSuccessPage(),
      },
      settle: settle,
    );
  }

  ResetPasswordController controller() => harness.lastController!;

  Future<void> goToMe(WidgetTester tester) async {
    await tester.tap(find.widgetWithText(ElevatedButton, 'next'));
    await tester.pumpAndSettle();
  }

  Future<void> enterCode(WidgetTester tester, String code) async {
    await tester.enterText(find.byType(EditableText), code);
    await tester.pump();
    await tester.pump();
  }

  testWidgets('passo do CPF vem preenchido com o usuário do login',
      (tester) async {
    await pumpReset(tester);

    expect(find.text('forgot_password'), findsOneWidget);
    expect(find.text('registration_document_title'), findsOneWidget);
    expect(find.text(cpfValido), findsOneWidget);
    expect(find.text('next'), findsOneWidget);

    await expectLater(
      find.byType(ResetPasswordPage),
      matchesGoldenFile('goldens/reset_password_cpf.png'),
    );
  });

  testWidgets('CPF inválido não avança', (tester) async {
    await pumpReset(tester);

    await tester.enterText(find.byType(TextFormField), '111');
    await goToMe(tester);

    expect(controller().resetPasswordBloc.state.step, PasswordResetStep.cpf);
    expect(harness.http.requests, isEmpty);
  });

  testWidgets('fluxo completo: CPF, contatos, código, senha e sucesso',
      (tester) async {
    harness.mockHappyPath();
    await pumpReset(tester);

    await goToMe(tester);
    expect(harness.requestedPaths, ['/code_request/2fa/$cpfDigitos']);
    expect(find.text('registration_lello_user_title'), findsOneWidget);
    expect(find.text('ana@lello.com'), findsOneWidget);
    expect(find.text('(11) 98888-7777'), findsOneWidget);
    await expectLater(
      find.byType(ResetPasswordPage),
      matchesGoldenFile('goldens/reset_password_me.png'),
    );

    // Sem contato selecionado o pedido de código é ignorado.
    await tester.tap(find.widgetWithText(ElevatedButton, 'next'));
    await tester.pumpAndSettle();
    expect(harness.requestedPaths, hasLength(1));

    // Seleciona o e-mail e depois troca para o telefone.
    await tester.tap(find.text('ana@lello.com'));
    await tester.pumpAndSettle();
    var state =
        controller().resetPasswordBloc.state as ResetPasswordMyUserSucceededState;
    expect(state.reset.email, 'ana@lello.com');
    expect(state.reset.codeValidationId, 'e1');
    expect(state.reset.phone, isNull);
    expect(state.type, CodeValidationSource.email);

    await tester.tap(find.text('(11) 98888-7777'));
    await tester.pumpAndSettle();
    state =
        controller().resetPasswordBloc.state as ResetPasswordMyUserSucceededState;
    expect(state.reset.phone, '(11) 98888-7777');
    expect(state.reset.codeValidationId, 's1');
    expect(state.reset.email, isNull);
    expect(state.type, CodeValidationSource.phone);

    await tester.tap(find.widgetWithText(ElevatedButton, 'next'));
    await tester.pump();
    await tester.pump();
    expect(harness.requestedPaths.last, '/code_request/2fa/request');
    expect(find.byType(CodeValidationPage), findsOneWidget);

    await enterCode(tester, '123456');
    await tester.pump();
    expect(harness.requestedPaths.last, '/code_request/2fa/validate');
    expect(find.text('registration_password_title'), findsOneWidget);
    expect(controller().resetPasswordBloc.state,
        isA<ResetPasswordRequestPasswordState>());
    await expectLater(
      find.byType(ResetPasswordPage),
      matchesGoldenFile('goldens/reset_password_new_password.png'),
    );

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(1), 'Senha123');
    await tester.enterText(fields.at(2), 'Senha123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'finish'));
    await tester.pumpAndSettle();

    expect(harness.requestedPaths.last, '/change_password');
    // Defeito: o token devolvido pela validação 2FA (`TOKEN-OK`) nunca é
    // copiado para `reset.token`, então a troca de senha é enviada com
    // `token: null`.
    expect(harness.http.requests.last.body, contains('"token":null'));
    expect(harness.http.requests.last.body, contains('"password":"Senha123"'));
    expect(observer.pushedNames.last, SharedApplicationRoute.resetPasswordSuccess);
    expect(find.byType(ResetPasswordSuccessPage), findsOneWidget);
    expect(find.text('reset_password_success'), findsOneWidget);
    await expectLater(
      find.byType(ResetPasswordSuccessPage),
      matchesGoldenFile('goldens/reset_password_success.png'),
    );

    await tester.tap(find.text('close'));
    await tester.pumpAndSettle();
    expect(find.byType(ResetPasswordSuccessPage), findsNothing);
  });

  testWidgets('reenviar o código volta a buscar os contatos', (tester) async {
    harness.mockHappyPath();
    await pumpReset(tester);
    await goToMe(tester);
    await tester.tap(find.text('(11) 98888-7777'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'next'));
    await tester.pump();
    await tester.pump();
    expect(find.byType(CodeValidationPage), findsOneWidget);

    for (var i = 0; i < 60; i++) {
      await tester.pump(const Duration(seconds: 1));
    }
    await tester.tap(find.text('resend_sms (00:00)'));
    await tester.pumpAndSettle();

    expect(harness.requestedPaths.last, '/code_request/2fa/$cpfDigitos');
    expect(find.text('registration_lello_user_title'), findsOneWidget);
  });

  testWidgets('usuário sem contatos abre o aviso e volta ao CPF',
      (tester) async {
    harness.mockDados2fa();
    await pumpReset(tester);

    await goToMe(tester);

    expect(observer.pushedNames.last, SharedApplicationRoute.resetPasswordWarning);
    expect(find.text('registration_failed_title'), findsOneWidget);
    expect(find.text('registration_failed_phone_not_fount'), findsOneWidget);
    expect(find.text('registration_lello_warning_cta_primary'), findsOneWidget);
    await expectLater(
      find.byType(ResetPasswordWarningPage),
      matchesGoldenFile('goldens/reset_password_warning.png'),
    );

    await tester.tap(find.text('registration_lello_warning_cta_primary'));
    await tester.pumpAndSettle();

    expect(find.byType(ResetPasswordWarningPage), findsNothing);
    expect(controller().resetPasswordBloc.state.step, PasswordResetStep.cpf);
    expect(find.text('registration_document_title'), findsOneWidget);
  });

  testWidgets('usuário não cadastrado oferece o cadastro', (tester) async {
    harness.mockDados2fa(sms: [contact('s1', '1')], registered: false);
    await pumpReset(tester);

    await goToMe(tester);

    expect(find.text('registration_failed_not_registered_title'), findsOneWidget);
    expect(find.text('registration_failed_not_registered'), findsOneWidget);

    await tester.tap(find.text('sign_up'));
    await tester.pumpAndSettle();

    // Defeito: `goToRegister` já fecha o aviso e abre o cadastro, mas o
    // `onPressed` faz mais um `Navigator.pop` em seguida, que fecha o
    // cadastro recém-aberto; o usuário volta para a tela de senha.
    expect(observer.pushedNames.last, SharedApplicationRoute.registration);
    expect(observer.pushed.last.settings.arguments, same(harness.container));
    expect(observer.popped.last.settings.name,
        SharedApplicationRoute.registration);
    expect(findRoute(SharedApplicationRoute.registration), findsNothing);
    expect(find.byType(ResetPasswordPage), findsOneWidget);
  });

  testWidgets('erro ao buscar o usuário mostra o erro genérico e sai',
      (tester) async {
    harness.mockDados2fa(status: 500, body: apiFailureBody());
    await pumpReset(tester);

    await goToMe(tester);

    expect(find.text('error_unknown'), findsOneWidget);

    await tester.tap(find.text('registration_lello_warning_cta_secondary'));
    await tester.pumpAndSettle();

    // Fecha o aviso e a própria tela de senha.
    expect(find.byType(ResetPasswordWarningPage), findsNothing);
    expect(find.byType(ResetPasswordPage), findsNothing);
  });

  testWidgets('voltar no passo dos contatos retorna ao CPF', (tester) async {
    harness.mockDados2fa(sms: [contact('s1', '(11) 98888-7777')]);
    await pumpReset(tester);
    await goToMe(tester);
    expect(controller().resetPasswordBloc.state.step, PasswordResetStep.me);

    await tester.state<NavigatorState>(find.byType(Navigator)).maybePop();
    await tester.pumpAndSettle();

    expect(find.byType(ResetPasswordPage), findsOneWidget);
    expect(controller().resetPasswordBloc.state.step, PasswordResetStep.cpf);

    await tester.state<NavigatorState>(find.byType(Navigator)).maybePop();
    await tester.pumpAndSettle();
    expect(find.byType(ResetPasswordPage), findsNothing);
  });

  testWidgets('passo da senha sem validação e estado pedindo código',
      (tester) async {
    await pumpReset(tester);
    controller().nextStep(currentStep: PasswordResetStep.cpf);
    controller().nextStep(currentStep: PasswordResetStep.me);
    await tester.pumpAndSettle();

    expect(find.text('registration_password_title'), findsOneWidget);

    final state = controller().resetPasswordBloc.state;
    await emitState(
        tester,
        controller().resetPasswordBloc,
        ResetPasswordRequestingCodeState(
            state.reset..phone = '11', state.step, state.cpf),
        settle: false);
    expect(find.byType(RequestValidationCodeLoading), findsOneWidget);
    expect(find.text('registration_sending_sms'), findsOneWidget);

    await emitState(
        tester,
        controller().resetPasswordBloc,
        ResetPasswordRequestingCodeState(
            state.reset..phone = '', PasswordResetStep.cpf, state.cpf),
        settle: false);
    expect(find.text('registration_sending_email'), findsOneWidget);
  });

  testWidgets('colaborador usa o tema carimbeira', (tester) async {
    await pumpReset(tester, origin: AppOriginEnum.employee);

    final theme = Theme.of(tester.element(find.byType(PasswordResetCpf)));
    expect(theme.colorScheme.primary, LelloTheme.carimbeira.colorScheme.primary);
  });

  testWidgets('app genérico usa o tema viver', (tester) async {
    harness = await installResetPasswordHarness(
        packageName: SharedPreferencesKeys.genericMorar);
    await pumpReset(tester);

    final theme = Theme.of(tester.element(find.byType(PasswordResetCpf)));
    expect(theme.colorScheme.primary,
        LelloTheme.viverDefaultTheme.colorScheme.primary);
  });

  group('ResetPasswordWarningPage', () {
    testWidgets('CPF não encontrado e estado sem falha', (tester) async {
      final controller = harness.buildController();
      final bloc = controller.resetPasswordBloc;
      // ignore: invalid_use_of_visible_for_testing_member
      bloc.emit(ResetPasswordMyUserFailedState(cpfValido, bloc.state.reset,
          PasswordResetStep.me, RegistrationUserNotFoundFailure()));
      await pumpPage(
        tester,
        ResetPasswordWarningPage(appContainer: harness.container),
        arguments: controller,
        observer: observer,
      );

      expect(find.text('registration_lello_warning_title'), findsOneWidget);
      expect(find.text('registration_lello_warning_subtitle'), findsOneWidget);

      await tester.tap(find.text('registration_lello_warning_cta_primary'));
      await tester.pumpAndSettle();
      expect(find.byType(ResetPasswordWarningPage), findsNothing);
      expect(bloc.state.step, PasswordResetStep.cpf);

      // Sem falha conhecida a página não mostra mensagem. É preciso desmontar
      // a árvore: um segundo `pumpPage` reaproveita o Navigator (que já está
      // com a rota da página removida pelo pop acima).
      await tester.pumpWidget(const SizedBox());
      await pumpPage(
        tester,
        ResetPasswordWarningPage(appContainer: harness.container),
        arguments: controller,
      );
      expect(find.text('registration_lello_warning_title'), findsNothing);
      expect(find.text('registration_failed_title'), findsNothing);
      expect(find.text('registration_lello_warning_cta_primary'), findsOneWidget);
    });
  });
}
