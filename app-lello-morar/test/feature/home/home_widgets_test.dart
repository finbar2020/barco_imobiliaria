import 'package:another_flushbar/flushbar.dart';
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/utils/remote_config/horta_remote_config_entity.dart';
import 'package:morar/feature/home/domain/entity/home_item_enum.dart';
import 'package:morar/feature/home/presentation/widget/badge_icon.dart';
import 'package:morar/feature/home/presentation/widget/bella_intro_modal.dart';
import 'package:morar/feature/home/presentation/widget/bella_search_component.dart';
import 'package:morar/feature/home/presentation/widget/empty_state_widget.dart';
import 'package:morar/feature/home/presentation/widget/error_dialog.dart';
import 'package:morar/feature/home/presentation/widget/expiration_dialog.dart';
import 'package:morar/feature/home/presentation/widget/feature_moved_full_screen_dialog.dart';
import 'package:morar/feature/home/presentation/widget/home_dialogs/widgets/switch_role_alert_dialog/switch_role_alert_dialog_widget.dart';
import 'package:morar/feature/home/presentation/widget/horta_dialog.dart';
import 'package:morar/feature/home/presentation/widget/unit_selection_overlay.dart';
import 'package:morar/feature/ia_bella/domain/entity/bella_message_entity.dart';
import 'package:morar/feature/me/domain/entity/condominium.dart';
import 'package:morar/feature/me/domain/entity/me.dart';
import 'package:morar/feature/home/domain/entity/unity.dart';
import 'package:morar/feature/session/presentation/bloc/session_state.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/pump_app.dart';
import 'home_test_support.dart';

/// Abre [dialog] com `showDialog` a partir de um botão, para que sempre
/// exista uma rota abaixo do diálogo (os widgets chamam `Navigator.pop`).
Future<void> pumpDialog(
  WidgetTester tester,
  Widget dialog, {
  RecordingNavigatorObserver? observer,
  Map<String, WidgetBuilder> routes = const {},
  Size surface = const Size(400, 800),
  Map<String, String> locOverrides = const {},
}) async {
  await pumpApp(
    tester,
    Builder(
      builder: (ctx) => ElevatedButton(
        onPressed: () => showDialog(context: ctx, builder: (_) => dialog),
        child: const Text('abrir'),
      ),
    ),
    localized: true,
    navigatorObserver: observer,
    routes: routes,
    surface: surface,
    locOverrides: locOverrides,
  );
  await tester.tap(find.text('abrir'));
  await tester.pumpAndSettle();
}

Widget _stub(String name) => Scaffold(body: Text('rota $name'));

/// As chaves em maiúsculo estouram a largura do diálogo; usamos textos curtos.
const _switchRoleTexts = {
  'switch_role_alert_not_now': 'Agora não',
  'switch_role_alert_take_me_there': 'Me leve',
};

