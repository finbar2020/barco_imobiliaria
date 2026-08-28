import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/code_validation/presentation/store/code_validation_store.dart';
import 'package:shared_features/shared_features.dart';

import '../../helpers/pump_app.dart';
import 'code_validation_support.dart';

void main() {
  late CodeValidationHarness harness;
  late List<CodeValidation?> successes;
  late int restarts;

  setUp(() {
    mockSmsAutofill();
    harness = CodeValidationHarness();
    successes = [];
    restarts = 0;
  });

  Future<void> pumpValidation(
    WidgetTester tester, {
    CodeRequest? request,
    bool isGeneric = false,
    AppOriginEnum? appOrigin,
    int digits = 6,
  }) async {
    await pumpPage(
      tester,
      Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: CodeValidationPage(
            appContainer: harness.container,
            codeRequest: request ?? phoneRequest(),
            digits: digits,
            isGeneric: isGeneric,
            appOriginEnum: appOrigin,
            onSuccess: successes.add,
            onRestart: () => restarts++,
          ),
        ),
      ),
      settle: false,
    );
    await tester.pump();
  }

  /// Avança [seconds] segundos do timer de reenvio.
  Future<void> advance(WidgetTester tester, int seconds) async {
    for (var i = 0; i < seconds; i++) {
      await tester.pump(const Duration(seconds: 1));
    }
  }

  Future<void> enterCode(WidgetTester tester, String code) async {
    await tester.enterText(find.byType(EditableText), code);
    await tester.pump();
    await tester.pump();
  }

  /// Desmonta a página para cancelar o timer periódico do reenvio.
  Future<void> unmount(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
  }

  testWidgets('mostra o telefone mascarado, o aviso e o timer', (tester) async {
    await pumpValidation(tester);

    expect(find.text('code_validation_title'), findsOneWidget);
    expect(find.text('11****7777'), findsOneWidget);
    expect(find.text('next'), findsOneWidget);
    expect(find.text('did_not_receive'), findsOneWidget);
    expect(find.text('resend_sms (00:59)'), findsOneWidget);
    expect(find.textContaining('tente receber o código por email'),
        findsOneWidget);
    expect(find.text('error_invalid_code'), findsNothing);
    expect(harness.lastStore!.request!.id, 'K1');

    await expectLater(
      find.byType(CodeValidationPage),
      matchesGoldenFile('goldens/code_validation_page.png'),
    );
    await unmount(tester);
  });

  testWidgets('mascara o e-mail e mantém valores já mascarados',
      (tester) async {
    await pumpValidation(tester, request: emailRequest());
    expect(find.text('ana*va@lello.com'), findsOneWidget);
    expect(find.textContaining('spam'), findsOneWidget);
    await unmount(tester);

    await pumpValidation(tester,
        request: phoneRequest(value: '11****1234'), isGeneric: true);
    expect(find.text('11****1234'), findsOneWidget);
    await unmount(tester);

    await pumpValidation(tester,
        request: emailRequest(
            value: 'jo**@x.com', origin: CodeValidationOrigin.changeNumber),
        appOrigin: AppOriginEnum.employee);
    expect(find.text('jo**@x.com'), findsOneWidget);
    expect(find.textContaining('bloqueados'), findsOneWidget);
    expect(find.textContaining('email'), findsNothing);
    await unmount(tester);
  });

  testWidgets('código completo valida pelo 2FA e chama onSuccess',
      (tester) async {
    harness.mockValidate2fa(token: 'TOK');
    await pumpValidation(tester);

    // Digitar parcialmente ainda não valida.
    await enterCode(tester, '123');
    expect(harness.http.requests, isEmpty);
    expect(find.text('next'), findsOneWidget);

    await enterCode(tester, '123456');
    await tester.pump();

    expect(harness.requestedPaths, ['/code_request/2fa/validate']);
    expect(successes, hasLength(1));
    expect(successes.single!.id, 'K1');
    expect(successes.single!.code, '123456');
    expect(successes.single!.token, 'TOK');
    await unmount(tester);
  });

  testWidgets('estado validando troca o botão pelo indicador', (tester) async {
    await pumpValidation(tester);
    final store = harness.lastStore!;

    // ignore: invalid_use_of_visible_for_testing_member
    store.bloc.emit(const CodeValidationValidatingState());
    await tester.pump();
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('next'), findsNothing);
    await unmount(tester);
  });

  testWidgets('código inválido mostra a mensagem de erro', (tester) async {
    harness.mockValidate2fa(status: 400, body: apiFailureBody(status: 400));
    await pumpValidation(tester);

    await enterCode(tester, '000000');
    await tester.pump();

    expect(find.text('error_invalid_code'), findsOneWidget);
    expect(find.text('next'), findsOneWidget);
    expect(successes, isEmpty);
    await unmount(tester);
  });

  testWidgets('estado de reenvio também chama onSuccess', (tester) async {
    await pumpValidation(tester);
    final store = harness.lastStore!;
    final validation = CodeValidation(id: 'R', code: '1');

    // ignore: invalid_use_of_visible_for_testing_member
    store.bloc.emit(CodeValidationResendState(validation: validation));
    await tester.pump();

    expect(successes, [validation]);
    await unmount(tester);
  });

  testWidgets('botão avançar só valida com o código completo', (tester) async {
    harness.mockValidate2fa(token: 'T');
    await pumpValidation(tester, digits: 4);

    await tester.tap(find.text('next'));
    await tester.pump();
    expect(harness.http.requests, isEmpty);

    await enterCode(tester, '1234');
    await tester.pump();
    expect(successes, hasLength(1));
    await unmount(tester);
  });

  testWidgets('código já preenchido na store inicializa os campos',
      (tester) async {
    harness.container.registerFactory<CodeValidationStore>(
        () => harness.buildStore()..code = '12');
    await pumpValidation(tester);
    expect(find.byType(CodeValidationInput), findsOneWidget);
    await unmount(tester);
  });

  testWidgets('reenviar só habilita depois da contagem regressiva',
      (tester) async {
    await pumpValidation(tester);

    await tester.tap(find.text('resend_sms (00:59)'));
    await tester.pump();
    expect(restarts, 0);

    await advance(tester, 30);
    expect(find.text('resend_sms (00:29)'), findsOneWidget);

    await advance(tester, 30);
    expect(find.text('resend_sms (00:00)'), findsOneWidget);

    await tester.tap(find.text('resend_sms (00:00)'));
    await tester.pump();
    expect(restarts, 1);

    // Com o timer encerrado o pumpAndSettle termina normalmente.
    await tester.pumpAndSettle();
    await unmount(tester);
  });

  group('RequestValidationCodeLoading', () {
    testWidgets('título por fonte', (tester) async {
      await pumpApp(tester,
          const RequestValidationCodeLoading(source: CodeValidationSource.phone),
          settle: false);
      expect(find.text('registration_sending_sms'), findsOneWidget);
      expect(find.text('please_wait'), findsOneWidget);

      await pumpApp(tester,
          const RequestValidationCodeLoading(source: CodeValidationSource.email),
          settle: false);
      expect(find.text('registration_sending_email'), findsOneWidget);

      await pumpApp(
          tester,
          const RequestValidationCodeLoading(
              source: CodeValidationSource.biometria),
          settle: false);
      expect(find.text(''), findsOneWidget);

      await pumpApp(tester, const RequestValidationCodeLoading(),
          settle: false);
      expect(find.text(''), findsOneWidget);
      await expectLater(
        findGoldenSurface(),
        matchesGoldenFile('goldens/request_validation_code_loading.png'),
      );
    });
  });
}
