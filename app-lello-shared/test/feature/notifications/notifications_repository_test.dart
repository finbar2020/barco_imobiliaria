import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:essentials/paginator/paginator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/shared_features.dart';

import 'notifications_support.dart';

void main() {
  late NotificationsHarness harness;

  setUp(() {
    harness = NotificationsHarness();
  });

  group('NotificationsRemoteDataSourceImpl', () {
    test('loadNotificationsList monta a URL com referência, limit e page',
        () async {
      harness.http.on('GET', '/dashboard/U1/pendencies/pagination',
          body: paginatorJson([notificationJson()], totalItems: 30));

      final result = await harness.dataSource.loadNotificationsList('U1', 10, 2);

      expect(result.meta!.totalItems, 30);
      expect(result.data, hasLength(1));
      final request = harness.http.requests.single;
      expect(request.url.queryParameters, {'limit': '10', 'page': '2'});
    });

    test('loadNotificationsList lança o erro da API', () async {
      harness.http.failAll();
      expect(() => harness.dataSource.loadNotificationsList('U1', 10, 1),
          throwsA(anything));
    });

    test('readNotification faz PUT com notificationId e lança a resposta em erro',
        () async {
      harness.http.on('PUT', '/dashboard/pendencies/markRead', body: {});
      expect(await harness.dataSource.readNotification('n1'), isTrue);
      final request = harness.http.requests.single;
      expect(request.method, 'PUT');
      expect(request.url.queryParameters['notificationId'], 'n1');

      harness.http.failAll(status: 404);
      expect(() => harness.dataSource.readNotification('n1'),
          throwsA(isA<Response>()));
    });

    test('markAllReadNotification, deleteAllReadNotification e deleteNotification',
        () async {
      harness.http.on('PUT', '/dashboard/pendencies/markAllRead', body: {});
      harness.http.on('DELETE', '/dashboard/pendencies/deleteAllRead', body: {});
      harness.http.on('DELETE', '/dashboard/pendencies/delete', body: {});

      expect(await harness.dataSource.markAllReadNotification(), isTrue);
      expect(await harness.dataSource.deleteAllReadNotification(true), isTrue);
      expect(await harness.dataSource.deleteNotification('n2'), isTrue);

      expect(harness.http.requests[1].url.queryParameters['read'], 'true');
      expect(harness.http.requests[2].url.queryParameters['notificationId'],
          'n2');
      expect(harness.http.requests[2].method, 'DELETE');

      harness.http.failAll();
      expect(() => harness.dataSource.markAllReadNotification(),
          throwsA(anything));
      expect(() => harness.dataSource.deleteAllReadNotification(false),
          throwsA(anything));
      expect(() => harness.dataSource.deleteNotification('n2'),
          throwsA(anything));
    });

    test('getNotificationResume e sendPushCallback', () async {
      harness.http.on('GET', '/dashboard/pendencies/resume', body: resumeJson());
      harness.http.on('POST', '/dashboard/pendencies/sendCallback', body: {});

      final resume = await harness.dataSource.getNotificationResume();
      expect(resume.totalReceived, 2);

      expect(
          await harness.dataSource
              .sendPushCallback('n1', NotificationCallbackType.CLICOU),
          isTrue);
      final callback = harness.http.requests.last;
      expect(callback.method, 'POST');
      expect(callback.url.queryParameters,
          {'notificationId': 'n1', 'type': 'CLICOU'});

      harness.http.failAll();
      expect(() => harness.dataSource.getNotificationResume(),
          throwsA(anything));
      expect(
          () => harness.dataSource
              .sendPushCallback('n1', NotificationCallbackType.RECEBEU),
          throwsA(isA<Response>()));
    });
  });

  group('NotificationsRepositoryImpl', () {
    test('sucesso em todas as operações', () async {
      harness.http.on('GET', '/dashboard/U1/pendencies/pagination',
          body: paginatorJson([notificationJson(), notificationJson(id: 'n2')]));
      harness.http.on('PUT', '/dashboard/pendencies/markRead', body: {});
      harness.http.on('PUT', '/dashboard/pendencies/markAllRead', body: {});
      harness.http.on('DELETE', '/dashboard/pendencies/deleteAllRead', body: {});
      harness.http.on('DELETE', '/dashboard/pendencies/delete', body: {});
      harness.http.on('GET', '/dashboard/pendencies/resume', body: resumeJson());
      harness.http.on('POST', '/dashboard/pendencies/sendCallback', body: {});
      final repo = harness.repository;

      final list = await repo.loadNotifications('U1', 10, 1);
      expect(list, isA<Success<Paginator>>());
      expect((list as Success<Paginator>).get().data, hasLength(2));

      expect(await repo.updateSingleNotification('n1'), Success(true));
      expect(await repo.markAllReadNotification(), Success(true));
      expect(await repo.deleteAllReadNotification(true), Success(true));
      expect(await repo.deleteNotification('n1'), Success(true));
      expect(await repo.sendPushCallback('n1', NotificationCallbackType.IGNOROU),
          Success(true));

      final resume = await repo.getNotificationResume();
      expect((resume as Success<NotificationResumeEntity>).get().totalIgnored, 1);

      expect(await repo.clear(), isA<Success<Nothing>>());
    });

    test('falhas viram Rejection(UnknownFailure)', () async {
      harness.http.failAll();
      final repo = harness.repository;

      Future<void> expectRejection(Future<Try> future) async {
        final result = await future;
        expect(result, isA<Rejection>());
        expect((result as Rejection).get(), isA<UnknownFailure>());
      }

      await expectRejection(repo.loadNotifications('U1', 10, 1));
      await expectRejection(repo.updateSingleNotification('n1'));
      await expectRejection(repo.markAllReadNotification());
      await expectRejection(repo.deleteAllReadNotification(false));
      await expectRejection(repo.deleteNotification('n1'));
      await expectRejection(repo.getNotificationResume());
      await expectRejection(
          repo.sendPushCallback('n1', NotificationCallbackType.EXCLUIU));
    });
  });
}
