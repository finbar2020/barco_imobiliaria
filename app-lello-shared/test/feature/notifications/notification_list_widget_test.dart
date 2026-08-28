import 'package:essentials/enum/app_origin_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/notifications/presentation/widgets/notification_details_widget.dart';
import 'package:shared_features/feature/notifications/presentation/widgets/notification_list_tile.dart';
import 'package:shared_features/feature/notifications/presentation/widgets/notification_list_widget.dart';
import 'package:shared_features/shared_features.dart';

import '../../helpers/pump_app.dart';
import 'notifications_support.dart';

void main() {
  late NotificationsHarness harness;
  late NotificationController controller;
  late List<SingleNotification> tapped;
  late int closed;
  late int configTaps;
  late RecordingNavigatorObserver observer;

  setUpAll(initDates);

  setUp(() {
    tapped = [];
    closed = 0;
    configTaps = 0;
    observer = RecordingNavigatorObserver();
    harness = NotificationsHarness();
    harness.http.on('PUT', '/dashboard/pendencies/markRead', body: {});
    harness.http.on('PUT', '/dashboard/pendencies/markAllRead', body: {});
    harness.http.on('DELETE', '/dashboard/pendencies/deleteAllRead', body: {});
    harness.http.on('DELETE', '/dashboard/pendencies/delete', body: {});
  });

  Future<void> pumpList(
    WidgetTester tester,
    List<SingleNotification> list, {
    AppOriginEnum origin = AppOriginEnum.owner,
    String? configurationPage,
    bool withConfigTap = false,
    NotificationScopeLabelBuilder? scopeLabelBuilder,
    Size surface = const Size(400, 800),
    bool settle = true,
    dynamic sessionBloc,
    NotificationController? reuse,
    Map<String, String> locOverrides = const {},
  }) async {
    // Remonta do zero: o Navigator do MaterialApp anterior guardaria as rotas
    // (e a página já construída) se a árvore fosse só atualizada.
    await tester.pumpWidget(const SizedBox());
    controller = reuse ?? harness.buildController();
    controller.notifications = list;
    // ignore: invalid_use_of_visible_for_testing_member
    controller.bloc.emit(NotificationListPageState(
        notificationsNotRead: list.where((n) => n.markRead == false).length,
        notificationList: list));
    await pumpPage(
      tester,
      NotificationListWidget(
        closeOverlay: () => closed++,
        controller: controller,
        sessionBloc: sessionBloc ?? harness.sessionBloc,
        onTap: tapped.add,
        notificationList: list,
        appOriginEnum: origin,
        applicationContainer: harness.container,
        configurationPage: configurationPage,
        onConfigurationTap: withConfigTap ? () => configTaps++ : null,
        scopeLabelBuilder: scopeLabelBuilder,
      ),
      observer: observer,
      providers: withNotificationAssets,
      surface: surface,
      settle: settle,
      locOverrides: locOverrides,
    );
  }

  Future<void> openMenu(WidgetTester tester) async {
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
  }

  group('lista', () {
    testWidgets('agrupa por período e mostra a barra do condomínio',
        (tester) async {
      final now = DateTime.now();
      await pumpList(tester, [
        buildNotification(id: 'a', title: 'Hoje', date: now),
        buildNotification(
            id: 'b', title: 'Antiga', date: DateTime(2025, 3, 7), markRead: true),
        buildNotification(id: 'c', title: 'Sem data')..date = null,
      ], scopeLabelBuilder: (n) => n.id == 'a' ? 'Unidade 101' : null);

      expect(find.text('Esta semana'), findsOneWidget);
      expect(find.text('Março de 2025'), findsOneWidget);
      expect(find.text('Hoje'), findsOneWidget);
      expect(find.text('Antiga'), findsOneWidget);
      // Sem data não entra em grupo nenhum.
      expect(find.text('Sem data'), findsNothing);
      expect(find.text('Unidade 101'), findsOneWidget);
      expect(find.text('Não lida'), findsOneWidget);
      expect(find.text('Condomínio Teste - R1'), findsOneWidget);
      expect(find.text('notification'), findsOneWidget);

      await expectLater(
        find.byType(NotificationListWidget),
        matchesGoldenFile('goldens/notification_list_widget.png'),
      );
    });

    testWidgets('barra do condomínio: só referência, só nome ou nada',
        (tester) async {
      await pumpList(tester, [buildNotification()],
          sessionBloc: FakeSessionBloc(
              session: FakeSession(
                  condominium: FakeCondominium(withLayout: false))));
      expect(find.text('R1'), findsOneWidget);

      await pumpList(tester, [buildNotification()],
          sessionBloc: FakeSessionBloc(
              session: FakeSession(
                  condominium: FakeCondominium(reference: null))));
      expect(find.text('Condomínio Teste'), findsOneWidget);

      await pumpList(tester, [buildNotification()],
          sessionBloc: FakeSessionBloc(withSession: false));
      expect(find.textContaining('Condomínio'), findsNothing);

      await pumpList(tester, [buildNotification()],
          sessionBloc: BrokenSessionBloc());
      expect(find.textContaining('Condomínio'), findsNothing);
    });

    testWidgets('lista vazia mostra aviso e puxar recarrega', (tester) async {
      harness.stubList([]);
      await pumpList(tester, []);
      expect(find.text('dont_have_notifications'), findsOneWidget);

      await tester.fling(
          find.text('dont_have_notifications'), const Offset(0, 300), 1000);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      expect(harness.requestedPaths, contains(harness.listPath));
    });

    testWidgets('puxar a lista recarrega', (tester) async {
      /// Corrigido: a `ListView.builder` usa `AlwaysScrollableScrollPhysics`,
      /// então o gesto de puxar dispara o `RefreshIndicator` mesmo com poucos
      /// itens (lista menor que a tela).
      harness.stubList([notificationJson()]);
      await pumpList(tester, [buildNotification(date: DateTime.now())],
          surface: const Size(400, 600));

      await tester.fling(
          find.byType(NotificationListTile).first, const Offset(0, 300), 1000);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      expect(harness.requestedPaths, contains(harness.listPath));
    });

    testWidgets('mostra loading e erro de paginação com "tentar novamente"',
        (tester) async {
      await pumpList(tester, [buildNotification()]);
      await emitState(
          tester,
          controller.bloc,
          NotificationListPageState(
              notificationsNotRead: 1,
              notificationList: [buildNotification()],
              loading: true),
          settle: false);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      harness.http.on('GET', harness.listPath,
          body: paginatorJson([notificationJson(id: 'p2')]));
      await emitState(
          tester,
          controller.bloc,
          NotificationListPageState(
              notificationsNotRead: 1,
              notificationList: [buildNotification()],
              pagError: true));
      expect(find.text('try_again'), findsOneWidget);

      await tester.tap(find.text('try_again'));
      await tester.pumpAndSettle();
      expect(harness.requestedPaths, contains(harness.listPath));
      expect(harness.http.requests.last.url.queryParameters['page'], '2');
    });

    testWidgets('rolar até o fim carrega a próxima página', (tester) async {
      final many = List.generate(
          15,
          (i) => buildNotification(
              id: 'n$i', title: 'Item $i', date: DateTime.now()));
      harness.http.on('GET', harness.listPath,
          body: paginatorJson([notificationJson(id: 'novo')]));
      await pumpList(tester, many, surface: const Size(400, 600));

      final listView = tester.widget<ListView>(find.byType(ListView));
      final position = listView.controller!.position;
      listView.controller!.jumpTo(position.maxScrollExtent);
      await tester.pumpAndSettle();

      expect(harness.http.requests.last.url.queryParameters['page'], '2');
      expect(controller.notifications.map((e) => e.id), contains('novo'));

      // Com loading/pagError em curso o scroll não dispara outra página.
      final before = harness.http.requests.length;
      await emitState(
          tester,
          controller.bloc,
          NotificationListPageState(
              notificationsNotRead: 1,
              notificationList: many,
              loading: true),
          settle: false);
      listView.controller!.jumpTo(0);
      await tester.pump();
      listView.controller!.jumpTo(position.maxScrollExtent);
      await tester.pump();
      await tester.pump();
      expect(harness.http.requests.length, before);
    });
  });

  group('menu de configurações', () {
    testWidgets('Preferências: callback, rota nomeada ou Flushbar',
        (tester) async {
      await pumpList(tester, [buildNotification()], withConfigTap: true);
      await openMenu(tester);
      expect(find.text('Preferências'), findsOneWidget);
      expect(find.text('notification_first_drop_down'), findsOneWidget);
      expect(find.text('notification_second_drop_down'), findsOneWidget);
      await tester.tap(find.text('Preferências'));
      await tester.pumpAndSettle();
      expect(configTaps, 1);

      await pumpList(tester, [buildNotification()],
          configurationPage: '/config');
      await openMenu(tester);
      await tester.tap(find.text('Preferências'));
      await tester.pumpAndSettle();
      expect(findRoute('/config'), findsOneWidget);

      await pumpList(tester, [buildNotification()]);
      await openMenu(tester);
      await tester.tap(find.text('Preferências'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('notification_coming'), findsOneWidget);
      await tester.pump(const Duration(seconds: 6));
      await tester.pumpAndSettle();
    });

    testWidgets('Marcar todas como lidas chama a API só se houver não lidas',
        (tester) async {
      await pumpList(tester, [buildNotification(markRead: false)]);
      await openMenu(tester);
      await tester.tap(find.text('notification_first_drop_down'));
      await tester.pumpAndSettle();
      expect(harness.requestedPaths, ['/dashboard/pendencies/markAllRead']);

      await pumpList(tester, [buildNotification(markRead: true)]);
      await openMenu(tester);
      await tester.tap(find.text('notification_first_drop_down'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Todas as notificações já foram lidas.'), findsOneWidget);
      await tester.pump(const Duration(seconds: 6));
      await tester.pumpAndSettle();
    });

    testWidgets('Excluir abre o diálogo com as três ações', (tester) async {
      const loc = {
        'notification_dialog_first_button': 'Excluir todas',
        'notification_dialog_second_button': 'Excluir lidas',
      };
      await pumpList(tester, [buildNotification()], locOverrides: loc);
      await openMenu(tester);
      await tester.tap(find.text('notification_second_drop_down'));
      await tester.pumpAndSettle();

      expect(find.text('attention'), findsOneWidget);
      expect(find.text('notification_dialog_subtitle'), findsOneWidget);
      await expectLater(
        find.byType(Dialog),
        matchesGoldenFile('goldens/notification_delete_dialog.png'),
      );

      await tester.tap(find.text('CANCEL'));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsNothing);
      expect(harness.http.requests, isEmpty);

      await openMenu(tester);
      await tester.tap(find.text('notification_second_drop_down'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Excluir todas'));
      await tester.pumpAndSettle();
      expect(harness.http.requests.last.url.queryParameters['read'], 'false');

      await openMenu(tester);
      await tester.tap(find.text('notification_second_drop_down'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Excluir lidas'));
      await tester.pumpAndSettle();
      expect(harness.http.requests.last.url.queryParameters['read'], 'true');
    });
  });

  group('redirecionamento vindo do push', () {
    testWidgets('abre o detalhe pelo senderId e limpa o redirect',
        (tester) async {
      final list = [
        buildNotification(id: 'a', senderId: 's1', title: 'Alvo'),
        buildNotification(id: 'b', senderId: 's2'),
      ];
      final c = harness.buildController()..setRedirectNotificationId('s1');
      await pumpList(tester, list, reuse: c);

      expect(find.byType(NotificationDetailsWidget), findsOneWidget);
      expect(observer.pushedNames, contains('/notification-details-from-push'));
      expect(controller.redirectNotificationId, isNull);
      expect(harness.requestedPaths, contains('/dashboard/pendencies/markRead'));
    });

    testWidgets('abre pelo uuid do grupo preferindo o contexto atual',
        (tester) async {
      final list = [
        buildNotification(id: 'a', uuidGroup: 'g1', reference: 'OUTRA', title: 'Outra'),
        buildNotification(id: 'b', uuidGroup: 'g1', reference: 'U1', title: 'Minha'),
      ];
      final c = harness.buildController()..setUuidGroup('g1');
      await pumpList(tester, list, reuse: c);

      expect(find.byType(NotificationDetailsWidget), findsOneWidget);
      expect(find.text('Minha'), findsOneWidget);
      expect(controller.redirectUuidGroup, isNull);
    });

    testWidgets('sem match no contexto pega a primeira do grupo; sem grupo não abre',
        (tester) async {
      final list = [
        buildNotification(id: 'a', uuidGroup: 'g1', reference: 'OUTRA', title: 'Outra'),
      ];
      final c = harness.buildController()..setUuidGroup('g1');
      await pumpList(tester, list, reuse: c);
      expect(find.byType(NotificationDetailsWidget), findsOneWidget);
      expect(find.text('Outra'), findsOneWidget);

      final c2 = harness.buildController()..setUuidGroup('nao-existe');
      await pumpList(tester, list, reuse: c2);
      expect(find.byType(NotificationDetailsWidget), findsNothing);
    });
  });

  group('NotificationListTile', () {
    testWidgets('tocar marca como lida, chama a API e abre o detalhe',
        (tester) async {
      await pumpList(tester, [buildNotification(id: 'a', markRead: false)]);
      expect(find.text('Não lida'), findsOneWidget);

      await tester.tap(find.byType(NotificationListTile));
      await tester.pumpAndSettle();

      expect(harness.requestedPaths, ['/dashboard/pendencies/markRead']);
      expect(observer.pushedNames, contains('/notification-details-from-list'));
      expect(find.byType(NotificationDetailsWidget), findsOneWidget);

      // Voltar: a notificação agora está lida.
      await tester.tap(find.text('back'));
      await tester.pumpAndSettle();
      expect(find.text('Não lida'), findsNothing);
      expect(closed, 0);
    });

    testWidgets('lida não chama a API', (tester) async {
      await pumpList(tester, [buildNotification(id: 'a', markRead: true)]);
      await tester.tap(find.byType(NotificationListTile));
      await tester.pumpAndSettle();
      expect(harness.http.requests, isEmpty);
      expect(find.byType(NotificationDetailsWidget), findsOneWidget);
    });

    testWidgets('fromHomeManager fecha o overlay e chama onTap', (tester) async {
      final notification = buildNotification(id: 'a', markRead: true);
      await pumpApp(
        tester,
        withNotificationAssets(NotificationListTile(
          notification: notification,
          controller: harness.buildController(),
          closeOverlay: () => closed++,
          onTap: tapped.add,
          applicationContainer: harness.container,
          fromHomeManager: true,
          scopeLabelBuilder: (_) => 'Bloco A',
        )),
      );
      expect(find.text('Bloco A'), findsOneWidget);
      await tester.tap(find.byType(NotificationListTile));
      await tester.pump();
      expect(closed, 1);
      expect(tapped.single, same(notification));

      await expectLater(
        findGoldenSurface(),
        matchesGoldenFile('goldens/notification_list_tile.png'),
      );
    });
  });
}
