import 'dart:io';

import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/widgets/loading_widget.dart';
import 'package:morar/feature/insurance/presentation/bloc/insurance_state.dart';
import 'package:morar/feature/insurance/presentation/controller/insurance_controller.dart';
import 'package:morar/feature/insurance/presentation/pages/insurance_cancel_page.dart';
import 'package:morar/feature/insurance/presentation/pages/insurance_page.dart';
import 'package:morar/feature/insurance/presentation/pages/insurance_success_page.dart';
import 'package:morar/feature/insurance/presentation/widget/insurance_contract_dialog.dart';
import 'package:morar/feature/insurance/presentation/widget/insurance_table.dart';

import '../../helpers/fake_url_launcher.dart';
import '../../helpers/firebase_mocks.dart';
import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';
import 'insurance_page_helpers.dart';

// Fallback nativo do UrlLauncherNative: sem plugin precisa responder com
// PlatformException.
const _nativeUrlChannel = MethodChannel('com.example.app/url_launcher');

void main() {
  late PageHarness harness;
  late RecordingNavigatorObserver observer;
  late FakeUrlLauncherPlatform launcher;
  late List<MethodCall> platformCalls;

  setUp(() async {
    harness = await installPageHarness();
    observer = RecordingNavigatorObserver();
    launcher = installFakeUrlLauncher();
    platformCalls = mockPlatformChannel();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_nativeUrlChannel,
            (call) async => throw PlatformException(code: 'sem-plugin'));
    harness.sessionBloc.insuranceTable = insuranceTable();
    harness.http.on('GET', insurancePath, body: insuranceJson());
    harness.http.on('POST', insurancePath, body: '');
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_nativeUrlChannel, null);
  });

  InsuranceController controller() => harness.resolve<InsuranceController>();

  List<String> requests() =>
      harness.http.requests.map((r) => '${r.method} ${r.url.path}').toList();

  Future<void> scrollTo(WidgetTester tester, Finder finder) async {
    await tester.scrollUntilVisible(finder, 200,
        scrollable: find.byType(Scrollable).first);
    await tester.pumpAndSettle();
  }

  testWidgets('seguro contratado (plano básico) mostra tabela e ações',
      (tester) async {
    await pumpInsurance(tester, observer: observer);

    expect(requests(), ['GET $insurancePath']);
    expect(find.byType(InsuranceTable), findsOneWidget);
    expect(find.text('Acionar Assistência 24h'), findsNWidgets(2));
    expect(find.text('Coberturas Especiais'), findsOneWidget);
    expect(
        find.textContaining('Proporcionar tranquilidade'), findsOneWidget);
    expect(find.textContaining('Serviços de Assistência 24h'), findsOneWidget);
    expect(find.text('insurance_cancel_hiring'), findsOneWidget);
    expect(find.textContaining('Central de Atendimento Vila Velha'),
        findsOneWidget);
    expect(find.textContaining('Assistência 24 horas Vila Velha'),
        findsOneWidget);
    expect(controller().minCost, 10);
    expect(controller().maxCost, 30);
    expect(fakeAnalytics.eventNames,
        contains('comodidades_parceiro_seguros_acessar'));

    await expectLater(
      find.byType(InsurancePage),
      matchesGoldenFile('goldens/insurance_page_hired.png'),
    );

    // Acionar assistência (topo e rodapé) liga para o telefone da tabela.
    await tester.tap(find.text('Acionar Assistência 24h').first);
    await tester.pumpAndSettle();
    await scrollTo(tester, find.text('Acionar Assistência 24h').last);
    await tester.tap(find.text('Acionar Assistência 24h').last);
    await tester.pumpAndSettle();
    expect(launcher.launched, hasLength(2));
    for (final url in launcher.launched) {
      expect(url, startsWith('tel:'));
      expect(url, endsWith('08001234567'));
    }

    // Link dos termos abre o pdf do plano básico.
    final termos = find.byWidgetPredicate((w) =>
        w is RichText && w.text.toPlainText().startsWith('* Consultar os '));
    await scrollTo(tester, termos);
    final span = (tester.widget<RichText>(termos).text as TextSpan)
        .children!
        .first as TextSpan;
    (span.recognizer as TapGestureRecognizer).onTap!();
    await tester.pumpAndSettle();
    expect(launcher.launched.last, controller().linkTermos);

    // Botões de telefone copiam o número e avisam.
    await scrollTo(tester, find.textContaining('Central de Atendimento'));
    await tester.tap(find.textContaining('Central de Atendimento'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(copiedTexts(platformCalls), ['08001234567']);
    expect(find.text('Número de telefone copiado'), findsOneWidget);
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    await scrollTo(tester, find.textContaining('Assistência 24 horas'));
    await tester.tap(find.textContaining('Assistência 24 horas'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(copiedTexts(platformCalls).last, '11 40040000');
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
  });

  testWidgets('cancelar contratação: voltar fecha, confirmar cancela',
      (tester) async {
    await pumpInsurance(tester, observer: observer);

    await scrollTo(tester, find.text('insurance_cancel_hiring'));
    await tester.tap(find.text('insurance_cancel_hiring'));
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsOneWidget);
    expect(find.textContaining('insurance_want_cancel', findRichText: true),
        findsOneWidget);
    expect(find.text('insurance_home_no_care'), findsOneWidget);

    await tester.tap(find.text('BACK'));
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsNothing);
    expect(requests(), ['GET $insurancePath']);

    await tester.tap(find.text('insurance_cancel_hiring'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('CONFIRM'));
    await tester.pumpAndSettle();

    expect(requests(), ['GET $insurancePath', 'POST $insurancePath']);
    expect(fakeAnalytics.eventNames,
        contains('comodidades_parceiro_seguros_cancelar'));
    expect(find.byType(InsurancePage), findsNothing);
    expect(find.byType(InsuranceCancelPage), findsOneWidget);
    expect(find.text('insurance_hiring_been_cancelled'), findsOneWidget);
    expect(find.text('Edifício Lello - 101'), findsOneWidget);

    await tester.tap(find.text('finish'));
    await tester.pumpAndSettle();
    expect(observer.pushedNames.last, ApplicationRoute.insurance);
    expect(findRoute(ApplicationRoute.insurance), findsOneWidget);
    expect(find.byType(InsuranceCancelPage), findsNothing);
  });

  testWidgets('proposta: aceitar os termos habilita contratar', (tester) async {
    harness.http.on('GET', insurancePath,
        body: insuranceJson(status: 'proposal', cost: 20));
    await pumpInsurance(tester, observer: observer);

    expect(find.byType(InsuranceTable), findsOneWidget);
    expect(find.text('insurance_contract_insurance_house'), findsNWidgets(2));
    expect(find.text('Apenas'), findsOneWidget);
    expect(find.textContaining('/mês'), findsOneWidget);
    // O botão de preço é apenas informativo.
    await scrollTo(tester, find.text('Apenas'));
    await tester.tap(find.text('Apenas'));
    await tester.pumpAndSettle();
    expect(find.byType(InsuranceContractDialog), findsNothing);
    expect(find.text('insurance_cancel_hiring'), findsNothing);
    // Plano intermediário usa a cobertura "completa".
    expect(find.textContaining('Serviços de Assistência 24h'), findsOneWidget);

    // Sem aceitar os termos o botão é ignorado.
    await tester.tap(find.text('insurance_contract_insurance_house').first,
        warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(find.byType(InsuranceContractDialog), findsNothing);
    expect(
      tester
          .widget<IgnorePointer>(find.ancestor(
            of: find.text('insurance_contract_insurance_house').first,
            matching: find.byType(IgnorePointer),
          ).first)
          .ignoring,
      isTrue,
    );

    await scrollTo(tester, find.byType(Checkbox));
    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isTrue);

    await scrollTo(tester, find.text('insurance_contract_insurance_house').last);
    await tester.tap(find.text('insurance_contract_insurance_house').last);
    await tester.pumpAndSettle();
    expect(find.byType(InsuranceContractDialog), findsOneWidget);
    expect(find.text('insurance_contract_terms'), findsOneWidget);
    expect(find.text('Edifício Lello - 101'), findsOneWidget);
    expect(find.text('insurance_use_terms_download'), findsOneWidget);

    await tester.tap(find.text('confirm'));
    await tester.pumpAndSettle();

    expect(requests(), ['GET $insurancePath', 'POST $insurancePath']);
    expect(fakeAnalytics.eventNames,
        contains('comodidades_parceiro_seguros_contratar'));
    expect(find.byType(InsuranceSuccessPage), findsOneWidget);
    expect(find.text('insurance_success_requested'), findsOneWidget);

    await tester.tap(find.text('ready'));
    await tester.pumpAndSettle();
    expect(findRoute(ApplicationRoute.insurance), findsOneWidget);
  });

  testWidgets('proposta: botão do topo abre o diálogo após aceitar',
      (tester) async {
    harness.http.on('GET', insurancePath,
        body: insuranceJson(status: 'proposal', cost: 10));
    await pumpInsurance(tester, observer: observer);

    await scrollTo(tester, find.byType(Checkbox));
    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    await scrollTo(tester, find.text('insurance_contract_insurance_house').first);
    await tester.tap(find.text('insurance_contract_insurance_house').first);
    await tester.pumpAndSettle();
    expect(find.byType(InsuranceContractDialog), findsOneWidget);

    // "cancel" registra a desistência e fecha.
    fakeAnalytics.reset();
    await tester.tap(find.text('cancel'));
    await tester.pumpAndSettle();
    expect(find.byType(InsuranceContractDialog), findsNothing);
    expect(fakeAnalytics.eventNames,
        contains('comodidades_parceiro_seguros_desistir'));
    expect(requests(), ['GET $insurancePath']);
  });

  testWidgets('proposta: termos abrem o link básico ou completo',
      (tester) async {
    harness.http.on('GET', insurancePath,
        body: insuranceJson(status: 'proposal', cost: 10));
    await pumpInsurance(tester);

    TextSpan termsSpan() {
      final rich = find.byWidgetPredicate((w) =>
          w is RichText &&
          w.text.toPlainText().startsWith('insurance_terms_title'));
      return (tester.widget<RichText>(rich).text as TextSpan).children!.first
          as TextSpan;
    }

    (termsSpan().recognizer as TapGestureRecognizer).onTap!();
    await tester.pumpAndSettle();
    expect(launcher.launched, [controller().linkTermos]);

    harness.http.on('GET', insurancePath,
        body: insuranceJson(status: 'proposal', cost: 30));
    await controller().getInsurance();
    await tester.pumpAndSettle();
    (termsSpan().recognizer as TapGestureRecognizer).onTap!();
    await tester.pumpAndSettle();
    expect(launcher.launched.last, controller().linkTermosCompleto);
  });

  testWidgets('falha ao contratar mostra o erro', (tester) async {
    harness.http.on('GET', insurancePath,
        body: insuranceJson(status: 'proposal', cost: 20));
    harness.http.on('POST', insurancePath, status: 500, body: {'m': 'x'});
    await pumpInsurance(tester);

    await scrollTo(tester, find.byType(Checkbox));
    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    await scrollTo(tester, find.text('insurance_contract_insurance_house').last);
    await tester.tap(find.text('insurance_contract_insurance_house').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('confirm'));
    await tester.pumpAndSettle();

    expect(controller().bloc.state, const FailedInsuranceState());
    expect(find.byType(UnexpectedErrorWidget), findsOneWidget);
    expect(find.byType(InsuranceSuccessPage), findsNothing);
  });

  /// O `PDFScreen` usa um visualizador nativo que não roda no `flutter
  /// test`: o download dos termos grava o arquivo (http real bloqueado pelo
  /// binding devolve corpo vazio) e desmontamos a árvore antes do frame que
  /// construiria o visualizador.
  testWidgets('diálogo de contratação baixa os termos e abre o pdf',
      (tester) async {
    final dir = installFakePathProvider();
    harness.http.on('GET', insurancePath,
        body: insuranceJson(status: 'proposal', cost: 20));
    await pumpInsurance(tester, observer: observer);

    await scrollTo(tester, find.byType(Checkbox));
    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    await scrollTo(tester, find.text('insurance_contract_insurance_house').last);
    await tester.tap(find.text('insurance_contract_insurance_house').last);
    await tester.pumpAndSettle();
    final pushes = observer.pushed.length;

    await tester.runAsync(() async {
      await tester.tap(find.text('insurance_use_terms_download'));
      await tester.pump();
      for (var i = 0; i < 20 && observer.pushed.length == pushes; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }
      expect(File('${dir.path}/termos_de_contratacao.pdf').existsSync(), isTrue);
      expect(observer.pushed.length, pushes + 1);
      await tester.pumpWidget(const SizedBox());
    });
  });

  testWidgets('cancelamento e contratação pendentes mostram o aviso',
      (tester) async {
    harness.http.on('GET', insurancePath,
        body: insuranceJson(status: 'cancellation_pending'));
    await pumpInsurance(tester);
    expect(find.text('insurance_in_progress_cancellation'), findsOneWidget);
    expect(find.byType(InsuranceTable), findsNothing);

    harness.http.on('GET', insurancePath,
        body: insuranceJson(status: 'membership_pending'));
    await controller().getInsurance();
    await tester.pumpAndSettle();
    expect(find.text('insurance_in_progress_contracting'), findsOneWidget);
    expect(find.text('insurance_in_progress_cancellation'), findsNothing);

    // Pendente no plano de custo máximo mostra os textos do plano completo.
    harness.http.on('GET', insurancePath,
        body: insuranceJson(status: 'membership_pending', cost: 30));
    await controller().getInsurance();
    await tester.pumpAndSettle();
    expect(find.text('insurance_in_progress_contracting'), findsOneWidget);
    expect(find.textContaining('Agora você conta com a nossa ajuda'),
        findsOneWidget);
    expect(find.textContaining('E com assistência 24hs'), findsOneWidget);
    expect(InsurancePageArgs(), isA<InsurancePageArgs>());
  });

  testWidgets('seguro indisponível mostra o informativo e os telefones',
      (tester) async {
    harness.http.on('GET', insurancePath,
        body: insuranceJson(status: 'unavailable'));
    await pumpInsurance(tester);

    expect(find.textContaining('Em breve, o Seguro Casa Protegida'),
        findsOneWidget);
    expect(find.text('Sorteios mensais de R\$ 10.000,00*'), findsOneWidget);
    expect(find.textContaining('Cobertura para danos', findRichText: true),
        findsOneWidget);
    expect(find.textContaining('Contratação por menos de', findRichText: true),
        findsOneWidget);
    expect(find.textContaining('Central de Atendimento'), findsOneWidget);
    expect(find.textContaining('Assistência 24 horas'), findsOneWidget);
    expect(find.byType(InsuranceTable), findsNothing);
  });

  testWidgets('plano de custo máximo mostra os textos do plano completo',
      (tester) async {
    harness.http.on('GET', insurancePath, body: insuranceJson(cost: 30));
    await pumpInsurance(tester);

    expect(find.textContaining('Agora você conta com a nossa ajuda'),
        findsOneWidget);
    expect(find.textContaining('Com o seguro ', findRichText: true),
        findsOneWidget);
    expect(find.textContaining('E com assistência 24hs'), findsOneWidget);
    expect(find.textContaining('Serviços de Assistência 24h'), findsNothing);
    expect(find.textContaining('Proporcionar tranquilidade'), findsNothing);
    expect(find.byType(InsuranceTable), findsOneWidget);
  });

  testWidgets('erro na api mostra o widget de erro', (tester) async {
    harness.http.failAll();
    await pumpInsurance(tester);

    expect(find.byType(UnexpectedErrorWidget), findsOneWidget);
    expect(find.byType(InsuranceTable), findsNothing);
  });

  testWidgets('sem tabela de prêmios ou sem prêmio compatível falha',
      (tester) async {
    harness.sessionBloc.insuranceTable = null;
    await pumpInsurance(tester);
    expect(find.byType(UnexpectedErrorWidget), findsOneWidget);

    harness.sessionBloc.insuranceTable = insuranceTable();
    harness.http.on('GET', insurancePath, body: insuranceJson(cost: 99));
    await controller().getInsurance();
    await tester.pumpAndSettle();
    expect(find.byType(UnexpectedErrorWidget), findsOneWidget);
  });

  testWidgets('estado de loading mostra o indicador', (tester) async {
    await pumpInsurance(tester);
    await emitState(tester, controller().bloc, const LoadingInsuranceState(),
        settle: false);
    await tester.pump();

    expect(find.byType(LoadingWidget), findsOneWidget);
    expect(find.byType(InsuranceTable), findsNothing);
  });

  testWidgets('seta e voltar do sistema fecham a página', (tester) async {
    await pumpInsurance(tester, observer: observer);

    await tester.tap(find.byIcon(Icons.arrow_back_ios));
    await tester.pumpAndSettle();
    expect(find.byType(InsurancePage), findsNothing);
    expect(find.byKey(insuranceBaseKey), findsOneWidget);

    await tester.tap(find.byKey(openInsuranceKey));
    await tester.pumpAndSettle();
    expect(find.byType(InsurancePage), findsOneWidget);

    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    await navigator.maybePop();
    await tester.pumpAndSettle();
    expect(find.byType(InsurancePage), findsNothing);
    expect(find.byKey(insuranceBaseKey), findsOneWidget);
  });
}
