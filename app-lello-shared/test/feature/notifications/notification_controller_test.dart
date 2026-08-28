import 'package:essentials/enum/app_origin_enum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/shared_features.dart';

import 'notifications_support.dart';

void main() {
  late NotificationsHarness harness;
  late List<dynamic> states;

  NotificationController build(
      {AppOriginEnum origin = AppOriginEnum.owner, dynamic sessionBloc}) {
    harness = NotificationsHarness(origin: origin, sessionBloc: sessionBloc);
    final controller = harness.buildController();
    states = [];
    controller.bloc.stream.listen(states.add);
    return controller;
  }

  Future<void> flush() => Future<void>.delayed(Duration.zero);

  group('getCurrentContext', () {
    test('devolve o contexto de cada app', () {
      expect(build().getCurrentContext, 'U1');
      expect(build(origin: AppOriginEnum.employee).getCurrentContext, 'C1');
      expect(build(origin: AppOriginEnum.manager).getCurrentContext, 'SC1');
    });

    test('sem sessão devolve nulo e engole exceções', () {
      expect(build(sessionBloc: FakeSessionBloc(withSession: false))
          .getCurrentContext, isNull);
      expect(build(sessionBloc: BrokenSessionBloc()).getCurrentContext, isNull);
    });
  });

  group('getNotificationList', () {
    test('carrega lista e resumo, ordena índices e remove duplicados',
        () async {
      final controller = build();
      harness.stubList(
        [notificationJson(id: 'a'), notificationJson(id: 'b'), notificationJson(id: 'a')],
        resume: resumeJson(totalIgnored: 2, totalReceived: 3),
      );

      await controller.getNotificationList();
      await flush();

      expect(states[0], isA<NotificationListLoadingState>());
      final page = states[1] as NotificationListPageState;
      expect(page.notificationsNotRead, 5);
      expect(page.notificationList.map((e) => e.id), ['a', 'b']);
      expect(page.notificationList.map((e) => e.index), [0, 1]);
      expect(page.notificationList.map((e) => e.page), [1, 1]);
      expect(controller.notifications, hasLength(2));
      expect(controller.page, 1);
      expect(harness.requestedPaths, containsAll([
        '/dashboard/U1/pendencies/pagination',
        '/dashboard/pendencies/resume',
      ]));
      expect(harness.http.requests.first.url.queryParameters,
          {'limit': '10', 'page': '1'});
    });

    test('sem contexto de sessão falha sem chamar a API', () async {
      final controller = build(sessionBloc: FakeSessionBloc(withSession: false));
      await controller.getNotificationList();
      await flush();

      expect(states.map((s) => s.runtimeType), [
        NotificationListLoadingState,
        NotificationListLoadedFailedState,
      ]);
      expect(harness.http.requests, isEmpty);
    });

    test('erro da listagem falha; erro do resumo mantém o contador', () async {
      final controller = build();
      harness.http.on('GET', harness.listPath, status: 500, body: {});
      harness.http.on('GET', '/dashboard/pendencies/resume', body: resumeJson());
      await controller.getNotificationList();
      await flush();
      expect(states.last, isA<NotificationListLoadedFailedState>());
      expect(controller.notificationsNotRead, 3);

      states.clear();
      harness.stubList([notificationJson()]);
      harness.http.on('GET', '/dashboard/pendencies/resume', status: 500);
      await controller.getNotificationList();
      await flush();
      expect(states.last, isA<NotificationListPageState>());
      expect(controller.notificationsNotRead, 3);
    });

    test('dados inválidos na lista falham com segurança', () async {
      final controller = build();
      harness.http.on('GET', harness.listPath, body: {
        'meta': {'totalItems': 1},
        'data': [
          {'id': 'x', 'date': 'não é data'}
        ],
      });
      harness.http.on('GET', '/dashboard/pendencies/resume', body: resumeJson());

      await controller.getNotificationList();
      await flush();
      expect(states.last, isA<NotificationListLoadedFailedState>());
    });

    test('ignora chamadas simultâneas', () async {
      final controller = build();
      harness.stubList([notificationJson()]);

      final first = controller.getNotificationList();
      final second = controller.getNotificationList();
      await Future.wait([first, second]);
      await flush();

      expect(harness.requestedPaths.where((p) => p == harness.listPath),
          hasLength(1));
    });
  });

  group('loadSingleNotification', () {
    test('fora do push marca lida e decrementa o contador', () async {
      final controller = build();
      harness.http.on('PUT', '/dashboard/pendencies/markRead', body: {});
      controller.notificationsNotRead = 2;

      await controller.loadSingleNotification(notificationId: 'n1');
      await flush();

      expect(controller.notificationsNotRead, 1);
      expect(states.single, isA<NotificationListPageState>());
      expect((states.single as NotificationListPageState).notificationsNotRead,
          1);
      expect(harness.requestedPaths, ['/dashboard/pendencies/markRead']);

      await controller.loadSingleNotification(notificationId: 'n1');
      await flush();
      await controller.loadSingleNotification(notificationId: 'n1');
      await flush();
      expect(controller.notificationsNotRead, 0);
    });

    test('do push passa por loading e reflete o resultado', () async {
      final controller = build();
      harness.http.on('PUT', '/dashboard/pendencies/markRead', body: {});
      await controller.loadSingleNotification(
          fromPush: true, notificationId: 'n1');
      await flush();
      expect(states.map((s) => s.runtimeType), [
        NotificationListLoadingState,
        NotificationListPageState,
      ]);

      states.clear();
      harness.http.failAll();
      await controller.loadSingleNotification(
          fromPush: true, notificationId: 'n1');
      await flush();
      expect(states.last, isA<NotificationListLoadedFailedState>());
    });

    test('sem sessão falha', () async {
      final controller = build(sessionBloc: FakeSessionBloc(withSession: false));
      await controller.loadSingleNotification(notificationId: 'n1');
      await flush();
      expect(states.single, isA<NotificationListLoadedFailedState>());
    });
  });

  group('loadPagination', () {
    test('avança a página e acrescenta itens', () async {
      final controller = build(origin: AppOriginEnum.manager);
      controller.notifications = [buildNotification(id: 'a')];
      harness.http.on('GET', harness.listPath,
          body: paginatorJson([notificationJson(id: 'b'), notificationJson(id: 'a')]));

      await controller.loadPagination();
      await flush();

      expect(controller.page, 2);
      expect(harness.http.requests.single.url.queryParameters['page'], '2');
      expect(harness.http.requests.single.url.path,
          '/dashboard/SC1/pendencies/pagination');
      final loading = states[0] as NotificationListPageState;
      expect(loading.loading, isTrue);
      final page = states[1] as NotificationListPageState;
      expect(page.loading, isFalse);
      expect(page.notificationList.map((e) => e.id), ['a', 'b']);
      expect(page.notificationList.last.page, 2);
    });

    test('lista vazia não avança a página', () async {
      final controller = build();
      harness.http.on('GET', harness.listPath, body: paginatorJson([]));
      await controller.loadPagination();
      await flush();
      expect(controller.page, 1);
      expect(harness.http.requests.single.url.queryParameters['page'], '1');
    });

    test('erro restaura a página e sinaliza pagError', () async {
      final controller = build();
      controller.notifications = [buildNotification(id: 'a')];
      harness.http.failAll();

      await controller.loadPagination();
      await flush();

      expect(controller.page, 1);
      final page = states.last as NotificationListPageState;
      expect(page.pagError, isTrue);
      expect(page.loading, isFalse);
    });

    test('dados inválidos falham e sem sessão falha', () async {
      final controller = build();
      harness.http.on('GET', harness.listPath, body: {
        'meta': {},
        'data': [
          {'id': 1}
        ],
      });
      await controller.loadPagination();
      await flush();
      expect(states.last, isA<NotificationListLoadedFailedState>());

      final semSessao = build(sessionBloc: FakeSessionBloc(withSession: false));
      await semSessao.loadPagination();
      await flush();
      expect(states.last, isA<NotificationListLoadedFailedState>());
    });
  });

  group('markAllRead', () {
    test('marca todas como lidas e zera o contador', () async {
      final controller = build(origin: AppOriginEnum.employee);
      controller.notifications = [
        buildNotification(id: 'a'),
        buildNotification(id: 'b'),
      ];
      controller.notificationsNotRead = 2;
      harness.http.on('PUT', '/dashboard/pendencies/markAllRead', body: {});

      await controller.markAllRead();
      await flush();

      expect(states.first, isA<NotificationListLoadingState>());
      final page = states.last as NotificationListPageState;
      expect(page.notificationsNotRead, 0);
      expect(page.notificationList.every((n) => n.markRead == true), isTrue);
      expect(harness.requestedPaths, ['/dashboard/pendencies/markAllRead']);
    });

    test('erro e sem sessão falham', () async {
      final controller = build();
      harness.http.failAll();
      await controller.markAllRead();
      await flush();
      expect(states.last, isA<NotificationListLoadedFailedState>());

      final semSessao = build(sessionBloc: FakeSessionBloc(withSession: false));
      await semSessao.markAllRead();
      await flush();
      expect(states.last, isA<NotificationListLoadedFailedState>());
      expect(harness.http.requests, isEmpty);
    });
  });

  group('deleteAllRead', () {
    test('read=true remove só as lidas; read=false limpa tudo', () async {
      final controller = build();
      harness.http.on('DELETE', '/dashboard/pendencies/deleteAllRead', body: {});
      controller.notifications = [
        buildNotification(id: 'a', markRead: true),
        buildNotification(id: 'b', markRead: false),
      ];
      controller.notificationsNotRead = 1;

      await controller.deleteAllRead(read: true);
      await flush();
      var page = states.last as NotificationListPageState;
      expect(page.notificationList.map((e) => e.id), ['b']);
      expect(page.notificationsNotRead, 1);
      expect(harness.http.requests.single.url.queryParameters['read'], 'true');

      await controller.deleteAllRead(read: false);
      await flush();
      page = states.last as NotificationListPageState;
      expect(page.notificationList, isEmpty);
      expect(page.notificationsNotRead, 0);
      expect(controller.notifications, isEmpty);
    });

    test('erro e sem sessão falham', () async {
      final controller = build();
      harness.http.failAll();
      await controller.deleteAllRead(read: true);
      await flush();
      expect(states.last, isA<NotificationListLoadedFailedState>());

      final semSessao = build(sessionBloc: FakeSessionBloc(withSession: false));
      await semSessao.deleteAllRead(read: true);
      await flush();
      expect(states.last, isA<NotificationListLoadedFailedState>());
    });
  });

  group('deleteNotification', () {
    test('remove a notificação da lista', () async {
      final controller = build();
      harness.http.on('DELETE', '/dashboard/pendencies/delete', body: {});
      controller.notifications = [
        buildNotification(id: 'a'),
        buildNotification(id: 'b'),
      ];

      await controller.deleteNotification(notificationId: 'a');
      await flush();

      final page = states.last as NotificationListPageState;
      expect(page.notificationList.map((e) => e.id), ['b']);
      expect(harness.http.requests.single.url.queryParameters['notificationId'],
          'a');
    });

    test('erro e sem sessão falham', () async {
      final controller = build();
      harness.http.failAll();
      await controller.deleteNotification(notificationId: 'a');
      await flush();
      expect(states.last, isA<NotificationListLoadedFailedState>());

      final semSessao = build(sessionBloc: FakeSessionBloc(withSession: false));
      await semSessao.deleteNotification(notificationId: 'a');
      await flush();
      expect(states.last, isA<NotificationListLoadedFailedState>());
    });
  });

  test('setState, redirect id e uuid de grupo', () async {
    final controller = build();
    await controller.setState(NotificationListLoadedFailedState());
    expect(controller.bloc.state, isA<NotificationListLoadedFailedState>());

    controller.setRedirectNotificationId('r1');
    expect(controller.redirectNotificationId, 'r1');
    controller.setUuidGroup('g1');
    expect(controller.redirectUuidGroup, 'g1');
    controller.setRedirectNotification('r2', 'g2');
    expect(controller.redirectNotificationId, 'r2');
    expect(controller.redirectUuidGroup, 'g2');
    controller.setRedirectNotification(null, 'g3');
    expect(controller.redirectNotificationId, isNull);
  });
}
