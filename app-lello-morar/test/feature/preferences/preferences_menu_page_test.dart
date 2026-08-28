import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/navigation/application_rbac.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/preferences/presentation/pages/notification/pages/notifications_preferences.dart';
import 'package:morar/feature/preferences/presentation/pages/notification/widget/preferences_notification_toggle.dart';
import 'package:morar/feature/preferences/presentation/pages/preferences_menu_page.dart';
import 'package:morar/feature/preferences/presentation/widget/preferences_success_page.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';
import 'preferences_page_helpers.dart';

void main() {
  late PageHarness harness;
  late RecordingNavigatorObserver observer;

  group('com personalização', () {
    setUp(() async {
      harness = await installPageHarness();
      observer = RecordingNavigatorObserver();
    });

    testWidgets('mostra os três itens quando tudo está liberado', (tester) async {
      await pumpPage(tester, const PreferencesMenuPage(), observer: observer);

      expect(find.text('Edifício Lello - 101'), findsOneWidget);
      expect(find.text('preferences_zero_paper_campaign'), findsOneWidget);
      expect(find.text('notification'), findsOneWidget);
      expect(find.text('preferences_cards_tile'), findsOneWidget);
      expect(find.byType(Divider), findsNWidgets(2));
      expect(
          harness.sessionBloc.rbacChecked,
          containsAll([
            ApplicationRbac.morarPreferenciasPapelzero,
            ApplicationRbac.morarPreferenciasNotificacoes,
          ]));
      await expectLater(
        find.byType(PreferencesMenuPage),
        matchesGoldenFile('goldens/preferences_menu_page.png'),
      );
    });

    testWidgets('papel zero e cards da home navegam para as rotas',
        (tester) async {
      await pumpPage(tester, const PreferencesMenuPage(), observer: observer);

      await tester.tap(find.text('preferences_zero_paper_campaign'));
      await tester.pumpAndSettle();
      expect(observer.pushedNames.last, ApplicationRoute.preferencesZeroPaper);
      expect(findRoute(ApplicationRoute.preferencesZeroPaper), findsOneWidget);

      tester.state<NavigatorState>(find.byType(Navigator)).pop();
      await tester.pumpAndSettle();

      await tester.tap(find.text('preferences_cards_tile'));
      await tester.pumpAndSettle();
      expect(observer.pushedNames.last, ApplicationRoute.preferencesHome);
      expect(findRoute(ApplicationRoute.preferencesHome), findsOneWidget);
    });

    testWidgets('notificações abrem o bottom sheet e salvar leva ao sucesso',
        (tester) async {
      harness.http.on('GET', notificationPath, body: [notificationJson('boletos')]);
      harness.http.on('PUT', notificationPath, body: {});

      await pumpPage(tester, const PreferencesMenuPage(), observer: observer);
      await tester.tap(find.text('notification'));
      await tester.pumpAndSettle();

      expect(find.byType(PreferencesNotificationPage), findsOneWidget);
      expect(find.byType(PreferencesNotificationToggle), findsNWidgets(2));

      await tester.tap(find.text('save'));
      await tester.pumpAndSettle();

      expect(find.byType(PreferencesNotificationPage), findsNothing);
      expect(find.byType(PreferencesSuccessPage), findsOneWidget);
      expect(find.byType(PreferencesMenuPage), findsNothing);
    });

    testWidgets('sem os rbacs os itens somem (sem divisória)', (tester) async {
      harness.sessionBloc.rbacAllowed = false;

      await pumpPage(tester, const PreferencesMenuPage());

      expect(find.text('preferences_zero_paper_campaign'), findsNothing);
      expect(find.text('notification'), findsNothing);
      expect(find.text('preferences_cards_tile'), findsOneWidget);
      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('só o rbac de notificações mantém a divisória', (tester) async {
      harness.sessionBloc.allowedRbacs = {
        ApplicationRbac.morarPreferenciasNotificacoes,
      };

      await pumpPage(tester, const PreferencesMenuPage());

      expect(find.text('preferences_zero_paper_campaign'), findsNothing);
      expect(find.text('notification'), findsOneWidget);
      expect(find.byType(Divider), findsNWidgets(2));
    });
  });

  group('sem personalização', () {
    setUp(() async {
      harness = await installPageHarness(
          sessionBloc: FakeSessionBloc(personalizationActive: false));
    });

    testWidgets('esconde o item de cards da home', (tester) async {
      await pumpPage(tester, const PreferencesMenuPage());

      expect(find.text('preferences_zero_paper_campaign'), findsOneWidget);
      expect(find.text('notification'), findsOneWidget);
      expect(find.text('preferences_cards_tile'), findsNothing);
      expect(find.byType(Divider), findsOneWidget);
    });
  });
}
