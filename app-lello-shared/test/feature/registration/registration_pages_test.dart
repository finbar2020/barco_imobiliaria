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
    Map<String, String> locOverrides = const {},
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
      locOverrides: locOverrides,
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

    /// Textos curtos para a linha "• texto + link" caber na largura.
    const textosCurtosPortal = {
      'registration_lello_warning_no_data_2': 'Acesse o ',
      'registration_lello_warning_no_data_2_click': 'portal',
    };

    Future<void> pumpWarning(
      WidgetTester tester, {
      RegistrationState? state,
      AppOriginEnum origin = AppOriginEnum.owner,
      Map<String, String> locOverrides = const {},
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
        locOverrides: locOverrides,
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

    testWidgets('rollout bloqueado', (tester) async {
      /// Corrigido: o ramo de rollout bloqueado devolve uma `Column` (antes
      /// era um `Scaffold` dentro da `Column` rolável, que quebrava o layout
      /// com "RenderBox was given an infinite size").
      await pumpWarning(tester,
          state: RegistrationRequestMyUserFailedState(
              error: RegistrationLockedRolloutFailure()));
      expect(tester.takeException(), isNull);
      expect(find.text('registration_lello_warning_rollout_title'),
          findsOneWidget);
      expect(find.text('registration_lello_warning_rollout_text'),
          findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('sem e-mail e telefone', (tester) async {
      /// Corrigido: mesmo ajuste do rollout — sem `Scaffold` aninhado a tela
      /// monta normalmente e mostra as orientações e o botão do WhatsApp.
      await pumpWarning(tester,
          state: RegistrationRequestMyUserFailedState(
              error: RegistrationPhoneAndEmailFoundFailure()),
          locOverrides: textosCurtosPortal);
      expect(tester.takeException(), isNull);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.text('registration_lello_warning_no_data_title'),
          findsOneWidget);
      expect(find.text('registration_lello_warning_no_data_1'), findsOneWidget);
      expect(find.text('• Acesse o '), findsOneWidget);
      expect(find.text('• registration_lello_warning_no_data_4'),
          findsOneWidget);

      await tester.tap(find.text('portal'));
      await tester.pumpAndSettle();
      expect(harness.launcher.launched.last,
          'https://resolvafacil.lello.com.br');

      await tester.tap(find.text('registration_lello_warning_no_data_btn'));
      await tester.pumpAndSettle();
      expect(harness.launcher.launched.last,
          startsWith('https://wa.me/'
              '${FlavorConfig.config.supportMoradorWhatsAppNumber}/'));
    });

    testWidgets('sem e-mail e telefone com textos longos não estoura',
        (tester) async {
      /// Corrigido: a linha "• texto + link do portal" usa `Wrap`, então os
      /// textos longos quebram em outra linha em vez de estourar a largura.
      await pumpWarning(tester,
          state: RegistrationRequestMyUserFailedState(
              error: RegistrationPhoneAndEmailFoundFailure()));
      expect(tester.takeException(), isNull);
      expect(find.text('registration_lello_warning_no_data_2_click'),
          findsOneWidget);
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

      /// Corrigido: o `onWillPop` não aguarda mais o `pushReplacementNamed`
      /// (a future só completaria quando a tela de login fosse fechada), então
      /// o `maybePop` termina normalmente.
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(store.cpf, isNull);
      expect(store.currentStep, RegistrationStep.cpf);
      expect(observer.pushedNames.last, SharedApplicationRoute.login);
      expect(findRoute(SharedApplicationRoute.login), findsOneWidget);
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

    testWidgets('com textos longos a linha do portal quebra em outra linha',
        (tester) async {
      /// Corrigido: a linha "• texto + link do portal" usa `Wrap` em vez de
      /// `Row`, então textos maiores que a largura da tela quebram a linha em
      /// vez de estourar o layout ("A RenderFlex overflowed").
      await pumpNoData(tester, locOverrides: const {});
      expect(tester.takeException(), isNull);
      expect(find.text('• registration_lello_warning_no_data_2'),
          findsOneWidget);
      expect(find.text('registration_lello_warning_no_data_2_click'),
          findsOneWidget);
    });
  });
}
