import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/registration/presentation/store/registration_store.dart';
import 'package:shared_features/shared_features.dart';

import '../../helpers/pump_app.dart';
import '../code_validation/code_validation_support.dart';
import 'registration_support.dart';

const _launcherKey = Key('launcher-push');

void main() {
  late RegistrationHarness harness;
  late RecordingNavigatorObserver observer;

  setUp(() async {
    harness = await installRegistrationHarness();
    observer = RecordingNavigatorObserver();
  });

  RegistrationStore store() => harness.lastStore!;

  Future<void> pumpRegistration(
    WidgetTester tester, {
    AppOriginEnum origin = AppOriginEnum.owner,
    Future Function(BuildContext)? customTermsModal,
    bool pushed = false,
  }) async {
    final page = RegistrationPage(
      appOriginEnum: origin,
      appContainer: harness.container,
      customTermsModal: customTermsModal,
    );
    // Desmonta a árvore anterior: reaproveitar o MaterialApp manteria as
    // rotas (e a página) antigas no Navigator.
    await tester.pumpWidget(const SizedBox());
    Widget withAssets(Widget app) => withTestAssets(app);
    if (!pushed) {
      await pumpPage(tester, page,
          observer: observer,
          surface: const Size(500, 1000),
          providers: withAssets);
      return;
    }
    await pumpPage(
      tester,
      Builder(
        builder: (context) => Scaffold(
          body: ElevatedButton(
            key: _launcherKey,
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              settings: RouteSettings(name: SharedApplicationRoute.registration),
              builder: (_) => page,
            )),
            child: const Text('abrir'),
          ),
        ),
      ),
      observer: observer,
      surface: const Size(500, 1000),
      providers: withAssets,
    );
    await tester.tap(find.byKey(_launcherKey));
    await tester.pumpAndSettle();
  }

  /// Aceita os termos, digita o CPF e avança para a busca do usuário.
  Future<void> submitCpf(WidgetTester tester, {String cpf = cpfValido}) async {
    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), cpf);
    await tester.pumpAndSettle();
    await tester.tap(find.text('next'));
    await tester.pumpAndSettle();
  }

  /// Frames sem `pumpAndSettle`: a página de código tem um Timer periódico.
  Future<void> pumpFrames(WidgetTester tester, [int n = 6]) async {
    for (var i = 0; i < n; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  group('passo do CPF', () {
    testWidgets('renderiza o formulário com o botão desabilitado',
        (tester) async {
      await pumpRegistration(tester);

      expect(find.text('registration'), findsOneWidget);
      expect(find.text('registration_document_title'), findsOneWidget);
      expect(find.text('type_email_cnpj'), findsOneWidget);
      expect(find.text('registration_continue_declare'), findsOneWidget);
      expect(find.text('registration_terms_use_privacy_policies'),
          findsOneWidget);
      expect(find.text('error_registration_user_already_registered'),
          findsNothing);
      expect(store().currentStep, RegistrationStep.cpf);

      // Sem aceitar os termos o botão não chama a API.
      await tester.tap(find.text('next'));
      await tester.pumpAndSettle();
      expect(harness.http.requests, isEmpty);

      await expectLater(
        find.byType(RegistrationPage),
        matchesGoldenFile('goldens/registration_page_cpf.png'),
      );
    });

    testWidgets('CPF inválido não busca o usuário', (tester) async {
      await pumpRegistration(tester);
      await submitCpf(tester, cpf: '111.111.111-11');
      expect(harness.http.requests, isEmpty);
      expect(find.text('validation_invalid_cpf'), findsOneWidget);
    });

    testWidgets('submeter pelo teclado também avança', (tester) async {
      harness.mockDados2fa(status: 500, body: apiFailureBody());
      await pumpRegistration(tester);
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), cpfValido);
      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pumpAndSettle();
      expect(harness.requestedPaths, ['/code_request/2fa/$cpfDigitos']);
    });

    testWidgets('marcar e desmarcar os termos atualiza a store',
        (tester) async {
      await pumpRegistration(tester);
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      expect(store().termsAndConditionsCheck, isTrue);
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      expect(store().termsAndConditionsCheck, isFalse);
    });

    testWidgets('link dos termos abre o diálogo padrão', (tester) async {
      await pumpRegistration(tester);
      await tester.tap(find.text('registration_terms_use_privacy_policies'));
      await tester.pumpAndSettle();
      expect(find.byType(RegistrationUseTermsDialog), findsOneWidget);
      await tester.tap(find.text('cancel'));
      await tester.pumpAndSettle();
      expect(find.byType(RegistrationUseTermsDialog), findsNothing);
    });

    testWidgets('link dos termos usa o modal customizado', (tester) async {
      var chamadas = 0;
      await pumpRegistration(tester, customTermsModal: (_) async => chamadas++);
      await tester.tap(find.text('registration_terms_use_privacy_policies'));
      await tester.pumpAndSettle();
      expect(chamadas, 1);
      expect(find.byType(RegistrationUseTermsDialog), findsNothing);
    });

    testWidgets('pacote genérico e colaborador usam outros temas',
        (tester) async {
      await tester.pumpWidget(const SizedBox());
      harness = await installRegistrationHarness(
          packageName: 'app.lello.morar.viver');
      await pumpRegistration(tester);
      expect(find.byType(RegistrationCpf), findsOneWidget);

      await pumpRegistration(tester, origin: AppOriginEnum.employee);
      expect(find.byType(RegistrationCpf), findsOneWidget);
    });
  });

  group('busca do usuário', () {
    testWidgets('usuário já cadastrado vai para a página de aviso',
        (tester) async {
      harness.mockDados2fa(registered: true, sms: [contact('s', '1')]);
      await pumpRegistration(tester);
      await submitCpf(tester);

      expect(store().registeredError, isTrue);
      expect(store().currentStep, RegistrationStep.cpf);
      expect(observer.pushedNames.last, SharedApplicationRoute.registrationWarning);
      final args = observer.pushed.last.settings.arguments
          as RegistrationLelloUserWarningPageArgs;
      expect(args.store, same(store()));
    });

    testWidgets('sem e-mail nem telefone abre o diálogo de contato',
        (tester) async {
      harness.mockDados2fa();
      await pumpRegistration(tester);
      await submitCpf(tester);

      expect(find.byType(RegistrationPhoneEmailEmptyDialog), findsOneWidget);
      expect(find.text('attention!'), findsOneWidget);
      expect(find.text(FlavorConfig.config.supportEmail), findsOneWidget);
      expect(store().currentStep, RegistrationStep.cpf);

      await tester.tap(find.text(FlavorConfig.config.supportEmail));
      await tester.pumpAndSettle();
      expect(harness.launcher.launched.single,
          'mailto:${FlavorConfig.config.supportEmail}');

      await tester
          .tap(find.text('registration_phone_email_empty_dialog_confirm'));
      await tester.pumpAndSettle();
      expect(find.byType(RegistrationPhoneEmailEmptyDialog), findsNothing);
    });

    testWidgets('CPF não encontrado abre o diálogo do morador', (tester) async {
      harness.mockDados2fa(
          status: 404,
          body: apiFailureBody(status: 404, failure: 'user_not_found_failure'));
      await pumpRegistration(tester);
      await submitCpf(tester);

      expect(find.text('Não encontramos seu CPF'), findsOneWidget);
      expect(find.text('Se você é novo inquilino ou imobiliária'), findsOneWidget);
      expect(find.text('Se você é novo proprietário'), findsOneWidget);
      await tester.tap(find.text('Entendi'));
      await tester.pumpAndSettle();
      expect(find.text('Não encontramos seu CPF'), findsNothing);
      // Só o diálogo (rota sem nome) foi empilhado.
      expect(observer.pushedNames.whereType<String>().where(
          (n) => n.startsWith('/registration')), isEmpty);
    });

    testWidgets('diálogo de CPF não encontrado para colaborador',
        (tester) async {
      harness.mockDados2fa(
          status: 404,
          body: apiFailureBody(status: 404, failure: 'user_not_found_failure'));
      await pumpRegistration(tester, origin: AppOriginEnum.employee);
      await submitCpf(tester);
      expect(
          find.text(
              'Tente novamente ou verifique com o Síndico do seu Condomínio.'),
          findsOneWidget);
      await tester.tap(find.text('Entendi'));
      await tester.pumpAndSettle();
      expect(find.text('Não encontramos seu CPF'), findsNothing);
    });

    testWidgets('diálogo de CPF não encontrado para síndico', (tester) async {
      harness.mockDados2fa(
          status: 404,
          body: apiFailureBody(status: 404, failure: 'user_not_found_failure'));
      await pumpRegistration(tester, origin: AppOriginEnum.manager);
      await submitCpf(tester);
      expect(find.text('Tente novamente ou verifique com o seu atendimento.'),
          findsOneWidget);
      await tester.tap(find.text('Entendi'));
      await tester.pumpAndSettle();
      expect(find.text('Não encontramos seu CPF'), findsNothing);
    });

    testWidgets('outra falha navega para a página de aviso', (tester) async {
      harness.mockDados2fa(status: 500, body: apiFailureBody());
      await pumpRegistration(tester);
      await submitCpf(tester);

      expect(observer.pushedNames.last, SharedApplicationRoute.registrationWarning);
      final args = observer.pushed.last.settings.arguments
          as RegistrationLelloUserWarningPageArgs;
      expect(args.store, same(store()));
    });

    testWidgets('estado de busca mostra o loading', (tester) async {
      await pumpRegistration(tester);
      // O CircularProgressIndicator anima para sempre: sem pumpAndSettle.
      await emitState(tester, store().bloc,
          const RegistrationRequestMyUserLoadingState(loadingMessage: 'msg'),
          settle: false);
      expect(find.text('msg'), findsOneWidget);
      expect(find.text('please_wait'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await emitState(
          tester, store().bloc, const RegistrationRequestMyUserLoadingState(),
          settle: false);
      expect(find.text('registration_sending_data'), findsOneWidget);

      await emitState(tester, store().bloc, const RegistrationLoadingState(),
          settle: false);
      expect(find.text('registration_sending_data'), findsOneWidget);
      expect(find.byType(PageView), findsNothing);
    });
  });

  group('demais estados do listener', () {
    testWidgets('falha no pedido de código e no cadastro vão para a falha',
        (tester) async {
      await pumpRegistration(tester);
      final erro = UnknownFailure('x');

      await emitState(
          tester, store().bloc, RegistrationCodeRequestFailedState(error: erro));
      expect(observer.pushedNames.last, SharedApplicationRoute.registrationFailure);
      expect(observer.pushed.last.settings.arguments, same(erro));
      expect(findRoute(SharedApplicationRoute.registrationFailure), findsOneWidget);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      await emitState(tester, store().bloc, RegistrationFailedState(error: erro));
      expect(observer.pushedNames.last, SharedApplicationRoute.registrationFailure);
      expect(observer.pushedNames
          .where((n) => n == SharedApplicationRoute.registrationFailure), hasLength(2));
    });

    testWidgets('falha de autenticação vai para o aviso (substituindo a página)',
        (tester) async {
      await pumpRegistration(tester);
      await emitState(tester, store().bloc,
          RegistrationAuthFailedState(error: RegistrationAuthFailure()));
      expect(observer.pushedNames.last, SharedApplicationRoute.registrationWarning);
      expect(find.byType(RegistrationPage, skipOffstage: false), findsNothing);
    });

    testWidgets('falha de autenticação por CPF não encontrado (morador) abre o diálogo',
        (tester) async {
      await pumpRegistration(tester);
      await emitState(tester, store().bloc,
          RegistrationAuthFailedState(error: RegistrationUserNotFoundFailure()));
      expect(find.text('Não encontramos seu CPF'), findsOneWidget);
      expect(observer.pushedNames.whereType<String>().where(
          (n) => n.startsWith('/registration')), isEmpty);
    });

    testWidgets('sucesso limpa a store e vai para a página de sucesso',
        (tester) async {
      await pumpRegistration(tester);
      store().cpf = cpfValido;
      await emitState(tester, store().bloc, const RegistrationSucceededState());
      expect(observer.pushedNames.last, SharedApplicationRoute.registrationSuccess);
      expect(find.byType(RegistrationPage, skipOffstage: false), findsNothing);
      // O `dispose` zera o cpf, mas o formulário do CPF o normaliza para "".
      expect(store().cpf, '');
    });
  });

  group('navegação de volta', () {
    testWidgets('seta da AppBar no CPF vai para o login', (tester) async {
      await pumpRegistration(tester, pushed: true);
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(observer.pushedNames.last, SharedApplicationRoute.login);
      expect(findRoute(SharedApplicationRoute.login), findsOneWidget);
    });

    testWidgets('botão voltar do sistema no CPF fecha a página', (tester) async {
      await pumpRegistration(tester, pushed: true);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(observer.popped, hasLength(1));
      expect(find.byType(RegistrationPage), findsNothing);
    });

    testWidgets('num passo seguinte, voltar retorna ao passo anterior',
        (tester) async {
      harness.mockDados2fa(sms: [contact('s1', '(11) 98888-7777')]);
      await pumpRegistration(tester, pushed: true);
      await submitCpf(tester);
      expect(store().currentStep, RegistrationStep.me);
      expect(find.byType(RegistrationMeWidget), findsOneWidget);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(store().currentStep, RegistrationStep.cpf);
      expect(find.byType(RegistrationPage), findsOneWidget);
      expect(find.byType(RegistrationCpf), findsOneWidget);
      expect(observer.popped, isEmpty);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(findRoute(SharedApplicationRoute.login), findsOneWidget);
    });
  });

  group('fluxo completo', () {
    testWidgets('cadastra com telefone, código, senha e sem foto',
        (tester) async {
      harness.mockHappyPath();
      await pumpRegistration(tester);
      await submitCpf(tester);

      // Passo dos contatos.
      expect(find.text('registration_lello_user_title'), findsOneWidget);
      expect(find.text('registration_lello_user_email_title'), findsOneWidget);
      expect(find.text('registration_lello_user_phone_title'), findsOneWidget);
      expect(find.text('ana@lello.com'), findsOneWidget);
      expect(find.text('(11) 98888-7777'), findsOneWidget);
      expect(find.text('(11) 97777-6666'), findsOneWidget);

      // Sem seleção o botão não pede o código.
      await tester.tap(find.text('next'));
      await tester.pumpAndSettle();
      expect(harness.requestedPaths, hasLength(1));

      await tester.tap(find.text('ana@lello.com'));
      await tester.pumpAndSettle();
      expect(store().source, CodeValidationSource.email);
      expect(store().email, 'ana@lello.com');
      await tester.tap(find.text('(11) 98888-7777'));
      await tester.pumpAndSettle();
      expect(store().source, CodeValidationSource.phone);
      expect(store().phone, '(11) 98888-7777');
      expect(store().emailOrPhoneSelected!.key, 's1');

      await expectLater(
        find.byType(RegistrationPage),
        matchesGoldenFile('goldens/registration_page_contacts.png'),
      );

      await tester.tap(find.text('next'));
      await pumpFrames(tester);

      // Passo do código.
      expect(harness.requestedPaths.last, '/code_request/2fa/request');
      expect(find.byType(CodeValidationPage), findsOneWidget);
      expect(find.text('11****7777'), findsOneWidget);
      await tester.enterText(find.byType(EditableText), '123456');
      await pumpFrames(tester, 8);

      expect(harness.requestedPaths.last, '/code_request/2fa/validate');
      expect(store().codeValidationId, 's1');
      expect(store().token, 'TOKEN-OK');
      await tester.pumpAndSettle();

      // Passo da senha.
      expect(find.text('registration_password_title'), findsOneWidget);
      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'Senha123');
      await tester.enterText(fields.at(1), 'Senha123');
      await tester.tap(find.text('next'));
      await tester.pumpAndSettle();
      expect(store().password, 'Senha123');

      // Passo da foto.
      expect(find.text('registration_picture_title'), findsOneWidget);
      /// Corrigido: a validação do código chama `nextStep()` junto com a
      /// troca de página, então `currentStep` acompanha a página exibida.
      expect(store().currentStep, RegistrationStep.picture);
      expect(store().pageController.page, 3);
      expect(find.text('camera'), findsOneWidget);
      expect(find.text('gallery'), findsOneWidget);
      await tester.tap(find.text('do_this_later'));
      await tester.pumpAndSettle();

      expect(harness.requestedPaths.last, '/registration');
      expect(harness.authenticate.calls.single.username, cpfDigitos);
      expect(harness.session.loads, 1);
      expect(harness.upload.files, isEmpty);
      expect(observer.pushedNames.last, SharedApplicationRoute.registrationSuccess);
      expect(find.byType(RegistrationPage, skipOffstage: false), findsNothing);
      final body = harness.http.requests.last.body;
      expect(body, contains('"token":"TOKEN-OK"'));
      expect(body, contains('"phone":"(11) 98888-7777"'));
    });

    testWidgets('senhas diferentes mostram erro e a foto pode ser enviada',
        (tester) async {
      harness.mockHappyPath();
      harness.picker.path = '/tmp/origem.png';
      harness.cropper.path = harness.writeImage('recorte.png').path;
      await pumpRegistration(tester);
      await submitCpf(tester);
      await tester.tap(find.text('(11) 98888-7777'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('next'));
      await pumpFrames(tester);
      await tester.enterText(find.byType(EditableText), '123456');
      await pumpFrames(tester, 8);
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'Senha123');
      await tester.enterText(fields.at(1), 'Outra123');
      await tester.tap(find.text('next'));
      await tester.pumpAndSettle();
      expect(find.text('validation_invalid_password_confirmation'),
          findsOneWidget);
      expect(store().password, isNull);

      // Alternar a visibilidade das senhas.
      await tester.tap(find.byIcon(Icons.visibility_off).first);
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.visibility), findsOneWidget);
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.visibility), findsNWidgets(2));

      await tester.enterText(fields.at(1), 'Senha123');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.text('validation_invalid_password_confirmation'),
          findsNothing);

      // Foto pela galeria: recorta e envia o cadastro.
      await tester.tap(find.text('gallery'));
      await tester.pumpAndSettle();
      expect(harness.picker.sources, [ImageSource.gallery]);
      expect(harness.cropper.cropped, ['/tmp/origem.png']);
      expect(harness.upload.files.single!.path, endsWith('recorte.png'));
      expect(observer.pushedNames.last, SharedApplicationRoute.registrationSuccess);
    });
  });
}
