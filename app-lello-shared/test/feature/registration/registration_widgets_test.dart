import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_features/feature/registration/presentation/store/registration_store.dart';
import 'package:shared_features/shared_features.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

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

  Validator validator() => harness.container.resolve<Validator>();

  Future<void> pumpPushed(WidgetTester tester, Widget page) async {
    await tester.pumpWidget(const SizedBox());
    await pumpPage(
      tester,
      Builder(
        builder: (context) => Scaffold(
          body: ElevatedButton(
            key: _launcherKey,
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              settings: const RouteSettings(name: '/pagina'),
              builder: (_) => page,
            )),
            child: const Text('abrir'),
          ),
        ),
      ),
      observer: observer,
      surface: const Size(500, 1000),
      providers: withTestAssets,
    );
    await tester.tap(find.byKey(_launcherKey));
    await tester.pumpAndSettle();
  }

  group('RegistrationPhone', () {
    testWidgets('valida e devolve o telefone no callback', (tester) async {
      final phones = <String>[];
      await pumpApp(
        tester,
        RegistrationPhone(
          callback: phones.add,
          phone: '(11)988887777',
          validator: validator(),
          appOriginEnum: AppOriginEnum.employee,
        ),
        surface: const Size(500, 900),
      );
      expect(find.text('registration_phone_title'), findsOneWidget);
      expect(find.text('registration_phone_description'), findsOneWidget);
      expect(find.text('cellphone_number'), findsOneWidget);

      await tester.tap(find.text('next'));
      await tester.pumpAndSettle();
      expect(phones, ['(11)988887777']);

      await expectLater(
        findGoldenSurface(),
        matchesGoldenFile('goldens/registration_phone.png'),
      );
    });

    testWidgets('telefone vazio não passa na validação', (tester) async {
      final phones = <String>[];
      await pumpApp(
        tester,
        RegistrationPhone(
            callback: phones.add, phone: '', validator: validator()),
        surface: const Size(500, 900),
      );
      await tester.enterText(find.byType(TextFormField).last, '9');
      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pumpAndSettle();
      expect(phones, isEmpty);
      expect(find.text('validation_required'), findsOneWidget);
    });
  });

  group('RegistrationPhoneEmailEmptyDialog', () {
    testWidgets('golden', (tester) async {
      await pumpApp(tester, withTestAssets(const RegistrationPhoneEmailEmptyDialog()),
          wrapInScaffold: false, surface: const Size(500, 700));
      expect(find.text('registration_phone_email_empty_dialog_description'),
          findsOneWidget);
      await expectLater(
        findGoldenSurface(),
        matchesGoldenFile('goldens/registration_phone_email_empty_dialog.png'),
      );
    });
  });

  group('RegistrationUseTermsDialog', () {
    Future<void> pumpDialog(
      WidgetTester tester, {
      bool isGeneric = false,
      String appName = '',
      String? customTermsUrl,
      bool useViewButton = false,
      Map<String, String> locOverrides = const {},
    }) async {
      await tester.pumpWidget(const SizedBox());
      await pumpPage(
        tester,
        Builder(
          builder: (context) => Scaffold(
            body: ElevatedButton(
              key: _launcherKey,
              onPressed: () => showDialog(
                context: context,
                builder: (_) => RegistrationUseTermsDialog(
                  isGeneric: isGeneric,
                  appName: appName,
                  customTermsUrl: customTermsUrl,
                  useViewButton: useViewButton,
                ),
              ),
              child: const Text('abrir'),
            ),
          ),
        ),
        observer: observer,
        surface: const Size(500, 1000),
        locOverrides: locOverrides,
        providers: withTestAssets,
      );
      await tester.tap(find.byKey(_launcherKey));
      await tester.pumpAndSettle();
    }

    testWidgets('mostra os textos padrão e cancelar fecha', (tester) async {
      await pumpDialog(tester);
      expect(find.text('registration_use_terms_subtitle'), findsOneWidget);
      expect(find.text('registration_use_terms_part_1'), findsOneWidget);
      expect(find.text('registration_use_terms_part_2'), findsOneWidget);
      expect(find.text('registration_use_terms_download_text'), findsOneWidget);
      expect(find.text('registration_use_terms_share'), findsOneWidget);
      expect(find.text('registration_use_terms_download'), findsOneWidget);
      expect(find.text('registration_use_terms_view'), findsNothing);

      await expectLater(
        find.byType(RegistrationUseTermsDialog),
        matchesGoldenFile('goldens/registration_use_terms_dialog.png'),
      );

      await tester.tap(find.text('cancel'));
      await tester.pumpAndSettle();
      expect(find.byType(RegistrationUseTermsDialog), findsNothing);
    });

    testWidgets('app genérico troca "Lello" pelo nome do app', (tester) async {
      const overrides = {
        'registration_use_terms_part_1': 'Termos da Lello',
        'registration_use_terms_part_2': 'A Lello agradece',
      };
      await pumpDialog(tester,
          isGeneric: true, appName: 'Viver', locOverrides: overrides);
      expect(find.text('Termos da Viver'), findsOneWidget);
      expect(find.text('A Viver agradece'), findsOneWidget);

      await tester.tap(find.text('cancel'));
      await tester.pumpAndSettle();
      await pumpDialog(tester, isGeneric: true, locOverrides: overrides);
      expect(find.text('Termos da Lello'), findsOneWidget);

      await tester.tap(find.text('cancel'));
      await tester.pumpAndSettle();
      await pumpDialog(tester, locOverrides: overrides);
      expect(find.text('Termos da Lello'), findsOneWidget);
    });

    testWidgets('compartilhar baixa o PDF dos termos e abre o share',
        (tester) async {
      final requested = <Uri>[];
      final client = MockClient((request) async {
        requested.add(request.url);
        return http.Response.bytes([1, 2, 3], 200);
      });
      await pumpDialog(tester);

      await tester.runAsync(() => http.runWithClient(() async {
            await tester.tap(find.text('registration_use_terms_share'));
            await Future<void>.delayed(const Duration(milliseconds: 300));
          }, () => client));
      await tester.pumpAndSettle();

      expect(requested.single.toString(), 'https://lello.com.br/termos.pdf');
      expect(harness.remoteConfig.fetches, 1);
      final params = harness.share.shared.single;
      expect(params.files!.single.path, endsWith('termos.pdf'));
      expect(params.sharePositionOrigin, isNotNull);
      expect(harness.tempDir.listSync().map((f) => f.path.split('/').last),
          ['termos.pdf']);
    });

    testWidgets('sem permissão de armazenamento não compartilha nem baixa',
        (tester) async {
      harness.permissions.status = PermissionStatus.denied;
      // O pedido de permissão do fake concede; aqui negamos sempre.
      await pumpDialog(tester);
      final client = MockClient((request) async => http.Response('', 500));
      await tester.runAsync(() => http.runWithClient(() async {
            await tester.tap(find.text('registration_use_terms_share'));
            await Future<void>.delayed(const Duration(milliseconds: 100));
          }, () => client));
      await tester.pumpAndSettle();
      // O fake concede na segunda checagem, então o fluxo segue e falha no
      // download: a exceção fica na future do `.then`.
      expect(harness.permissions.requestCount, 1);
    });

    testWidgets('visualizar abre a URL customizada no navegador',
        (tester) async {
      await pumpDialog(tester,
          useViewButton: true, customTermsUrl: 'https://hubert.com/termos');
      expect(find.text('registration_use_terms_view'), findsOneWidget);
      expect(find.text('registration_use_terms_share'), findsNothing);
      expect(find.text('registration_use_terms_download_text'), findsNothing);

      await tester.tap(find.text('registration_use_terms_view'));
      await tester.pumpAndSettle();
      expect(find.byType(RegistrationUseTermsDialog), findsNothing);
      expect(harness.launcher.launched, ['https://hubert.com/termos']);
    });

    testWidgets('visualizar sem URL ou sem app para abrir só fecha',
        (tester) async {
      await pumpDialog(tester, useViewButton: true);
      await tester.tap(find.text('registration_use_terms_view'));
      await tester.pumpAndSettle();
      expect(harness.launcher.launched, isEmpty);

      harness.launcher.result = false;
      await pumpDialog(tester,
          useViewButton: true, customTermsUrl: 'https://hubert.com/termos');
      await tester.tap(find.text('registration_use_terms_view'));
      await tester.pumpAndSettle();
      expect(harness.launcher.launched, isEmpty);
    });
  });

  group('RegistrationUseTerms', () {
    testWidgets('carrega os termos numa WebView', (tester) async {
      await pumpPushed(tester, RegistrationUseTerms());
      expect(find.text('registration_use_terms_title'), findsOneWidget);
      expect(find.byKey(const Key('fake-webview')), findsOneWidget);
      final controller = harness.webView.controllers.single;
      expect(controller.javaScriptMode, JavaScriptMode.unrestricted);
      // Corrigido: a configuração da WebView ficou no `initState`, então o
      // `loadRequest` acontece uma única vez (antes era refeito a cada build).
      expect(controller.loaded, hasLength(1));
      expect(controller.loaded.single.toString(),
          'https://www.lellocondominios.com.br/termos-de-uso/');

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.byType(RegistrationUseTerms), findsNothing);
      expect(observer.popped, isNotEmpty);
    });
  });

  group('RegistrationPicture', () {
    late RegistrationStore store;

    setUp(() {
      store = harness.buildStore()
        ..cpf = cpfValido
        ..password = 'Senha1';
    });

    Future<void> pumpPicture(WidgetTester tester,
        {bool isGeneric = false, AppOriginEnum? origin}) async {
      await tester.pumpWidget(const SizedBox());
      await pumpApp(
        tester,
        withTestAssets(RegistrationPicture(
          store: store,
          validator: validator(),
          isGeneric: isGeneric,
          appOriginEnum: origin,
        )),
        surface: const Size(500, 900),
      );
    }

    testWidgets('sem foto mostra câmera e galeria', (tester) async {
      await pumpPicture(tester, isGeneric: true);
      expect(find.text('camera'), findsOneWidget);
      expect(find.text('gallery'), findsOneWidget);
      expect(find.text('edit'), findsNothing);

      await tester.tap(find.text('camera'));
      await tester.pumpAndSettle();
      expect(harness.picker.sources, [ImageSource.camera]);
      expect(store.profilePicture, isNull);

      await expectLater(
        findGoldenSurface(),
        matchesGoldenFile('goldens/registration_picture.png'),
      );
    });

    testWidgets('com foto mostra a prévia; editar limpa a foto',
        (tester) async {
      store.profilePicture = harness.writeImage('perfil.png');
      await pumpPicture(tester, origin: AppOriginEnum.employee);
      expect(find.text('edit'), findsOneWidget);
      expect(find.text('camera'), findsNothing);

      await tester.tap(find.text('edit'));
      await tester.pumpAndSettle();
      expect(store.profilePicture, isNull);

      /// Corrigido: "editar" limpa a foto dentro de um `setState`, então a
      /// prévia sai da tela e as opções de câmera/galeria voltam.
      expect(find.text('edit'), findsNothing);
      expect(find.text('camera'), findsOneWidget);
      expect(find.text('gallery'), findsOneWidget);
    });

    testWidgets('concluir envia com a foto e "depois" envia sem',
        (tester) async {
      harness.mockRegistration();
      store.profilePicture = harness.writeImage('perfil.png');
      await pumpPicture(tester);

      await tester.tap(find.text('finish'));
      await tester.pumpAndSettle();
      expect(harness.upload.files.single!.path, endsWith('perfil.png'));
      expect(harness.session.loads, 1);

      store.profilePicture = harness.writeImage('outra.png');
      await tester.tap(find.text('do_this_later'));
      await tester.pumpAndSettle();
      expect(store.profilePicture, isNull);
      expect(harness.upload.files, hasLength(1));
      expect(harness.session.loads, 2);
    });
  });

  group('RegistrationPassword', () {
    late RegistrationStore store;

    setUp(() {
      store = harness.buildStore();
    });

    Future<void> pumpPassword(WidgetTester tester,
        {bool isGeneric = false, AppOriginEnum? origin}) async {
      await pumpApp(
        tester,
        RegistrationPassword(
          store: store,
          validator: validator(),
          isGeneric: isGeneric,
          appOriginEnum: origin,
        ),
        surface: const Size(500, 900),
      );
    }

    testWidgets('campos vazios não avançam', (tester) async {
      await pumpPassword(tester, isGeneric: true);
      await tester.tap(find.text('next'));
      await tester.pumpAndSettle();
      expect(find.text('validation_required'), findsNWidgets(2));
      expect(store.password, isNull);
      expect(store.currentStep, RegistrationStep.cpf);

      await expectLater(
        findGoldenSurface(),
        matchesGoldenFile('goldens/registration_password.png'),
      );
    });

    testWidgets('falha do cadastro mostra o erro e loading esconde o botão',
        (tester) async {
      await pumpPassword(tester, origin: AppOriginEnum.employee);
      await emitState(
          tester, store.bloc, RegistrationFailedState(error: UnknownFailure('deu ruim')));
      expect(find.text('deu ruim'), findsOneWidget);

      await emitState(tester, store.bloc, const RegistrationLoadingState(),
          settle: false);
      expect(find.text('next'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('registration_sending_data'), findsOneWidget);
    });
  });

  group('RegistrationMeWidget', () {
    late RegistrationStore store;

    setUp(() {
      store = harness.buildStore()..cpf = cpfValido;
    });

    Future<void> pumpMe(WidgetTester tester,
        {bool isGeneric = false,
        AppOriginEnum? origin,
        bool settle = true}) async {
      await pumpApp(
        tester,
        SizedBox(
          height: 800,
          child: RegistrationMeWidget(
            store: store,
            appContainer: harness.container,
            validator: validator(),
            isGeneric: isGeneric,
            appOriginEnum: origin,
          ),
        ),
        surface: const Size(500, 900),
        settle: settle,
      );
    }

    testWidgets('estados de loading e vazio', (tester) async {
      await pumpMe(tester, isGeneric: true);
      expect(find.text('registration_lello_user_title'), findsNothing);

      await emitState(tester, store.bloc,
          const RegistrationRequestMyUserLoadingState(),
          settle: false);
      expect(find.text('registration_sending_data'), findsOneWidget);

      store.source = CodeValidationSource.phone;
      await emitState(
          tester, store.bloc, const RegistrationCodeRequestLoadingState(),
          settle: false);
      expect(find.text('registration_sending_sms'), findsOneWidget);

      store.source = CodeValidationSource.email;
      await emitState(tester, store.bloc, const RegistrationEmptyState(),
          settle: false);
      await emitState(
          tester, store.bloc, const RegistrationCodeRequestLoadingState(),
          settle: false);
      expect(find.text('registration_sending_email'), findsOneWidget);
    });

    testWidgets('só e-mails ou só telefones', (tester) async {
      await pumpMe(tester, origin: AppOriginEnum.employee);
      await emitState(
          tester,
          store.bloc,
          RegistrationRequestMyUserSucceededState(
              codeData: buildCodeData(sms: []), selectedValue: ''));
      expect(find.text('registration_lello_user_email_title'), findsOneWidget);
      expect(find.text('registration_lello_user_phone_title'), findsNothing);

      await emitState(
          tester,
          store.bloc,
          RegistrationRequestMyUserSucceededState(
              codeData: buildCodeData(emails: []), selectedValue: 'x'));
      expect(find.text('registration_lello_user_email_title'), findsNothing);
      expect(find.text('registration_lello_user_phone_title'), findsOneWidget);

      // Sem contato algum o widget não mostra a lista.
      await emitState(
          tester,
          store.bloc,
          RegistrationRequestMyUserSucceededState(
              codeData: buildCodeData(emails: [], sms: []), selectedValue: ''));
      expect(find.text('registration_lello_user_title'), findsNothing);
    });

    testWidgets('reenviar o código pede um novo pedido de 2FA', (tester) async {
      harness.mockRequest2fa();
      store
        ..phone = '11988887777'
        ..source = CodeValidationSource.phone
        ..emailOrPhoneSelected = CodeDataContact(key: 'K1', value: '119');
      await pumpMe(tester, settle: false);
      await emitState(
          tester,
          store.bloc,
          RegistrationCodeRequestSucceededState(
              codeRequest: phoneRequest(id: 'K1')),
          settle: false);
      expect(find.byType(CodeValidationPage), findsOneWidget);

      for (var i = 0; i < 60; i++) {
        await tester.pump(const Duration(seconds: 1));
      }
      await tester.tap(find.text('resend_sms (00:00)'));
      await tester.pump();
      await tester.pump();
      expect(harness.requestedPaths, ['/code_request/2fa/request']);
      await tester.pumpWidget(const SizedBox());
    });
  });
}