void main() {
  late RecordingNavigatorObserver observer;
  late List<dynamic> platformCalls;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    FlavorConfig.init();
  });

  setUp(() {
    observer = RecordingNavigatorObserver();
    SharedPreferences.setMockInitialValues({});
    PackageInfo.setMockInitialValues(
      appName: 'morar',
      packageName: 'br.com.lello.morar',
      version: '9.9.9',
      buildNumber: '1',
      buildSignature: '',
    );
    platformCalls = mockHomePlatformChannels();
  });

  group('HomeItemEnum', () {
    test('priority ordena comodidades, acordos e boletos primeiro', () {
      expect(HomeItemEnum.comfort.priority(), 0);
      expect(HomeItemEnum.agreements.priority(), 1);
      expect(HomeItemEnum.billets.priority(), 2);
      for (final item in HomeItemEnum.values.where((e) =>
          e != HomeItemEnum.comfort &&
          e != HomeItemEnum.agreements &&
          e != HomeItemEnum.billets)) {
        expect(item.priority(), 3, reason: '$item');
      }
    });
  });

  group('widgets simples', () {
    testWidgets('BadgeIcon mostra o texto com a cor primária', (tester) async {
      await pumpApp(tester, const BadgeIcon(text: '3'));
      final text = tester.widget<Text>(find.text('3'));
      expect(text.style?.color, LelloTheme.light.primaryColor);
    });

    testWidgets('EmptyStateWidget usa a mensagem padrão ou a informada',
        (tester) async {
      await pumpApp(tester, const EmptyStateWidget());
      expect(find.text('Suas ferramentas disponíveis serão exibidas aqui.'),
          findsOneWidget);

      await pumpApp(tester, const EmptyStateWidget(message: 'nada'));
      expect(find.text('nada'), findsOneWidget);
    });
  });

  group('ErrorDialog', () {
    testWidgets('mostra o título e fecha no ok', (tester) async {
      await pumpDialog(
        tester,
        ErrorDialog(
          title: 'manager_inactive_message',
          theme: LelloTheme.light,
          isGeneric: false,
        ),
        observer: observer,
      );
      expect(find.text('manager_inactive_message'), findsOneWidget);

      await tester.tap(find.text('ok'));
      await tester.pumpAndSettle();
      expect(find.byType(ErrorDialog), findsNothing);
      expect(observer.popped, hasLength(1));
    });

    testWidgets('no app genérico remove "Lello" do texto', (tester) async {
      await pumpApp(
        tester,
        ErrorDialog(
          title: 'x',
          theme: LelloTheme.light,
          isGeneric: true,
        ),
        localized: true,
        locOverrides: {'x': 'Fale com a Lello agora'},
      );
      expect(find.text('Fale com a  agora'), findsOneWidget);
    });
  });

  group('ExpirationDialog', () {
    testWidgets('proprietário renova pela tela de moradores', (tester) async {
      final checked = <bool>[];
      await pumpDialog(
        tester,
        Dialog(
          child: ExpirationDialog(
            isOwner: true,
            onChecked: checked.add,
            onRenewalRequestPressed: () {},
          ),
        ),
        observer: observer,
        routes: {ApplicationRoute.subUser: (_) => _stub('sub_user')},
      );
      expect(find.text('Atenção:\nacesso prestes a expirar'), findsOneWidget);

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      expect(checked, [true]);
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      expect(checked, [true, false]);

      await tester.tap(find.text('Renovar agora'));
      await tester.pumpAndSettle();
      expect(observer.pushedNames.last, ApplicationRoute.subUser);
      expect(find.byType(ExpirationDialog), findsNothing);
    });

    testWidgets('morador solicita renovação e pode fechar', (tester) async {
      var renew = 0;
      await pumpDialog(
        tester,
        Dialog(
          child: ExpirationDialog(
            isOwner: false,
            onChecked: (_) {},
            onRenewalRequestPressed: () => renew++,
          ),
        ),
        observer: observer,
      );
      expect(find.text('Seus acessos estão próximos de expirar!'),
          findsOneWidget);

      await tester.tap(find.text('Solicitar renovação'));
      await tester.pumpAndSettle();
      expect(renew, 1);
      expect(find.byType(ExpirationDialog), findsNothing);

      await tester.tap(find.text('abrir'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Fechar'));
      await tester.pumpAndSettle();
      expect(find.byType(ExpirationDialog), findsNothing);
    });
  });

  group('HortaDialog', () {
    testWidgets('copia o cupom, abre o link e fecha', (tester) async {
      await pumpDialog(
        tester,
        HortaDialog(
          horta: HortaRemoteConfigEntity(
              cupom: 'CUPOM10', link: 'https://horta.test'),
        ),
        surface: const Size(400, 900),
      );
      expect(find.text('CUPOM10'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.copy));
      await tester.pumpAndSettle();
      expect(platformCalls.map((c) => c.method), contains('Clipboard.setData'));
      expect(find.byType(Flushbar), findsOneWidget);
      await tester.pump(const Duration(seconds: 4));

      await tester.tap(find.text('horta_button'));
      await tester.pumpAndSettle();
      expect(platformCalls.map((c) => c.method), contains('launch'));

      await tester.tap(find.text('LATER'));
      await tester.pumpAndSettle();
      expect(find.byType(HortaDialog), findsNothing);
    });

    testWidgets('sem link e sem cupom não abre nada', (tester) async {
      await pumpDialog(tester, HortaDialog(horta: HortaRemoteConfigEntity()),
          surface: const Size(400, 900));
      await tester.tap(find.text('horta_button'));
      await tester.pumpAndSettle();
      expect(platformCalls.where((c) => c.method == 'launch'), isEmpty);
    });
  });

  group('FeatureMovedFullscreenDialog', () {
    testWidgets('leva para a rota informada', (tester) async {
      await pumpDialog(
        tester,
        const FeatureMovedFullscreenDialog(
          appBarTitle: 'preferences_zero_paper',
          message: 'access_paper_zero_instructions',
          route: '/receiving_documents',
        ),
        observer: observer,
        routes: {'/receiving_documents': (_) => _stub('docs')},
      );
      expect(find.text('function_moved'), findsOneWidget);
      expect(find.text('access_paper_zero_instructions'), findsOneWidget);

      await tester.tap(find.text('take_me_there'));
      await tester.pumpAndSettle();
      expect(observer.pushedNames.last, '/receiving_documents');
      expect(find.byType(FeatureMovedFullscreenDialog), findsNothing);
    });
  });

  group('SwitchRoleAlertDialogWidget', () {
    testWidgets('"agora não" fecha e "me leve" chama o callback',
        (tester) async {
      var pressed = 0;
      await pumpDialog(
        tester,
        SwitchRoleAlertDialogWidget(onPressed: () => pressed++),
        locOverrides: _switchRoleTexts,
      );
      expect(find.text('switch_role_alert_dialog_title'), findsOneWidget);

      await tester.tap(find.text('ME LEVE'));
      await tester.pump();
      expect(pressed, 1);

      await tester.tap(find.text('AGORA NÃO'));
      await tester.pumpAndSettle();
      expect(find.byType(SwitchRoleAlertDialogWidget), findsNothing);
    });

    testWidgets('voltar do sistema fecha o diálogo', (tester) async {
      await pumpDialog(tester, SwitchRoleAlertDialogWidget(onPressed: () {}),
          locOverrides: _switchRoleTexts);
      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      await navigator.maybePop();
      await tester.pumpAndSettle();
      expect(find.byType(SwitchRoleAlertDialogWidget), findsNothing);
    });
  });

  group('BellaSearchComponent', () {
    testWidgets('busca digitada abre a Bella com o texto', (tester) async {
      await pumpApp(
        tester,
        const BellaSearchComponent(),
        localized: true,
        navigatorObserver: observer,
        routes: {ApplicationRoute.iaBella: (_) => _stub('bella')},
      );
      expect(find.byIcon(Icons.arrow_back), findsNothing);

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.arrow_back), findsNothing);

      // Texto vazio não navega.
      await tester.tap(find.byIcon(Icons.search).first);
      await tester.pumpAndSettle();
      expect(observer.pushedNames, isNot(contains(ApplicationRoute.iaBella)));

      await tester.enterText(find.byType(TextField), 'segunda via');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(observer.pushedNames.last, ApplicationRoute.iaBella);
      final args = observer.pushed.last.settings.arguments as BellaMessageEntity;
      expect(args.text, 'segunda via');
      expect(args.isUser, isTrue);
    });

    testWidgets('chips abrem a Bella com o prompt e texto de exibição',
        (tester) async {
      await pumpApp(
        tester,
        const BellaSearchComponent(),
        localized: true,
        navigatorObserver: observer,
        routes: {ApplicationRoute.iaBella: (_) => _stub('bella')},
      );
      await tester.tap(find.text('last_assembly_chip'));
      await tester.pumpAndSettle();
      final args = observer.pushed.last.settings.arguments as BellaMessageEntity;
      expect(args.text, 'last_assembly_prompt');
      expect(args.displayText, 'last_assembly');
    });

    testWidgets('botão de busca envia o texto do campo', (tester) async {
      await pumpApp(
        tester,
        const BellaSearchComponent(),
        localized: true,
        navigatorObserver: observer,
        routes: {ApplicationRoute.iaBella: (_) => _stub('bella')},
      );
      await tester.enterText(find.byType(TextField), 'regras');
      await tester.tap(find.byIcon(Icons.search).first);
      await tester.pumpAndSettle();
      final args = observer.pushed.last.settings.arguments as BellaMessageEntity;
      expect(args.text, 'regras');
      expect(args.displayText, isNull);
    });
  });

  group('BellaIntroModal', () {
    test('shouldShow/setShown usam o SharedPreferences', () async {
      expect(await BellaIntroModal.shouldShow(), isTrue);
      await BellaIntroModal.setShown();
      expect(await BellaIntroModal.shouldShow(), isFalse);
    });

    testWidgets('fechar marca como visto e chama onClose', (tester) async {
      var closed = 0;
      await pumpDialog(
        tester,
        BellaIntroModal(onClose: () => closed++),
        surface: const Size(500, 1000),
      );
      expect(find.text('bella_intro_title'), findsOneWidget);

      await tester.tap(find.text('close'));
      await tester.pumpAndSettle();
      expect(closed, 1);
      expect(find.byType(BellaIntroModal), findsNothing);
      expect(await BellaIntroModal.shouldShow(), isFalse);
    });

    testWidgets('sugestão navega para a Bella depois de fechar o modal',
        (tester) async {
      var closed = 0;
      await pumpDialog(
        tester,
        BellaIntroModal(onClose: () => closed++),
        observer: observer,
        routes: {ApplicationRoute.iaBella: (_) => _stub('bella')},
        surface: const Size(500, 1000),
      );
      await tester.tap(find.byIcon(Icons.search).at(1));
      await tester.pumpAndSettle();
      expect(closed, 1);
      expect(observer.pushedNames.last, ApplicationRoute.iaBella);
      final args = observer.pushed.last.settings.arguments as BellaMessageEntity;
      expect(args.text, 'bills');
    });

    testWidgets('texto digitado navega e vazio não faz nada', (tester) async {
      await pumpDialog(
        tester,
        BellaIntroModal(onClose: () {}),
        observer: observer,
        routes: {ApplicationRoute.iaBella: (_) => _stub('bella')},
        surface: const Size(500, 1000),
      );
      await tester.tap(find.byIcon(Icons.search).first);
      await tester.pumpAndSettle();
      expect(observer.pushedNames, isNot(contains(ApplicationRoute.iaBella)));

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'assembleia');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(observer.pushedNames.last, ApplicationRoute.iaBella);
    });

    testWidgets('voltar do sistema marca como visto', (tester) async {
      var closed = 0;
      await pumpDialog(tester, BellaIntroModal(onClose: () => closed++),
          surface: const Size(500, 1000));
      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      await navigator.maybePop();
      await tester.pumpAndSettle();
      expect(closed, 1);
      expect(find.byType(BellaIntroModal), findsNothing);
    });
  });

  group('UnitSelectionOverlay', () {
    Me me() => testMe(condominiums: [
          testCondominium(
            id: 'c1',
            reference: 'R1',
            name: 'Edifício Lello',
            blocks: [
              testBlock(units: [
                testUnity(id: 'u1', title: '101'),
                testUnity(id: 'u2', title: '202'),
              ])
            ],
          ),
          testCondominium(
            id: 'c2',
            reference: 'R2',
            name: 'Condomínio Sol',
            blocks: [
              testBlock(id: 'b2', units: [testUnity(id: 'u3', title: '303')])
            ],
          ),
        ]);

    testWidgets('lista, filtra e seleciona unidades', (tester) async {
      final session = testSession(me: me());
      session.condominium = session.me!.condominiums![0];
      session.unity = session.me!.condominiums![0].blocks![0].units![0];
      final selected = <String>[];
      var closed = 0;

      await pumpApp(
        tester,
        UnitSelectionOverlay(
          units: session.me!.allUnits,
          sessionState: SessionLoadedState(session),
          onUnitSelected: (Condominium c, Unity u) =>
              selected.add('${c.reference}-${u.title}'),
          onClose: () => closed++,
        ),
        localized: true,
        shrinkWrap: false,
      );

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.text('EDIFÍCIO LELLO'), findsNWidgets(2));
      expect(find.text('CONDOMÍNIO SOL'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'sol');
      await tester.pumpAndSettle();
      expect(find.text('CONDOMÍNIO SOL'), findsOneWidget);
      expect(find.text('EDIFÍCIO LELLO'), findsNothing);

      await tester.enterText(find.byType(TextField), '202');
      await tester.pumpAndSettle();
      expect(find.text('EDIFÍCIO LELLO'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'r2');
      await tester.pumpAndSettle();
      expect(find.text('CONDOMÍNIO SOL'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'flores');
      await tester.pumpAndSettle();
      expect(find.text('CONDOMÍNIO SOL'), findsOneWidget);

      await tester.tap(find.text('CONDOMÍNIO SOL'));
      await tester.pumpAndSettle();
      expect(selected, ['R2-303']);
      expect(closed, 1);

      await tester.tap(find.byIcon(Icons.keyboard_arrow_up_rounded));
      await tester.pumpAndSettle();
      expect(closed, 2);
    });

    testWidgets('com uma única unidade não mostra a busca', (tester) async {
      final session = testSession();
      await pumpApp(
        tester,
        UnitSelectionOverlay(
          units: session.me!.allUnits,
          sessionState: SessionLoadedState(session),
          onUnitSelected: (_, __) {},
          onClose: () {},
        ),
        localized: true,
        shrinkWrap: false,
      );
      expect(find.byType(TextField), findsNothing);
      expect(find.text('RUA DAS FLORES, 100'), findsOneWidget);
    });
  });
}
