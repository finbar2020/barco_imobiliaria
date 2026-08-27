import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/insurance/domain/entity/insurance.dart';
import 'package:morar/feature/insurance/domain/entity/insurance_info.dart';
import 'package:morar/feature/insurance/presentation/bloc/insurance_event.dart';
import 'package:morar/feature/insurance/presentation/bloc/insurance_state.dart';
import 'package:morar/feature/insurance/presentation/controller/insurance_controller.dart';
import 'package:morar/feature/insurance/presentation/pages/insurance_cancel_page.dart';
import 'package:morar/feature/insurance/presentation/pages/insurance_success_page.dart';
import 'package:morar/feature/insurance/presentation/widget/insurance_contract_dialog.dart';
import 'package:morar/feature/insurance/presentation/widget/insurance_table.dart';

import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';
import 'insurance_page_helpers.dart';

void main() {
  late PageHarness harness;
  late RecordingNavigatorObserver observer;

  setUp(() async {
    harness = await installPageHarness(
      sessionBloc: SessionWithRemoteConfig(insuranceTable: insuranceTable()),
    );
    observer = RecordingNavigatorObserver();
    harness.http.on('GET', insurancePath, body: insuranceJson());
  });

  testWidgets('InsuranceTable alterna as linhas e usa "*" sem título',
      (tester) async {
    final table = insuranceTable();
    await pumpApp(
      tester,
      InsuranceTable(model: table, selectedPremium: table.premio.first),
      surface: const Size(400, 700),
    );

    expect(find.text('Prêmio Mensal'), findsOneWidget);
    expect(find.textContaining('10'), findsWidgets);
    expect(find.text('Incêndio'), findsOneWidget);
    expect(find.text('Roubo'), findsOneWidget);
    expect(find.text('*'), findsOneWidget);
    expect(find.text('R\$ 5.000'), findsOneWidget);
    expect(find.text('R\$ 1.000'), findsOneWidget);

    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/insurance_table.png'),
    );

    // Última linha em posição par recebe o canto arredondado.
    final widget = tester.widget<InsuranceTable>(find.byType(InsuranceTable));
    final theme = Theme.of(tester.element(find.byType(InsuranceTable)));
    final even = widget.buildEvenRow(theme, 't', 'v', last: true);
    final pair = widget.buildPairRow(theme, 't', 'v');
    expect(even.children, hasLength(2));
    expect(pair.children, hasLength(2));
  });

  testWidgets('InsuranceCancelPage mostra a unidade e finaliza',
      (tester) async {
    await pumpPage(tester, const InsuranceCancelPage(), observer: observer);

    expect(find.text('insurance_thanks_service'), findsOneWidget);
    expect(find.text('insurance_hiring_been_cancelled'), findsOneWidget);
    expect(find.text('Edifício Lello - 101'), findsOneWidget);
    expect(find.text('insurance_home_care_cancelled'), findsOneWidget);
    expect(find.text('insurance_more_details_cancelled'), findsOneWidget);
    await expectLater(
      find.byType(InsuranceCancelPage),
      matchesGoldenFile('goldens/insurance_cancel_page.png'),
    );

    await tester.tap(find.text('finish'));
    await tester.pumpAndSettle();

    expect(observer.pushedNames.last, ApplicationRoute.insurance);
    expect(findRoute(ApplicationRoute.insurance), findsOneWidget);
  });

  testWidgets('InsuranceSuccessPage mostra a unidade e conclui',
      (tester) async {
    await pumpPage(tester, const InsuranceSuccessPage(), observer: observer);

    expect(find.text('insurance_success_requested'), findsOneWidget);
    expect(find.text('Edifício Lello - 101'), findsOneWidget);
    expect(find.text('insurance_home_deserve'), findsOneWidget);
    expect(find.text('insurance_more_details_email'), findsOneWidget);
    await expectLater(
      find.byType(InsuranceSuccessPage),
      matchesGoldenFile('goldens/insurance_success_page.png'),
    );

    await tester.tap(find.text('ready'));
    await tester.pumpAndSettle();

    expect(observer.pushedNames.last, ApplicationRoute.insurance);
    expect(findRoute(ApplicationRoute.insurance), findsOneWidget);
  });

  testWidgets('InsuranceContractDialog sem termo de uso não oferece download',
      (tester) async {
    final controller = harness.resolve<InsuranceController>();
    final table = insuranceTable();
    // O diálogo faz cast do estado para `LoadedInsuranceState` no build.
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    controller.bloc.emit(LoadedInsuranceState(
      model: Insurance()
        ..insuranceStatus = 'proposal'
        ..insuranceInfo = InsuranceInfo(),
      selectedPremium: table.premio.first,
      insuranceData: table,
    ));
    await pumpPage(
      tester,
      Scaffold(body: InsuranceContractDialog(controller: controller)),
    );

    expect(find.text('insurance_contract_terms'), findsOneWidget);
    expect(find.text('insurance_contract_terms_details'), findsOneWidget);
    expect(find.text('insurance_use_terms_download'), findsNothing);
    expect(find.text('confirm'), findsOneWidget);
    expect(find.text('cancel'), findsOneWidget);
  });

  test('eventos e estados simples do seguro têm props vazios', () {
    expect(const InsuranceLoadingEvent().props, isEmpty);
    expect(const InsuranceFailedEvent().props, isEmpty);
    expect(const LoadingInsuranceState().props, isEmpty);
    expect(const FailedInsuranceState().props, isEmpty);
    expect(const InsuranceLoadingEvent(), const InsuranceLoadingEvent());
  });

  testWidgets('controller lê os links dos termos do remote config',
      (tester) async {
    harness.remoteConfig.values = {
      'insurance_terms_url': jsonEncode({'link': 'https://rc/basico.pdf'}),
      'insurance_terms_url_completo':
          jsonEncode({'link': 'https://rc/completo.pdf'}),
    };
    await pumpInsurance(tester);

    final controller = harness.resolve<InsuranceController>();
    expect(controller.linkTermos, 'https://rc/basico.pdf');
    expect(controller.linkTermosCompleto, 'https://rc/completo.pdf');
    expect(find.byType(InsuranceTable), findsOneWidget);

    // Sem valores no remote config os links padrão são mantidos.
    harness.remoteConfig.values = {};
    await controller.getInsurance();
    await tester.pumpAndSettle();
    expect(controller.linkTermos, 'https://rc/basico.pdf');
  });
}
