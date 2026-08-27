import 'dart:async';

import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/registration/presentation/store/registration_store.dart';
import 'package:shared_features/shared_features.dart';

import '../../helpers/pump_app.dart';
import 'registration_support.dart';

const _launcherKey = Key('launcher-push');

void main() {
  late RegistrationHarness harness;
  late RecordingNavigatorObserver observer;

  setUp(() async {
    harness = await installRegistrationHarness();
    observer = RecordingNavigatorObserver();
  });

  /// Empilha [page] sobre uma tela inicial (para `Navigator.pop` e o botão
  /// voltar terem para onde ir).
  Future<void> pumpPushed(
    WidgetTester tester,
    Widget page, {
    Object? arguments,
    String name = '/pagina',
    bool settle = true,
  }) async {
    await tester.pumpWidget(const SizedBox());
    await pumpPage(
      tester,
      Builder(
        builder: (context) => Scaffold(
          body: ElevatedButton(
            key: _launcherKey,
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              settings: RouteSettings(name: name, arguments: arguments),
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
    if (settle) {
      await tester.pumpAndSettle();
    } else {
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
    }
  }

  group('RegistrationFailurePage', () {
    testWidgets('mostra o erro e o botão fecha a página', (tester) async {
      await pumpPushed(tester, RegistrationFailurePage());
      expect(find.text('registration_failed_title'), findsOneWidget);
      expect(find.text('registration_failed_error'), findsOneWidget);

      await expectLater(
        find.byType(RegistrationFailurePage),
        matchesGoldenFile('goldens/registration_failure_page.png'),
      );

      await tester.tap(find.text('registration_lello_warning_cta_secondary'));
      await tester.pumpAndSettle();
      expect(observer.popped, hasLength(1));
      expect(find.byType(RegistrationFailurePage), findsNothing);
    });
  });

  group('RegistrationSucceedPage', () {
    testWidgets('mostra o sucesso e "login" vai para a home', (tester) async {
      await pumpPage(tester, RegistrationSucceedPage(),
          observer: observer, providers: withTestAssets);
      expect(find.text('registration_success_title'), findsOneWidget);

      await expectLater(
        find.byType(RegistrationSucceedPage),
        matchesGoldenFile('goldens/registration_succeeded_page.png'),
      );

      await tester.tap(find.text('login'));
      await tester.pumpAndSettle();
      expect(observer.pushedNames.last, SharedApplicationRoute.home);
      expect(findRoute(SharedApplicationRoute.home), findsOneWidget);
      expect(find.byType(RegistrationSucceedPage, skipOffstage: false),
          findsNothing);
    });
  });

  group('RegistrationLelloUserWarningPage', () {
    late RegistrationStore store;

    setUp(() {
      store = harness.buildStore();
    });

    Future<void> pumpWarning(
      WidgetTester tester, {
      RegistrationState? state,
      AppOriginEnum origin = AppOriginEnum.owner,
      bool settle = true,
    }) async {
      if (state != null) {
        // ignore: invalid_use_of_visible_for_testing_member
        store.bloc.emit(state);
      }
      await pumpPushed(
        tester,
        RegistrationLelloUserWarningPage(
          appContainer: harness.container,
          appOriginEnum: origin,
        ),
        arguments: RegistrationLelloUserWarningPageArgs(store: store),
        name: SharedApplicationRoute.registrationWarning,
        settle: settle,
      );
    }

    testWidgets('usuário já cadastrado', (tester) async {
      await pumpWarning(tester,
          state: RegistrationRequestMyUserFailedState(
              error: RegistrationUserAlreadyRegisteredFailure()));
      expect(find.text('registration_lello_warning_registered_title'),
          findsOneWidget);
      expect(find.text('registration_lello_warning_registered_subtitle'),
          findsOneWidget);
      await expectLater(
        find.byType(RegistrationLelloUserWarningPage),
        matchesGoldenFile('goldens/registration_warning_registered.png'),
      );
    });

    testWidgets('usuário não encontrado e botão primário fecha', (tester) async {
      await pumpWarning(tester,
          state: RegistrationRequestMyUserFailedState(
              error: RegistrationUserNotFoundFailure()));
      expect(find.text('registration_lello_warning_title'), findsOneWidget);
      expect(find.text('registration_lello_warning_subtitle'), findsOneWidget);

      await tester.tap(find.text('registration_lello_warning_cta_primary'));
      await tester.pumpAndSettle();
      expect(observer.popped, hasLength(1));
      expect(find.byType(RegistrationLelloUserWarningPage), findsNothing);
    });

    /// Monta a página com um único frame (a tela quebra no layout e cada
    /// frame geraria uma nova exceção).
    Future<void> pumpBroken(WidgetTester tester, Failure error) async {
      // ignore: invalid_use_of_visible_for_testing_member
      store.bloc.emit(RegistrationRequestMyUserFailedState(error: error));
      await pumpPage(
        tester,
        RegistrationLelloUserWarningPage(
          appContainer: harness.container,
          appOriginEnum: AppOriginEnum.owner,
        ),
        arguments: RegistrationLelloUserWarningPageArgs(store: store),
        settle: false,
        providers: withTestAssets,
      );
    }

    testWidgets('rollout bloqueado', (tester) async {
      /// Defeito: o ramo de rollout bloqueado devolve um `Scaffold` dentro
      /// de uma `Column` rolável (altura infinita) e a tela quebra no layout
      /// ("RenderCustomMultiChildLayoutBox object was given an infinite
      /// size").
      await pumpBroken(tester, RegistrationLockedRolloutFailure());
      // Cada render object do Scaffold relata o erro: várias exceções.
      final error = tester.takeException();
      expect(error, isNotNull);
      expect(error.toString(), contains('Multiple exceptions'));
      await tester.pumpWidget(const SizedBox());
      tester.takeException();
    });

    testWidgets('sem e-mail e telefone', (tester) async {
      /// Defeito: mesmo problema do rollout — `Scaffold` aninhado numa
      /// `Column` rolável, a tela quebra no layout.
      await pumpBroken(tester, RegistrationPhoneAndEmailFoundFailure());
      final error = tester.takeException();
      expect(error, isNotNull);
      expect(error.toString(), contains('Multiple exceptions'));
      await tester.pumpWidget(const SizedBox());
      tester.takeException();
    });

    testWidgets('outra falha de busca mostra erro desconhecido',
        (tester) async {
      await pumpWarning(tester,
          state: RegistrationRequestMyUserFailedState(
              error: UnknownFailure('x')));
      expect(find.text('registration_failed_title'), findsOneWidget);
      expect(find.text('error_unknown'), findsOneWidget);
    });

    testWidgets('falha de autenticação', (tester) async {
      await pumpWarning(tester,
          state: RegistrationAuthFailedState(error: RegistrationAuthFailure()));
      expect(find.text('registration_failed_auth_title'), findsOneWidget);
      expect(find.text('registration_failed_auth_message'), findsOneWidget);
    });

    testWidgets('outro estado não mostra texto e o secundário vai ao login',
        (tester) async {
      store.cpf = cpfValido;
      await pumpWarning(tester);
      expect(find.text('registration_failed_title'), findsNothing);
      expect(find.text('registration_lello_warning_title'), findsNothing);

      await tester.tap(find.text('registration_lello_warning_cta_secondary'));
      await tester.pumpAndSettle();
      expect(store.cpf, isNull);
      expect(observer.pushedNames.last, SharedApplicationRoute.login);
      expect(findRoute(SharedApplicationRoute.login), findsOneWidget);
      expect(find.byKey(_launcherKey, skipOffstage: false), findsNothing);
    });

    testWidgets('voltar limpa a store e substitui pela tela de login',
        (tester) async {
      store
        ..cpf = cpfValido
        ..currentStep = RegistrationStep.me;
      await pumpWarning(tester,
          state: RegistrationRequestMyUserFailedState(
              error: RegistrationUserNotFoundFailure()));

      /// Defeito: o `onWillPop` faz `await pushReplacementNamed(login)` —
      /// a future só completa quando a tela de login for fechada — então o
      /// `maybePop` nunca termina (aqui não aguardamos o `handlePopRoute`).
      unawaited(tester.binding.handlePopRoute());
      await tester.pumpAndSettle();

      expect(store.cpf, isNull);
      expect(store.currentStep, RegistrationStep.cpf);
      expect(observer.pushedNames.last, SharedApplicationRoute.login);
      expect(find.byType(RegistrationLelloUserWarningPage), findsNothing);
    });

    test('número do WhatsApp por origem', () {
      RegistrationLelloUserWarningPage page(AppOriginEnum origin) =>
          RegistrationLelloUserWarningPage(
              appContainer: harness.container, appOriginEnum: origin);
      expect(page(AppOriginEnum.owner).getSupportWhatsappNumber,
          FlavorConfig.config.supportMoradorWhatsAppNumber);
      expect(page(AppOriginEnum.employee).getSupportWhatsappNumber,
          FlavorConfig.config.supportColaboradorWhatsAppNumber);
      expect(page(AppOriginEnum.manager).getSupportWhatsappNumber,
          FlavorConfig.config.supportSindicoWhatsAppNumber);
    });
  });

  group('RegistrationLelloUserNoDataPage', () {
    /// Textos curtos para a linha "• texto + link" caber na largura.
    const textosCurtos = {
      'registration_lello_warning_no_data_2': 'Acesse o ',
      'registration_lello_warning_no_data_2_click': 'portal',
    };

    Future<RegistrationBloc> pumpNoData(
      WidgetTester tester, {
      AppOriginEnum origin = AppOriginEnum.owner,
      Map<String, String> locOverrides = textosCurtos,
      bool settle = true,
    }) async {
      final bloc = RegistrationBloc();
      await tester.pumpWidget(const SizedBox());
      await pumpPage(
        tester,
        RegistrationLelloUserNoDataPage(appOriginEnum: origin),
        arguments: bloc,
        observer: observer,
        surface: const Size(500, 1000),
        providers: withTestAssets,
        locOverrides: locOverrides,
        settle: settle,
      );
      return bloc;
    }

    testWidgets('mostra as orientações e abre o portal e o WhatsApp',
        (tester) async {
      await pumpNoData(tester);
      expect(find.text('registration'), findsOneWidget);
      expect(find.text('registration_lello_warning_no_data_title'),
          findsOneWidget);
      expect(find.text('registration_lello_warning_no_data_1'), findsOneWidget);
      expect(find.text('• Acesse o '), findsOneWidget);
      expect(
          find.text(
              '• registration_lello_warning_no_data_3'.replaceAll(
                  '{email}', FlavorConfig.config.supportEmail)),
          findsOneWidget);
      expect(find.text('• registration_lello_warning_no_data_4'),
          findsOneWidget);

      await expectLater(
        find.byType(RegistrationLelloUserNoDataPage),
        matchesGoldenFile('goldens/registration_no_data_page.png'),
      );

      await tester.tap(find.text('portal'));
      await tester.pumpAndSettle();
      expect(harness.launcher.launched.last, 'https://resolvafacil.lello.com.br');
      expect(harness.remoteConfig.fetches, 1);
      expect(harness.remoteConfig.activations, 1);

      await tester.tap(find.text('registration_lello_warning_no_data_btn'));
      await tester.pumpAndSettle();
      expect(harness.launcher.launched.last,
          startsWith('https://wa.me/${FlavorConfig.config.supportMoradorWhatsAppNumber}/'));
      expect(harness.launcher.launched.last, contains('text=Oi'));
    });

    testWidgets('WhatsApp por origem e sem app instalado', (tester) async {
      await pumpNoData(tester, origin: AppOriginEnum.employee);
      await tester.tap(find.text('registration_lello_warning_no_data_btn'));
      await tester.pumpAndSettle();
      expect(harness.launcher.launched.last,
          contains(FlavorConfig.config.supportColaboradorWhatsAppNumber));

      await pumpNoData(tester, origin: AppOriginEnum.manager);
      harness.launcher.result = false;
      await tester.tap(find.text('registration_lello_warning_no_data_btn'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      // Sem WhatsApp o `Launch` mostra um aviso em vez de abrir a URL.
      expect(harness.launcher.launched.where(
          (u) => u.contains(FlavorConfig.config.supportSindicoWhatsAppNumber)),
          isEmpty);
      expect(find.text('cant_open_whatsapp'), findsOneWidget);
      await tester.pump(const Duration(seconds: 5));
      expect(
          RegistrationLelloUserNoDataPage(appOriginEnum: AppOriginEnum.manager)
              .getSupportWhatsappNumber,
          FlavorConfig.config.supportSindicoWhatsAppNumber);
    });

    testWidgets('com textos longos a linha do portal estoura a largura',
        (tester) async {
      /// Defeito: a linha "• texto + link do portal" é uma `Row` sem
      /// `Expanded`/`Wrap`; com textos maiores que a largura da tela o
      /// layout estoura ("A RenderFlex overflowed").
      await pumpNoData(tester, locOverrides: const {}, settle: false);
      final error = tester.takeException();
      expect(error, isA<FlutterError>());
      expect(error.toString(), contains('overflowed'));
      await tester.pumpWidget(const SizedBox());
      tester.takeException();
    });
  });
}
