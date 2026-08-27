import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/core/custom_cached_network_image/custom_cached_network_image.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';
import 'package:shared_features/feature/notifications/presentation/widgets/notification_details_widget.dart';
import 'package:shared_features/feature/notifications/presentation/widgets/notification_list_tile.dart';
import 'package:shared_features/shared_features.dart';

import '../../helpers/fake_url_launcher.dart';
import '../../helpers/firebase_mocks.dart';
import '../../helpers/pump_app.dart';
import 'notifications_support.dart';

void main() {
  late NotificationsHarness harness;
  late NotificationController controller;
  late List<SingleNotification> tapped;
  late int configTaps;
  late RecordingNavigatorObserver observer;
  late FakeUrlLauncherPlatform launcher;

  setUpAll(() async {
    await initDates();
    await setUpFakeFirebase();
  });

  setUp(() {
    tapped = [];
    configTaps = 0;
    observer = RecordingNavigatorObserver();
    launcher = installFakeUrlLauncher();
    fakeAnalytics.reset();
    harness = NotificationsHarness();
    harness.http.on('PUT', '/dashboard/pendencies/markRead', body: {});
    harness.http.on('DELETE', '/dashboard/pendencies/delete', body: {});
  });

  Future<void> pumpDetails(
    WidgetTester tester, {
    SingleNotification? notification,
    String? listNotificationContext,
    bool fromPush = false,
    AppOriginEnum? origin = AppOriginEnum.owner,
    String? configurationPage,
    bool withConfigTap = false,
    NotificationScopeLabelBuilder? scopeLabelBuilder,
    List<SingleNotification> list = const [],
    bool settle = true,
    Size surface = const Size(400, 800),
  }) async {
    // Remonta do zero (o Navigator anterior guardaria a página construída).
    await tester.pumpWidget(const SizedBox());
    controller = harness.buildController();
    controller.notifications = List.of(list);
    // ignore: invalid_use_of_visible_for_testing_member
    controller.bloc.emit(NotificationListPageState(
        notificationsNotRead: 1, notificationList: controller.notifications));
    await pumpPage(
      tester,
      NotificationDetailsWidget(
        notification: notification,
        controller: controller,
        listNotificationContext: listNotificationContext,
        fromPush: fromPush,
        onTap: tapped.add,
        appOriginEnum: origin,
        configurationPage: configurationPage,
        onConfigurationTap: withConfigTap ? () => configTaps++ : null,
        applicationContainer: harness.container,
        scopeLabelBuilder: scopeLabelBuilder,
      ),
      observer: observer,
      providers: withNotificationAssets,
      settle: settle,
      surface: surface,
    );
  }

  Future<void> openMenu(WidgetTester tester) async {
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
  }

  testWidgets('mostra módulo, título, data, mensagem e botão de feature',
      (tester) async {
    final notification = buildNotification(
        title: 'Boleto disponível',
        message: 'Seu boleto chegou',
        date: DateTime(2025, 3, 7, 8, 1));
    await pumpDetails(tester,
        notification: notification, scopeLabelBuilder: (_) => 'Unidade 101');

    expect(find.text('income_control_billets'), findsOneWidget);
    expect(find.text('Boleto disponível'), findsOneWidget);
    expect(find.text('7 de março de 2025, às 08:01'), findsOneWidget);
    expect(find.text('Seu boleto chegou'), findsOneWidget);
    expect(find.text('Unidade 101'), findsOneWidget);
    expect(find.text('notification_button_redirect'), findsOneWidget);
    expect(find.text('back'), findsOneWidget);
    expect(notification.markRead, isTrue);

    await expectLater(
      find.byType(NotificationDetailsWidget),
      matchesGoldenFile('goldens/notification_details_widget.png'),
    );

    await tester.tap(find.text('notification_button_redirect'));
    await tester.pumpAndSettle();
    expect(tapped.single, same(notification));
    expect(fakeAnalytics.eventNames, isNotEmpty);
    expect(fakeAnalytics.events.values.first!['referencia'], 'R1');
    expect(fakeAnalytics.events.values.first!['unidade'], '101');
    expect(fakeAnalytics.events.values.first!['id_partner'], 'b1');

    await tester.tap(find.text('back'));
    await tester.pumpAndSettle();
    expect(observer.popped, isNotEmpty);
  });

  testWidgets('sem notificação usa o contexto da lista e carrega pelo id',
      (tester) async {
    await pumpDetails(tester,
        notification: null, listNotificationContext: 'n1', fromPush: true);
    expect(harness.requestedPaths, ['/dashboard/pendencies/markRead']);
    expect(find.text('notification_module_others'), findsOneWidget);
    expect(find.text('null'), findsOneWidget);
  });

  testWidgets('sem notificação e sem contexto da lista quebra na montagem',
      (tester) async {
    /// Defeito: o `initState` faz `widget.notification!` quando não há
    /// notificação nem `listNotificationContext`, em vez de tratar o caso.
    await pumpDetails(tester, notification: null, settle: false);
    expect(tester.takeException(), isA<TypeError>());
  });

  testWidgets('estados de loading e erro', (tester) async {
    await pumpDetails(tester, notification: buildNotification(), settle: false);
    await emitState(tester, controller.bloc, NotificationListLoadingState(),
        settle: false);
    expect(find.byType(LoadingWidget), findsOneWidget);

    await emitState(
        tester, controller.bloc, NotificationListLoadedFailedState(),
        settle: false);
    expect(find.text('warning_failed_message'), findsOneWidget);

    await emitState(tester, controller.bloc, NotificationListEmptyState(),
        settle: false);
    expect(find.text('warning_failed_message'), findsNothing);
    expect(find.text('back'), findsNothing);
  });

  testWidgets('mensagem HTML e imagem por hash', (tester) async {
    await pumpDetails(tester,
        notification: buildNotification(
            bigMessage: '<p>Olá <b>mundo</b></p>', hash: 'abc'));
    expect(find.byType(HtmlWidget), findsOneWidget);
    expect(find.byType(CustomCachedNetworkImage), findsOneWidget);
    expect(find.textContaining('mundo', findRichText: true), findsWidgets);
  });

  group('botão de redirecionamento', () {
    testWidgets('rotas que não redirecionam não mostram botão', (tester) async {
      for (final path in ['NOTIFICACOES_NAO_LIDAS', 'PORTARIA_BLOQUEADA', 'PORTARIA_LIBERADA']) {
        await pumpDetails(tester,
            notification: buildNotification(redirectPath: path));
        expect(find.text('notification_button_redirect'), findsNothing);
      }
      // Rota desconhecida sem tipo externo: nada.
      await pumpDetails(tester,
          notification: buildNotification(
              redirectPath: 'DESCONHECIDA', typeRedirect: 'FEATURE'));
      expect(find.text('notification_button_redirect'), findsNothing);
      // Feature sem referência não pode redirecionar.
      await pumpDetails(tester,
          notification: buildNotification(reference: null));
      expect(find.text('notification_button_redirect'), findsNothing);
      // Tipo desconhecido.
      await pumpDetails(tester,
          notification: buildNotification(typeRedirect: 'OUTRO'));
      expect(find.text('notification_button_redirect'), findsNothing);
      // Sem caminho e sem tipo externo.
      await pumpDetails(tester,
          notification: buildNotification(redirectPath: null));
      expect(find.text('notification_button_redirect'), findsNothing);
    });

    testWidgets('link externo abre com https e registra analytics por app',
        (tester) async {
      await pumpDetails(tester,
          notification: buildNotification(
              redirectPath: 'lello.com.br/ajuda', typeRedirect: 'EXTERNAL'),
          origin: AppOriginEnum.employee);
      await tester.tap(find.text('notification_button_redirect'));
      await tester.pumpAndSettle();
      expect(launcher.launched, ['https://lello.com.br/ajuda']);
      expect(fakeAnalytics.events.values.first!['referencia'], 'R1');
      expect(fakeAnalytics.events.values.first!.containsKey('unidade'), isFalse);

      fakeAnalytics.reset();
      await pumpDetails(tester,
          notification: buildNotification(
              redirectPath: 'http://lello.com.br', typeRedirect: 'EXTERNAL'),
          origin: AppOriginEnum.manager);
      await tester.tap(find.text('notification_button_redirect'));
      await tester.pumpAndSettle();
      expect(launcher.launched.last, 'http://lello.com.br');
      expect(fakeAnalytics.events.values.first!['referencia'], 'SR1');
    });

    testWidgets('URL inválida mostra o Flushbar de erro', (tester) async {
      await pumpDetails(tester,
          notification: buildNotification(
              redirectPath: 'https://[invalida', typeRedirect: 'EXTERNAL'));
      await tester.tap(find.text('notification_button_redirect'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('notification_error_redirect_external'), findsOneWidget);
      expect(launcher.launched, isEmpty);
      await tester.pump(const Duration(seconds: 6));
      await tester.pumpAndSettle();
    });

    testWidgets('sem appOriginEnum não registra analytics', (tester) async {
      await pumpDetails(tester,
          notification: buildNotification(), origin: null);
      await tester.tap(find.text('notification_button_redirect'));
      await tester.pumpAndSettle();
      expect(tapped, hasLength(1));
      expect(fakeAnalytics.eventNames, isEmpty);
    });
  });

  group('menu', () {
    testWidgets('excluir chama a API e volta', (tester) async {
      await pumpDetails(tester,
          notification: buildNotification(id: 'n1'),
          list: [buildNotification(id: 'n1')]);
      await openMenu(tester);
      expect(find.text('exclude'), findsOneWidget);
      expect(find.text('notification_third_drop_down'), findsOneWidget);
      await tester.tap(find.text('exclude'));
      await tester.pumpAndSettle();

      expect(harness.http.requests.last.url.path, '/dashboard/pendencies/delete');
      expect(harness.http.requests.last.url.queryParameters['notificationId'],
          'n1');
      expect(observer.popped, isNotEmpty);
    });

    testWidgets('preferências: callback, rota ou Flushbar', (tester) async {
      await pumpDetails(tester,
          notification: buildNotification(), withConfigTap: true);
      await openMenu(tester);
      await tester.tap(find.text('notification_third_drop_down'));
      await tester.pumpAndSettle();
      expect(configTaps, 1);

      await pumpDetails(tester,
          notification: buildNotification(), configurationPage: '/prefs');
      await openMenu(tester);
      await tester.tap(find.text('notification_third_drop_down'));
      await tester.pumpAndSettle();
      expect(findRoute('/prefs'), findsOneWidget);

      await pumpDetails(tester, notification: buildNotification());
      await openMenu(tester);
      await tester.tap(find.text('notification_third_drop_down'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('notification_coming'), findsOneWidget);
      await tester.pump(const Duration(seconds: 6));
      await tester.pumpAndSettle();
    });
  });
}
