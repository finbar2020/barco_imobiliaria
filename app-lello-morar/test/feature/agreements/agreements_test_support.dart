/// Helpers locais da feature de acordos (JSON das APIs, pilha de rotas e
/// fakes de plugins). Só para `test/feature/agreements/`.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/agreements/domain/entity/agreement.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_installment.dart';
import 'package:morar/feature/agreements/domain/entity/agreements_quotas.dart';
import 'package:morar/feature/agreements/presentation/pages/agreements_billet_page.dart';
import 'package:morar/feature/agreements/presentation/pages/agreements_choice_payment_page.dart';
import 'package:morar/feature/agreements/presentation/pages/agreements_day_payment_page.dart';
import 'package:morar/feature/agreements/presentation/pages/agreements_details_page.dart';
import 'package:morar/feature/agreements/presentation/pages/agreements_installment_page.dart';
import 'package:morar/feature/agreements/presentation/pages/agreements_page.dart';
import 'package:morar/feature/agreements/presentation/pages/agreements_recommendation_payment_page.dart';
import 'package:morar/feature/agreements/presentation/pages/agreements_success_page.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/link.dart' show LinkDelegate;
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';

// ---------------------------------------------------------------------------
// Caminhos da API (condomínio `c1` de `testSession()`).
// ---------------------------------------------------------------------------
const agreementPath = '/condominiums/c1/agreement';
const allInfoPath = '$agreementPath/allInfoV2';
const recommendationPath = '$agreementPath/recomendation';
const rulePath = '$agreementPath/rule';
const installmentCreditPath = '$agreementPath/installmentCredit';
String detailsPath(String id) => '$agreementPath/details/$id';

// ---------------------------------------------------------------------------
// JSON dos modelos (`*.g.dart`).
// ---------------------------------------------------------------------------
Map<String, dynamic> quotaJson(
  String id, {
  double origin = 100,
  double fine = 2,
  double fee = 3,
  double honorary = 5,
  String dueDate = '2026-01-10T00:00:00',
}) =>
    {
      'id': id,
      'receipt': 'rec$id',
      'origin_value': origin,
      'due_date': dueDate,
      'fine_value': fine,
      'fee_value': fee,
      'honorary_value': honorary,
      'overdue_message': 'atrasado',
    };

Map<String, dynamic> installmentJson({
  String id = 'i1',
  String status = 'pending',
  String? readableLine = '12345 67890',
  String? paymentLink,
}) =>
    {
      'readable_line': readableLine,
      'bar_code': 'bar',
      'installment_id': id,
      'recnum': 'r',
      'value': 10.0,
      'due_date': '2026-05-01T00:00:00',
      'status': status,
      'payment_link': paymentLink,
    };

Map<String, dynamic> agreementJson(
  String id, {
  String status = 'pending',
  List<Map<String, dynamic>>? installments,
  List<Map<String, dynamic>>? quotes,
  int quantity = 2,
  String? reason,
  String? notificationParameter,
  String paymentMethod = 'billet',
  String? lastInstallmentDate,
}) =>
    {
      'id': id,
      'unit': '101',
      'unit_owner': 'Ana',
      'base_value': 100.0,
      'fine_and_costs': 20.0,
      'payment_method': paymentMethod,
      'expiration': '2026-03-09',
      'installment_quantity': quantity,
      'proposalded_date': '2026-02-01',
      'reference': 1,
      'last_installment_date': lastInstallmentDate,
      'status': status,
      'status_message': '${quantity}x',
      'installments': installments ?? [installmentJson()],
      'quotes': quotes ?? [quotaJson('q$id')],
      'reason': reason,
      'notification_parameter': notificationParameter,
    };

Map<String, dynamic> paymentMethodJson(
  String type, {
  bool enabled = true,
  String description = 'desc',
  String disabledDescription = 'indisponivel',
}) =>
    {
      'type': type,
      'enabled': enabled,
      'text': 'txt',
      'description': description,
      'disabled_description': disabledDescription,
    };

Map<String, dynamic> ruleJson({
  List<int> days = const [5, 10, 29],
  List<Map<String, dynamic>>? methods,
  int installmentQtd = 3,
}) =>
    {
      'installment_qtd': installmentQtd,
      'days': days,
      'payment_method': methods ??
          [paymentMethodJson('billet'), paymentMethodJson('credit')],
    };

Map<String, dynamic> allInfoJson({
  List<Map<String, dynamic>>? quotes,
  List<Map<String, dynamic>>? agreements,
  Map<String, dynamic>? rule,
}) =>
    {
      'quotes': quotes ?? [quotaJson('1'), quotaJson('2'), quotaJson('3')],
      'agreements': agreements ?? <Map<String, dynamic>>[],
      'rule': rule ?? ruleJson(),
    };

