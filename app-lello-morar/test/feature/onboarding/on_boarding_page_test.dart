import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/feature/onboarding/presentation/page/on_boarding_page.dart';
import 'package:shared_features/shared_features.dart';

import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';

void main() {
  late PageHarness harness;
  late RecordingNavigatorObserver observer;

  setUp(() async {
    harness = await installPageHarness();
    observer = RecordingNavigatorObserver();
  });

  Future<void> pump(WidgetTester tester) =>
      pumpPage(tester, OnBoardingPage(), observer: observer);

  testWidgets('mostra título, descrição e ações', (tester) async {
    await pump(tester);

    expect(find.text('on_boarding_title'), findsOneWidget);
    expect(find.text('on_boarding_description'), findsOneWidget);
    expect(find.text('sign_up'), findsOneWidget);
    expect(find.text('sign_in'), findsOneWidget);
    await expectLater(
      find.byType(OnBoardingPage),
      matchesGoldenFile('goldens/on_boarding_page.png'),
    );
  });

  testWidgets(
      '"me cadastrar" pede permissões, vai para o login e marca o onboarding',
      (tester) async {
    await pump(tester);

    await tester.tap(find.text('sign_up'));
    await tester.pumpAndSettle();

    expect(observer.pushedNames.last, SharedApplicationRoute.login);
    final args = observer.pushed.last.settings.arguments as AuthArguments;
    expect(args.goToRegister, isTrue);
    await tester.runAsync(
        () => Future.delayed(const Duration(milliseconds: 50)));
    final prefs = await SharedPreferences.getInstance();
    expect(
      prefs.getString(SharedPreferencesKeys.ownerBootData),
      contains('false'),
    );
  });

  testWidgets('"entrar" vai para o login sem cadastro', (tester) async {
    await pump(tester);

    await tester.tap(find.text('sign_in'));
    await tester.pumpAndSettle();

    expect(observer.pushedNames.last, SharedApplicationRoute.login);
    final args = observer.pushed.last.settings.arguments as AuthArguments;
    expect(args.goToRegister, isFalse);
    expect(harness.http.requests, isEmpty);
  });
}
