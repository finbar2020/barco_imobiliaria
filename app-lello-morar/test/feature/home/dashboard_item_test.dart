import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:essentials/ui/widget/dialogs/redirection_whatsapp_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/navigation/application_rbac.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/utils/remote_config/horta_remote_config_entity.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_page.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreement_access_not_allowed_dialog.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreement_not_avaliable_dialog.dart';
import 'package:morar/feature/home/domain/entity/external_link_redirect_enum.dart';
import 'package:morar/feature/home/presentation/widget/badge_icon.dart';
import 'package:morar/feature/home/presentation/widget/dashboard_item.dart';
import 'package:morar/feature/home/presentation/widget/error_dialog.dart';
import 'package:morar/feature/home/presentation/widget/feature_moved_full_screen_dialog.dart';
import 'package:morar/feature/home/presentation/widget/home_dialogs/widgets/rent_sell_dialog.dart/rent_sell_dialog.dart';
import 'package:morar/feature/home/presentation/widget/horta_dialog.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/pages/comfort_page.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';
import 'home_test_support.dart';

final _sessionBloc = HomeFakeSessionBloc();

void main() {
  late RecordingNavigatorObserver observer;
  late List<dynamic> platformCalls;
  late List<String> analytics;

  setUp(() async {
    await installHomeHarness(_sessionBloc);
    observer = RecordingNavigatorObserver();
    platformCalls = mockHomePlatformChannels();
    analytics = [];
  });

  Future<void> pumpItem(
    WidgetTester tester, {
    required String text,
    String route = '/rota-x',
    String imagePath = 'assets/ic_documents.svg',
    ExternalLinkRedirectEnum? external,
    HortaRemoteConfigEntity? horta,
    bool isGeneric = false,
    bool wide = false,
    bool? highlighted = false,
    bool? hyphenate = false,
    String badge = '',
    String? whatsApp,
    VoidCallback? onComfortTap,
    VoidCallback? closeOverlay,
    Map<String, WidgetBuilder> routes = const {},
    Size surface = const Size(400, 800),
  }) async {
    // Um novo MaterialApp reaproveita o Navigator anterior (e as rotas
    // empilhadas); zeramos a árvore antes de montar de novo.
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
    observer = RecordingNavigatorObserver();
    await pumpPage(
      tester,
      Scaffold(
        body: DashboardItem(
          imagePath: imagePath,
          text: text,
          route: route,
          closeOverlay: closeOverlay ?? () => analytics.add('close'),
          sessionBloc: _sessionBloc,
          isCardWideScreen: wide,
          isGeneric: isGeneric,
          badgeText: badge,
          horta: horta,
          externalLinkRedirectEnum: external,
          startAnalyticsTimer: () => analytics.add('start'),
          stopAnalyticsTimer: () => analytics.add('stop'),
          isHighlighted: highlighted,
          canHyphenateText: hyphenate,
          whatsAppNumber: whatsApp,
          onComfortTap: onComfortTap,
        ),
      ),
      observer: observer,
      routes: routes,
      surface: surface,
    );
  }

  /// Rotas empilhadas pelo próprio MaterialApp antes de qualquer interação.
  const baseRoutes = 2;

  Future<void> tapItem(WidgetTester tester) async {
    await tester.tap(find.byType(DashboardItem));
    await tester.pumpAndSettle();
  }

  testWidgets('renderiza texto, badge, destaque e ícone genérico do whats',
      (tester) async {
    await pumpItem(
      tester,
      text: 'ia_bella',
      imagePath: 'assets/ic_whats.svg',
      highlighted: true,
      hyphenate: true,
      badge: '2',
      wide: true,
    );
    expect(find.text('ia_bella'), findsOneWidget);
    expect(find.byType(BadgeIcon), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    final autoText = tester.widget<AutoSizeText>(find.byType(AutoSizeText));
    expect(autoText.maxLines, 1);
    expect(hyphenateText('duas palavras'), 'duas palavras');
    expect(hyphenateText('unica'), 'unica');
  });

  testWidgets('rota padrão navega e reinicia o timer ao voltar',
      (tester) async {
    await pumpItem(tester, text: 'reserves', route: ApplicationRoute.reserve);
    await tapItem(tester);
    // Corrigido (dashboard_item.dart): `stopAnalyticsTimer()` é chamado antes
    // de navegar e `startAnalyticsTimer()` ao voltar da rota.
    expect(analytics, ['close', 'stop']);
    expect(observer.pushedNames.last, ApplicationRoute.reserve);

    tester.state<NavigatorState>(find.byType(Navigator)).pop();
    await tester.pumpAndSettle();
    expect(analytics, ['close', 'stop', 'start']);
  });

  testWidgets('ocorrências: síndico inativo mostra erro, ativo navega',
      (tester) async {
    _sessionBloc.session = testSession(
        condominium: testCondominium(activeManager: false));
    await pumpItem(tester, text: 'reports_title', route: ApplicationRoute.reports);
    await tapItem(tester);
    expect(find.byType(ErrorDialog), findsOneWidget);
    expect(find.text('manager_inactive_message'), findsOneWidget);
    await tester.tap(find.text('ok'));
    await tester.pumpAndSettle();

    _sessionBloc.session = testSession();
    await pumpItem(tester, text: 'reports_title', route: ApplicationRoute.reports);
    await tapItem(tester);
    expect(observer.pushedNames.last, ApplicationRoute.reports);
    tester.state<NavigatorState>(find.byType(Navigator)).pop();
    await tester.pumpAndSettle();
    expect(analytics, ['close', 'close', 'stop', 'start']);
  });

  testWidgets('comodidades usa o callback da aba quando informado',
      (tester) async {
    var jumps = 0;
    await pumpItem(tester, text: 'comfort', onComfortTap: () => jumps++);
    await tapItem(tester);
    expect(jumps, 1);
    expect(analytics, ['close', 'stop', 'start']);
    expect(observer.pushedNames, hasLength(baseRoutes));
  });

  testWidgets('comodidades sem callback abre a página com os argumentos',
      (tester) async {
    await pumpItem(tester, text: 'comfort', route: ApplicationRoute.comfort);
    await tapItem(tester);
    expect(observer.pushedNames.last, ApplicationRoute.comfort);
    final args = observer.pushed.last.settings.arguments as ComfortPageArgs;
    expect(args.reference, 'R1');
    expect(args.unit, '101');
  });

  testWidgets('comodidades sem rbac não faz nada', (tester) async {
    _sessionBloc.allowedRbacs = {};
    await pumpItem(tester, text: 'comfort', route: ApplicationRoute.comfort);
    await tapItem(tester);
    expect(observer.pushedNames, hasLength(baseRoutes));
  });

  testWidgets('autorizar entrada exige rbac de portaria', (tester) async {
    _sessionBloc.allowedRbacs = {};
    await pumpItem(tester,
        text: 'authorize_entry', route: ApplicationRoute.accessControl);
    await tapItem(tester);
    expect(find.text('manager_no_concierge'), findsOneWidget);
    await tester.tap(find.text('ok'));
    await tester.pumpAndSettle();

    _sessionBloc.allowedRbacs = {ApplicationRbac.morarAutorizarEntrada};
    await pumpItem(tester,
        text: 'authorize_entry',
        route: ApplicationRoute.accessControl,
        isGeneric: true);
    await tapItem(tester);
    expect(observer.pushedNames.last, ApplicationRoute.accessControl);
    final args = observer.pushed.last.settings.arguments as AcessControlPageArgs;
    expect(args.isGeneric, isTrue);
  });

  testWidgets('correspondências exige rbac', (tester) async {
    _sessionBloc.allowedRbacs = {};
    await pumpItem(tester, text: 'mailing_title', route: ApplicationRoute.mailing);
    await tapItem(tester);
    expect(find.byType(ErrorDialog), findsOneWidget);
    await tester.tap(find.text('ok'));
    await tester.pumpAndSettle();

    _sessionBloc.allowedRbacs = {ApplicationRbac.morarCorrespondencias};
    await pumpItem(tester, text: 'mailing_title', route: ApplicationRoute.mailing);
    await tapItem(tester);
    expect(observer.pushedNames.last, ApplicationRoute.mailing);
  });

  testWidgets('acordos: sem rbac mostra diálogo de acesso negado',
      (tester) async {
    _sessionBloc.allowedRbacs = {};
    await pumpItem(tester,
        text: 'agreements',
        route: ApplicationRoute.agreements,
        surface: const Size(800, 800));
    await tapItem(tester);
    expect(find.byType(AgreementAccessNotAllowedDialog), findsOneWidget);
  });

  testWidgets('acordos: página devolvendo indisponível mostra diálogo',
      (tester) async {
    await pumpItem(
      tester,
      text: 'agreements',
      route: ApplicationRoute.agreements,
      routes: {
        ApplicationRoute.agreements: (context) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pop(
                context, Exception('agreement_not_avaliable_failure'));
          });
          return const Scaffold(body: Text('acordos'));
        },
      },
    );
    await tapItem(tester);
    expect(find.byType(AgreementNotAvaliableDialog), findsOneWidget);
  });

  testWidgets('acordos: página sem resultado não mostra diálogo',
      (tester) async {
    await pumpItem(tester, text: 'agreements', route: ApplicationRoute.agreements);
    await tapItem(tester);
    expect(observer.pushedNames.last, ApplicationRoute.agreements);
    tester.state<NavigatorState>(find.byType(Navigator)).pop();
    await tester.pumpAndSettle();
    expect(find.byType(AgreementNotAvaliableDialog), findsNothing);
  });

  testWidgets('prestação de contas, veículos e documentos registram analytics',
      (tester) async {
    for (final entry in {
      'lello_hub_billing': ApplicationRoute.accountability,
      'me_vehicles_title': ApplicationRoute.vehiclePage,
      'documents': ApplicationRoute.documents,
    }.entries) {
      await pumpItem(tester, text: entry.key, route: entry.value);
      await tapItem(tester);
      expect(observer.pushedNames.last, entry.value, reason: entry.key);
    }
  });

  testWidgets('horta abre o diálogo apenas com configuração', (tester) async {
    await pumpItem(tester, text: 'horta_title');
    await tapItem(tester);
    expect(find.byType(HortaDialog), findsNothing);

    await pumpItem(tester,
        text: 'horta_title', horta: HortaRemoteConfigEntity(cupom: 'C'));
    await tapItem(tester);
    expect(find.byType(HortaDialog), findsOneWidget);
  });

  testWidgets('papel zero e alteração de endereço abrem o aviso de mudança',
      (tester) async {
    await pumpItem(tester, text: 'preferences_zero_paper');
    await tapItem(tester);
    expect(find.byType(FeatureMovedFullscreenDialog), findsOneWidget);
    expect(find.text('access_paper_zero_instructions'), findsOneWidget);
    await tester.tap(find.text('take_me_there'));
    await tester.pumpAndSettle();
    expect(observer.pushedNames.last, ApplicationRoute.receivingDocuments);

    await pumpItem(tester, text: 'change_address');
    await tapItem(tester);
    expect(find.text('access_change_address_instructions'), findsOneWidget);
  });

  testWidgets('fale com a Lello abre o diálogo do WhatsApp', (tester) async {
    await pumpItem(
      tester,
      text: 'talk_to_lello',
      external: ExternalLinkRedirectEnum.talkToLello,
      whatsApp: '5511999999999',
      surface: const Size(800, 800),
    );
    await tapItem(tester);
    expect(find.byType(RedirectionWhatsappDialog), findsOneWidget);
    final dialog = tester.widget<RedirectionWhatsappDialog>(
        find.byType(RedirectionWhatsappDialog));
    expect(dialog.phoneNumber, '5511999999999');
  });

  testWidgets('fale com a Lello sem número usa o padrão do flavor',
      (tester) async {
    _sessionBloc.session = testSession(
        condominium: testCondominium(layout: testLayout()));
    await pumpItem(
      tester,
      text: 'talk_to_lello',
      external: ExternalLinkRedirectEnum.talkToLello,
      isGeneric: true,
      surface: const Size(800, 800),
    );
    await tapItem(tester);
    final dialog = tester.widget<RedirectionWhatsappDialog>(
        find.byType(RedirectionWhatsappDialog));
    expect(dialog.phoneNumber,
        FlavorConfig.config.supportMoradorWhatsAppNumber);
  });

  testWidgets('alugue ou venda abre o diálogo e o link', (tester) async {
    await pumpItem(
      tester,
      text: 'rent_sell',
      external: ExternalLinkRedirectEnum.rentOrSellYourProperty,
    );
    await tapItem(tester);
    expect(find.byType(RentSellDialogWidget), findsOneWidget);

    await tester.tap(find.text('rent_sell_dialog_check_out'));
    await tester.pumpAndSettle();
    expect(find.byType(RentSellDialogWidget), findsNothing);
    expect(
      platformCalls.map((c) => c.method),
      anyOf(contains('launch'), contains('openUrl')),
    );

    await tapItem(tester);
    await tester.tap(find.text('later'));
    await tester.pumpAndSettle();
    expect(find.byType(RentSellDialogWidget), findsNothing);

    // Voltar do sistema também fecha.
    await tapItem(tester);
    await tester.state<NavigatorState>(find.byType(Navigator)).maybePop();
    await tester.pumpAndSettle();
    expect(find.byType(RentSellDialogWidget), findsNothing);
  });

}