Map<String, dynamic> recommendationJson(int qtd,
        {bool recommended = false, int? dueDay}) =>
    {
      'payment_method': 'billet',
      'due_day': dueDay,
      'installment_qtd': qtd,
      'recomendation': recommended,
    };

Map<String, dynamic> installmentCreditJson(
  int qtd, {
  double? tax,
  String? creditTax,
}) =>
    {
      'billet_value': 300.0,
      'installment_qtd': qtd,
      'tax': tax,
      'total_value': 300.0,
      'installment_value': 300.0 / qtd,
      'cet_month': null,
      'cet_total': null,
      'credit_tax': creditTax,
      'credit_tax_value': null,
    };

/// Cadastra no [http] todas as respostas de sucesso do fluxo de acordos.
void stubAgreementsApi(
  FakeHttp http, {
  Map<String, dynamic>? allInfo,
  List<Map<String, dynamic>>? recommendations,
  Map<String, dynamic>? rule,
  List<Map<String, dynamic>>? installmentCredits,
  Map<String, dynamic>? posted,
}) {
  http.on('GET', allInfoPath, body: allInfo ?? allInfoJson());
  http.on('GET', recommendationPath,
      body: recommendations ??
          [
            recommendationJson(3, recommended: true, dueDay: 10),
            recommendationJson(1),
            recommendationJson(2),
          ]);
  http.on('GET', rulePath, body: rule ?? ruleJson());
  http.on('GET', installmentCreditPath,
      body: installmentCredits ??
          [
            installmentCreditJson(1),
            installmentCreditJson(2, tax: 1.5, creditTax: '2%'),
          ]);
  http.on('POST', agreementPath,
      body: posted ?? agreementJson('novo', status: 'approved_by_manager'));
}

// ---------------------------------------------------------------------------
// Entidades prontas.
// ---------------------------------------------------------------------------
AgreementInstallment testInstallment({
  String status = 'pending',
  String? readableLine = '12345 67890',
  String? installmentId = 'i1',
  String? paymentLink,
}) =>
    AgreementInstallment(
      readableLine: readableLine,
      barCode: 'bar',
      installmentId: installmentId,
      recnum: 'r',
      value: 10,
      dueDate: DateTime(2026, 5, 1),
      status: status,
      paymentLink: paymentLink,
    );

AgreementQuota testQuota({String id = 'q1'}) => AgreementQuota(
      id: id,
      receipt: 'rec$id',
      originValue: 100,
      dueDate: DateTime(2026, 1, 10),
      fineValue: 2,
      feeValue: 3,
      honoraryValue: 5,
      overdueMessage: 'atrasado',
    );

Agreement testAgreement({
  String id = 'a1',
  String status = 'pending',
  List<AgreementInstallment>? installments,
  List<AgreementQuota>? quotes,
  int quantity = 2,
  String? reason,
  String paymentMethod = 'billet',
  String? baseUrl = 'http://localhost',
}) =>
    Agreement(
      id: id,
      unit: '101',
      unitOwner: 'Ana',
      baseValue: 100,
      fineAndCosts: 20,
      paymentMethod: paymentMethod,
      expiration: '2026-03-09',
      installmentQuantity: quantity,
      proposaldedDate: '2026-02-01',
      reference: 1,
      status: status,
      statusMessage: '${quantity}x',
      installments: installments ?? [testInstallment()],
      quotes: quotes ?? [testQuota()],
      reason: reason,
      baseUrl: baseUrl,
    );

// ---------------------------------------------------------------------------
// Rotas reais da feature e pilha de navegação.
// ---------------------------------------------------------------------------
Map<String, WidgetBuilder> get agreementsRoutes => {
      ApplicationRoute.agreements: (_) => const AgreementsPage(),
      ApplicationRoute.agreementsChoicePayment: (_) =>
          const AgreementsChoicePaymentPage(),
      ApplicationRoute.agreementsRecommendationPayment: (_) =>
          const AgreementsRecommendationPaymentPage(),
      ApplicationRoute.agreementDayPayment: (_) =>
          const AgreementsDayPaymentPage(),
      ApplicationRoute.agreementBillet: (_) => const AgreementsBilletPage(),
      ApplicationRoute.agreementSuccessSend: (_) =>
          const AgreementsSuccessPage(),
      ApplicationRoute.agreementInstallment: (_) =>
          const AgreementsInstallmentPage(),
      ApplicationRoute.agreementDetail: (_) => const AgreementsDetailsPage(),
    };

