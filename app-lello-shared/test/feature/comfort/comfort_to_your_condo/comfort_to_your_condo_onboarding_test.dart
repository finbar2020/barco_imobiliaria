import 'package:essentials/enum/app_origin_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_to_your_condo/pages/comfort_to_your_condo_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_to_your_condo/widgets/comfort_to_your_condo_onboarding.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_to_your_condo/widgets/comfort_to_your_condo_onboarding_widget.dart';

import '../../../helpers/firebase_mocks.dart';
import '../../../helpers/pump_app.dart';
import 'to_your_condo_harness.dart';

void main() {
  late RecordingNavigatorObserver observer;
  late ToYourCondoHarness harness;

  setUpAll(() async {
    await setUpFakeFirebase();
  });

  setUp(() {
    observer = RecordingNavigatorObserver();
  });

  tearDown(() async {
    await harness.dispose();
  });

  Future<void> pumpOnboarding(WidgetTester tester, {bool fromIcon = false}) async {
    await pumpPage(
      tester,
      basePage(),
      observer: observer,
      routes: {onboardingRouteName: (_) => harness.onboarding(fromIcon: fromIcon)},
    );
    await pushRoute(tester, onboardingRouteName);
  }

  const titulo1 = 'Produtos e serviços para o seu condomínio';
  const titulo2 = 'O que precisar, te ajudamos a encontrar';

  testWidgets('mostra a primeira página, avança e volta pelo ícone',
      (tester) async {
    harness = ToYourCondoHarness.create();
    await pumpOnboarding(tester, fromIcon: true);

    expect(find.text(titulo1), findsOneWidget);
    expect(find.text(titulo2), findsNothing);
    expect(find.text('announcements_request_action_title'), findsOneWidget);
    expect(find.text('comfort_want_know'), findsNothing);
    expect(find.byType(ComfortToYourCondoOnboardingWidet), findsOneWidget);

    await expectLater(find.byType(MaterialApp),
        matchesGoldenFile('goldens/to_your_condo_onboarding_page1.png'));

    await tester.tap(find.text('announcements_request_action_title'));
    await tester.pumpAndSettle();

    expect(find.text(titulo2), findsOneWidget);
    expect(find.text('comfort_want_know'), findsOneWidget);
    expect(find.text('announcements_request_action_title'), findsNothing);

    await tester.tap(find.text('comfort_want_know'));
    await tester.pumpAndSettle();

    expect(observer.popped, hasLength(1));
    expect(findBasePage(), findsOneWidget);
  });

  testWidgets('quero conhecer (sem vir do ícone) substitui pela página do condomínio',
      (tester) async {
    harness = ToYourCondoHarness.create();
    await harness.loadPartners();
    await pumpOnboarding(tester);

    await tester.tap(find.text('announcements_request_action_title'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('comfort_want_know'));
    await pumpFrames(tester);

    expect(find.byType(ComfortToYourCondoOnboarding), findsNothing);
    expect(find.byType(ToYourCondoPage), findsOneWidget);
    expect(find.text('Para seu condomínio'), findsOneWidget);
    expect(observer.popped, isEmpty);
    // pushReplacement: a página base continua embaixo.
    tester.state<NavigatorState>(find.byType(Navigator)).pop();
    await pumpFrames(tester);
    expect(findBasePage(), findsOneWidget);
  });

  testWidgets('pular pelo ícone volta; pular sem ícone substitui', (tester) async {
    harness = ToYourCondoHarness.create();
    await harness.loadPartners();
    await pumpOnboarding(tester, fromIcon: true);

    await tester.tap(find.text('skip').first);
    await tester.pumpAndSettle();
    expect(observer.popped, hasLength(1));
    expect(findBasePage(), findsOneWidget);

    // Reconstrói sem vir do ícone.
    await pumpPage(
      tester,
      basePage(),
      observer: observer,
      routes: {onboardingRouteName: (_) => harness.onboarding()},
    );
    await pushRoute(tester, onboardingRouteName);
    await tester.tap(find.text('skip').first);
    await pumpFrames(tester);

    expect(find.byType(ToYourCondoPage), findsOneWidget);
  });

  testWidgets('arrastar o PageView muda a página e o indicador', (tester) async {
    harness = ToYourCondoHarness.create();
    await pumpOnboarding(tester, fromIcon: true);

    await tester.drag(find.byType(PageView), const Offset(-400, 0));
    await tester.pumpAndSettle();

    expect(find.text(titulo2), findsOneWidget);
    expect(find.text('comfort_want_know'), findsOneWidget);

    await tester.drag(find.byType(PageView), const Offset(400, 0));
    await tester.pumpAndSettle();
    expect(find.text(titulo1), findsOneWidget);
    expect(find.text('announcements_request_action_title'), findsOneWidget);
  });

  testWidgets('widget de onboarding aceita subtítulo em texto', (tester) async {
    harness = ToYourCondoHarness.create(origin: AppOriginEnum.owner);
    await pumpApp(
      tester,
      ComfortToYourCondoOnboardingWidet(
        numPages: 3,
        comfortPartnersController: harness.controller,
        assetPath: 'assets/x.svg',
        title: 'Título',
        subtitle: 'Subtítulo em texto',
        currentPage: 2,
        appContainer: harness.container,
        appOriginEnum: AppOriginEnum.owner,
        reference: 'R1',
      ),
    );

    expect(find.text('Título'), findsOneWidget);
    expect(find.text('Subtítulo em texto'), findsOneWidget);
    expect(find.byType(AnimatedContainer), findsNWidgets(3));
  });
}
