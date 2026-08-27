import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';
import 'package:shared_features/shared_features.dart' hide isNull, isNotNull;

import '../../helpers/pump_app.dart';
import 'reset_password_support.dart';

void main() {
  late ResetPasswordHarness harness;
  late ResetPasswordController controller;
  late ResetPasswordBloc bloc;

  setUp(() async {
    harness = await installResetPasswordHarness();
  });

  /// O bloc precisa nascer DENTRO do fake async do `testWidgets`: criado no
  /// `setUp` os handlers rodam na zona real e o `BlocBuilder` não reage.
  void start() {
    controller = harness.buildController();
    bloc = controller.resetPasswordBloc;
  }

  Future<void> pumpWidgetUnderTest(WidgetTester tester, Widget child,
      {bool settle = true}) async {
    await pumpApp(
      tester,
      BlocProvider.value(value: bloc, child: child),
      shrinkWrap: false,
      settle: settle,
    );
  }

  group('ResetPasswordPhoneForm', () {
    Widget form() => ResetPasswordPhoneForm(
        resetPasswordController: controller,
        validator: harness.container.resolve<Validator>());

    testWidgets('telefone inválido mostra a validação', (tester) async {
      start();
      await pumpWidgetUnderTest(tester, form());

      expect(find.text('reset_password_title'), findsOneWidget);
      expect(find.text('registration_phone_title'), findsOneWidget);
      expect(find.text('cellphone_number'), findsOneWidget);
      expect(find.text('request_validation_code_failed'), findsNothing);

      await tester.enterText(find.byType(TextFormField).first, '1');
      await tester.tap(find.widgetWithText(ElevatedButton, 'next'));
      await tester.pumpAndSettle();

      expect(find.text('validation_invalid_phone'), findsOneWidget);
      expect(harness.http.requests, isEmpty);
      await expectLater(
        findGoldenSurface(),
        matchesGoldenFile('goldens/reset_password_phone_form.png'),
      );
    });

    testWidgets('telefone válido salva e pede o código', (tester) async {
      start();
      harness.mockRequest2fa();
      bloc.state.reset.codeValidationId = 'K1';
      await pumpWidgetUnderTest(tester, form());

      await tester.enterText(find.byType(TextFormField).first, '11');
      await tester.enterText(find.byType(TextFormField).last, '988887777');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(bloc.state.reset.phone, isNotEmpty);
      expect(harness.requestedPaths, ['/code_request/2fa/request']);
    });

    testWidgets('estado de falha mostra a mensagem e mantém o telefone',
        (tester) async {
      start();
      bloc.state.reset.phone = '11988887777';
      await emitState(
          tester,
          bloc,
          ResetPasswordRequestCodeFailedState(
              bloc.state.reset, bloc.state.step, '', UnknownFailure('x')));
      await pumpWidgetUnderTest(tester, form());

      expect(find.text('request_validation_code_failed'), findsOneWidget);
    });
  });

  group('ResetPasswordMeWidget', () {
    Widget me() => ResetPasswordMeWidget(
        appContainer: harness.container,
        resetPasswordController: controller,
        validator: harness.container.resolve<Validator>());

    void startWithCpf() {
      start();
      bloc.state.cpf = cpfValido;
    }

    testWidgets('busca os contatos e mostra só os e-mails', (tester) async {
      startWithCpf();
      harness.mockDados2fa(emails: [contact('e1', 'ana@lello.com')]);
      await pumpWidgetUnderTest(tester, me());

      expect(harness.requestedPaths, ['/code_request/2fa/$cpfDigitos']);
            expect(find.text('registration_lello_user_email_title'), findsOneWidget);
      expect(find.text('registration_lello_user_phone_title'), findsNothing);
      expect(find.text('ana@lello.com'), findsOneWidget);

      await emitState(
          tester,
          bloc,
          ResetPasswordMyUserLoadingState(cpfValido, bloc.state.reset, bloc.state.step),
          settle: false);
      expect(find.byType(LoadingWidget), findsOneWidget);
    });

    testWidgets('sem contatos não desenha nada', (tester) async {
      startWithCpf();
      harness.mockDados2fa();
      await pumpWidgetUnderTest(tester, me());

      expect(find.text('registration_lello_user_title'), findsNothing);
      expect(bloc.state, isA<ResetPasswordMyUserNoPhoneFailedState>());
    });

    testWidgets('pedindo código e código pedido mostram as telas próprias',
        (tester) async {
      startWithCpf();
      harness.mockDados2fa(sms: [contact('s1', '1')]);
      harness.mockValidate2fa();
      await pumpWidgetUnderTest(tester, me());

      await emitState(
          tester,
          bloc,
          ResetPasswordRequestingCodeState(
              bloc.state.reset, bloc.state.step, bloc.state.cpf),
          settle: false);
      expect(find.byType(RequestValidationCodeLoading), findsOneWidget);

      await emitState(
          tester,
          bloc,
          ResetPasswordRequestCodeSucceededState(
              bloc.state.reset, bloc.state.step, cpfValido, buildCodeRequest()),
          settle: false);
      expect(find.byType(CodeValidationPage), findsOneWidget);

      await tester.enterText(find.byType(EditableText), '123456');
      await tester.pump();
      await tester.pump();
      await tester.pump();

      expect(harness.requestedPaths.last, '/code_request/2fa/validate');
      expect(bloc.state.reset.codeValidationId, 'K1');
      expect(bloc.state.step, PasswordResetStep.password);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('reiniciar a validação busca os contatos de novo',
        (tester) async {
      startWithCpf();
      harness.mockDados2fa(sms: [contact('s1', '1')]);
      await pumpWidgetUnderTest(tester, me());
      await emitState(
          tester,
          bloc,
          ResetPasswordRequestCodeSucceededState(
              bloc.state.reset, bloc.state.step, cpfValido, buildCodeRequest()),
          settle: false);

      for (var i = 0; i < 60; i++) {
        await tester.pump(const Duration(seconds: 1));
      }
      await tester.ensureVisible(find.text('resend_sms (00:00)'));
      await tester.tap(find.text('resend_sms (00:00)'));
      await tester.pumpAndSettle();

      expect(harness.requestedPaths.last, '/code_request/2fa/$cpfDigitos');
      expect(harness.requestedPaths, hasLength(2));
      await tester.pumpWidget(const SizedBox());
    });
  });

  group('ResetPasswordNewPassword', () {
    Widget newPassword({Validator? validator}) => ResetPasswordNewPassword(
        resetPasswordController: controller,
        validator: validator,
        appOriginEnum: AppOriginEnum.owner);

    testWidgets('senhas diferentes mostram a validação', (tester) async {
      start();
      bloc.state.cpf = cpfValido;
      await pumpWidgetUnderTest(
          tester, newPassword(validator: harness.container.resolve()));

      expect(find.text('registration_password_title'), findsOneWidget);
      expect(find.text('confirm_password'), findsOneWidget);

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(1), 'a');
      await tester.enterText(fields.at(2), 'b');
      await tester.tap(find.widgetWithText(ElevatedButton, 'finish'));
      await tester.pumpAndSettle();

      expect(find.text('validation_invalid_password_confirmation'),
          findsOneWidget);
      expect(harness.http.requests, isEmpty);
    });

    testWidgets('campos vazios não passam na validação', (tester) async {
      start();
      await pumpWidgetUnderTest(
          tester, newPassword(validator: harness.container.resolve()));

      await tester.tap(find.widgetWithText(ElevatedButton, 'finish'));
      await tester.pumpAndSettle();

      expect(harness.http.requests, isEmpty);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('alterna a visibilidade das senhas e envia pelo teclado',
        (tester) async {
      start();
      harness.mockChangePassword(status: 500, body: apiFailureBody());
      bloc.state.reset
        ..cpf = cpfDigitos
        ..token = 't';
      await pumpWidgetUnderTest(tester, newPassword());

      expect(find.byIcon(Icons.visibility_off), findsNWidgets(2));
      await tester.tap(find.byIcon(Icons.visibility_off).first);
      await tester.pump();
      await tester.tap(find.byIcon(Icons.visibility_off).last);
      await tester.pump();
      expect(find.byIcon(Icons.visibility), findsNWidgets(2));

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(1), 'Senha123');
      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pump();
      await tester.enterText(fields.at(2), 'Senha123');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(harness.requestedPaths, ['/change_password']);
      expect(bloc.state, isA<ResetPasswordFailedState>());
    });

    testWidgets('falha ao redefinir mostra a mensagem de erro', (tester) async {
      start();
      harness.mockChangePassword(status: 500, body: apiFailureBody());
      bloc.state.reset
        ..cpf = cpfDigitos
        ..token = 't';
      await pumpWidgetUnderTest(tester, newPassword());

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(1), 'Senha123');
      await tester.enterText(fields.at(2), 'Senha123');
      await tester.tap(find.widgetWithText(ElevatedButton, 'finish'));
      await tester.pumpAndSettle();

      expect(harness.requestedPaths, ['/change_password']);
            expect(find.textContaining('Não foi possível resetar sua senha'),
          findsOneWidget);
    });

    /// Defeito: o widget lê o estado do bloc no `build` mas só escuta com
    /// `BlocListener`; a troca do botão pelo indicador depende de um rebuild
    /// externo (no fluxo real, do `setState` que limpa o erro antes do envio).
    testWidgets('enquanto redefine mostra o indicador só após um rebuild',
        (tester) async {
      start();
      await pumpWidgetUnderTest(tester, newPassword());
      await emitState(
          tester,
          bloc,
          ResetPasswordResettingPasswordState(
              bloc.state.reset, bloc.state.step, bloc.state.cpf, null),
          settle: false);

      // Comportamento atual: sem rebuild o botão continua na tela.
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('finish'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.visibility_off).first);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('finish'), findsNothing);
    });
  });

  group('PasswordResetCpf', () {
    testWidgets('digitação e envio pelo teclado avançam de passo',
        (tester) async {
      start();
      await pumpWidgetUnderTest(
          tester,
          PasswordResetCpf(
              resetPasswordController: controller,
              validator: harness.container.resolve()));

      await tester.enterText(find.byType(TextFormField), cpfValido);
      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pumpAndSettle();

      expect(bloc.state.step, PasswordResetStep.me);
      expect(bloc.state.cpf, cpfValido);
    });
  });
}
