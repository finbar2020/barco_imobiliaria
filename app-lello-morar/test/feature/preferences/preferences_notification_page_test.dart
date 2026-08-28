import 'dart:convert';

import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/preferences/presentation/pages/notification/bloc/preferences_notification_state.dart';
import 'package:morar/feature/preferences/presentation/pages/notification/controller/preferences_notification_controller.dart';
import 'package:morar/feature/preferences/presentation/pages/notification/pages/notifications_preferences.dart';
import 'package:morar/feature/preferences/presentation/pages/notification/widget/preferences_notification_checkbox.dart';
import 'package:morar/feature/preferences/presentation/pages/notification/widget/preferences_notification_toggle.dart';
import 'package:morar/feature/preferences/presentation/widget/preferences_success_page.dart';
import 'package:morar/feature/session/domain/entity/session.dart';
import 'package:morar/feature/session/presentation/bloc/session_state.dart';
import 'package:shared_features/shared_features.dart' show SharedApplicationRoute;

import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';
import 'preferences_page_helpers.dart';

void main() {
  late PageHarness harness;
  late RecordingNavigatorObserver observer;

  setUp(() async {
    harness = await installPageHarness();
    observer = RecordingNavigatorObserver();
  });

  final routes = <String, WidgetBuilder>{
    ApplicationRoute.preferencesNotification: (_) =>
        const PreferencesNotificationPage(),
  };

  PreferencesNotificationController controller() =>
      harness.resolve<PreferencesNotificationController>();

  void mockGet([List<Map<String, dynamic>>? body]) => harness.http.on(
      'GET', notificationPath,
      body: body ??
          [
            notificationJson('boletos'),
            notificationJson('comunicados', active: false),
            notificationJson('desconhecido'),
          ]);

  /// Toggles na ordem da árvore: 0 = "todos", 1.. = módulos.
  Finder toggle(int index) => find.byType(PreferencesNotificationToggle).at(index);
  bool valueOf(WidgetTester tester, int index) =>
      tester.widget<PreferencesNotificationToggle>(toggle(index)).value;
  Future<void> flip(WidgetTester tester, int index) async {
    final sw = find.descendant(of: toggle(index), matching: find.byType(Switch));
    await tester.ensureVisible(sw);
    await tester.tap(sw);
    await tester.pumpAndSettle();
  }

  testWidgets('lista os módulos com os títulos traduzidos', (tester) async {
    mockGet();

    await pumpPage(tester, const PreferencesNotificationPage());

    expect(harness.http.requests.single.url.path, notificationPath);
    expect(controller().bloc.state, isA<PreferencesNotificationLoadedState>());
    expect(find.text('preferences_notification_page_title'), findsOneWidget);
    expect(find.text('preferences_notification_toggle_all'), findsOneWidget);
    expect(find.byType(PreferencesNotificationToggle), findsNWidgets(4));
    expect(find.text('Notification_module_income_control_billets'), findsOneWidget);
    expect(find.text('Notification_module_announcements'), findsOneWidget);
    // Módulo sem tradução mostra o próprio nome.
    expect(find.text('Desconhecido'), findsOneWidget);
    expect([for (var i = 0; i < 4; i++) valueOf(tester, i)],
        [false, true, false, true]);
    await expectLater(
      find.byType(PreferencesNotificationPage),
      matchesGoldenFile('goldens/preferences_notification_page.png'),
    );
  });

  testWidgets('módulo nulo é ignorado', (tester) async {
    mockGet([notificationJson(null), notificationJson('sistema')]);

    await pumpPage(tester, const PreferencesNotificationPage());

    expect(find.byType(PreferencesNotificationToggle), findsNWidgets(2));
    expect(find.text('Notification_module_others'), findsOneWidget);
  });

  testWidgets('"todos" liga/desliga tudo e acompanha os itens', (tester) async {
    mockGet();
    await pumpPage(tester, const PreferencesNotificationPage());

    await flip(tester, 0);
    expect([for (var i = 0; i < 4; i++) valueOf(tester, i)],
        [true, true, true, true]);

    // Desligar um item desliga o "todos"; religar volta a ligar.
    await flip(tester, 2);
    expect(valueOf(tester, 0), isFalse);
    expect(valueOf(tester, 2), isFalse);
    await flip(tester, 2);
    expect(valueOf(tester, 0), isTrue);

    await flip(tester, 0);
    expect([for (var i = 0; i < 4; i++) valueOf(tester, i)],
        [false, false, false, false]);
  });

  testWidgets('salvar envia os módulos e abre a tela de sucesso',
      (tester) async {
    mockGet();
    harness.http.on('PUT', notificationPath, body: {});

    await pumpPage(
      tester,
      RouteLauncher(route: ApplicationRoute.preferencesNotification),
      routes: routes,
      observer: observer,
    );
    await flip(tester, 2);
    await tester.ensureVisible(find.text('save'));
    await tester.tap(find.text('save'));
    await tester.pumpAndSettle();

    final put = harness.http.requests.lastWhere((r) => r.method == 'PUT');
    expect(put.url.path, notificationPath);
    expect(jsonDecode(put.body), [
      {'active': true, 'module': 'boletos'},
      {'active': true, 'module': 'comunicados'},
      {'active': true, 'module': 'desconhecido'},
    ]);
    expect(controller().bloc.state, isA<PreferencesNotificationSuccessState>());
    // O listener fecha a tela (bottom sheet) e empilha o sucesso.
    expect(find.byType(PreferencesNotificationPage), findsNothing);
    expect(find.byType(PreferencesSuccessPage), findsOneWidget);

    await tester.tap(find.text('conclude'));
    await tester.pumpAndSettle();
    expect(find.byType(PreferencesSuccessPage), findsNothing);
    expect(findRoute(SharedApplicationRoute.home), findsOneWidget);
  });

  testWidgets('erro mostra o widget de erro; retry recarrega e voltar fecha',
      (tester) async {
    harness.http.failAll();

    await pumpPage(
      tester,
      RouteLauncher(route: ApplicationRoute.preferencesNotification),
      routes: routes,
      observer: observer,
    );
    expect(find.byType(ErrorHandlingWidget), findsOneWidget);

    mockGet();
    await tester.tap(find.text('error_handling_widget_button_reTry').first);
    await tester.pumpAndSettle();
    expect(find.byType(ErrorHandlingWidget), findsNothing);
    expect(find.byType(PreferencesNotificationToggle), findsNWidgets(4));

    harness.http.on('PUT', notificationPath, status: 500, body: {'message': 'x'});
    await tester.ensureVisible(find.text('save'));
    await tester.tap(find.text('save'));
    await tester.pumpAndSettle();
    expect(controller().bloc.state, isA<PreferencesNotificationFailureState>());
    expect(find.byType(ErrorHandlingWidget), findsOneWidget);

    await tester.tap(find.text('back_to_the_previous_page'));
    await tester.pumpAndSettle();
    expect(find.byType(PreferencesNotificationPage), findsNothing);
    expect(findRoute(SharedApplicationRoute.home), findsOneWidget);
  });

  testWidgets('sem condomínio na sessão vai direto para o erro',
      (tester) async {
    harness.sessionBloc.currentState = SessionLoadedState(Session());

    await pumpPage(tester, const PreferencesNotificationPage());

    expect(harness.http.requests, isEmpty);
    expect(find.byType(ErrorHandlingWidget), findsOneWidget);
  });

  testWidgets('loading mostra o indicador', (tester) async {
    mockGet();
    await pumpPage(tester, const PreferencesNotificationPage());

    await emitState(tester, controller().bloc,
        const PreferencesNotificationLoadingState(),
        settle: false);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('PreferencesNotificationCheckBox mostra título e repassa o toque',
      (tester) async {
    var taps = 0;
    await pumpApp(
      tester,
      PreferencesNotificationCheckBox(
        onTap: () => taps++,
        checked: true,
        title: 'Boletos',
        style: const TextStyle(fontSize: 20),
      ),
    );

    expect(find.text('Boletos'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.check));
    expect(taps, 1);
  });
}