/// Um passo da pilha de navegação montada por [pumpAgreementsStack].
class RouteStep {
  const RouteStep(this.name, {this.arguments});
  final String name;
  final Object? arguments;
}

class _StackLauncher extends StatefulWidget {
  const _StackLauncher(this.stack);
  final List<RouteStep> stack;

  @override
  State<_StackLauncher> createState() => _StackLauncherState();
}

class _StackLauncherState extends State<_StackLauncher> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final step in widget.stack) {
        Navigator.pushNamed(context, step.name, arguments: step.arguments);
      }
    });
  }

  @override
  Widget build(BuildContext context) =>
      const Scaffold(key: Key('route:launcher'), body: Text('launcher'));
}

/// Monta uma tela base e empilha [stack] em ordem. Rotas presentes em
/// [routes] (por padrão [agreementsRoutes]) viram as páginas reais; as demais
/// viram stubs `Key('route:<nome>')`, o que permite testar `popUntil`.
Future<void> pumpAgreementsStack(
  WidgetTester tester,
  List<RouteStep> stack, {
  Map<String, WidgetBuilder>? routes,
  RecordingNavigatorObserver? observer,
  Size surface = const Size(600, 1000),
  bool settle = true,
  Map<String, String> locOverrides = const {},
}) async {
  await pumpPage(
    tester,
    _StackLauncher(stack),
    routes: routes ?? agreementsRoutes,
    observer: observer,
    surface: surface,
    settle: false,
    locOverrides: locOverrides,
  );
  // roda o postFrame que empilha as rotas
  await tester.pump();
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump(const Duration(milliseconds: 400));
  }
}

/// Monta só a rota [ApplicationRoute.agreements] com a página real.
Future<void> pumpAgreementsPage(
  WidgetTester tester, {
  AgreementsPageArgs? arguments,
  RecordingNavigatorObserver? observer,
  Size surface = const Size(600, 1000),
  bool settle = true,
  Map<String, String> locOverrides = const {},
}) =>
    pumpAgreementsStack(
      tester,
      [RouteStep(ApplicationRoute.agreements, arguments: arguments)],
      observer: observer,
      surface: surface,
      settle: settle,
      locOverrides: locOverrides,
    );

/// Só a rota [only] usa a página real; as demais viram stubs.
Map<String, WidgetBuilder> onlyRoute(String only) =>
    {only: agreementsRoutes[only]!};

/// Traduções curtas usadas onde o texto muda com o `sprintf`.
const stepOverrides = {'agreements_step': 'Etapa %d de %d'};

/// Dispara o `WillPopScope` da rota atual (equivale ao botão voltar do
/// sistema).
Future<void> systemBack(WidgetTester tester) async {
  final navigator = tester.state<NavigatorState>(find.byType(Navigator).first);
  navigator.maybePop();
  await tester.pumpAndSettle();
}

/// `Clipboard.setData` só completa (e dispara o `.then`) com o canal de
/// plataforma respondendo; sem mock o teste fica esperando o engine.
void mockClipboard() {
  final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  messenger.setMockMethodCallHandler(SystemChannels.platform, (call) async => null);
  addTearDown(() => messenger.setMockMethodCallHandler(SystemChannels.platform, null));
}

/// Deixa um `Flushbar` (1s) terminar e sair da tela.
Future<void> settleFlushbar(WidgetTester tester) async {
  await tester.pump(const Duration(seconds: 2));
  await tester.pumpAndSettle();
}

// ---------------------------------------------------------------------------
// Fake do url_launcher: registra as URLs e nunca cai no canal nativo.
// ---------------------------------------------------------------------------
class FakeUrlLauncher extends UrlLauncherPlatform
    with MockPlatformInterfaceMixin {
  final launched = <String>[];

  @override
  LinkDelegate? get linkDelegate => null;

  @override
  Future<bool> canLaunch(String url) async => true;

  @override
  Future<bool> launch(
    String url, {
    required bool useSafariVC,
    required bool useWebView,
    required bool enableJavaScript,
    required bool enableDomStorage,
    required bool universalLinksOnly,
    required Map<String, String> headers,
    String? webOnlyWindowName,
  }) async {
    launched.add(url);
    return true;
  }

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    launched.add(url);
    return true;
  }

  @override
  Future<bool> supportsMode(PreferredLaunchMode mode) async => true;

  @override
  Future<bool> supportsCloseForMode(PreferredLaunchMode mode) async => true;
}

/// Instala o [FakeUrlLauncher] e devolve a instância para inspeção.
FakeUrlLauncher installFakeUrlLauncher() {
  final fake = FakeUrlLauncher();
  UrlLauncherPlatform.instance = fake;
  return fake;
}
