import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:essentials/paginator/paginator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/shared_features.dart';

import 'notifications_support.dart';

void main() {
  late NotificationsHarness harness;

  setUp(() {
    harness = NotificationsHarness();
    harness.http.on('GET', '/dashboard/U1/pendencies/pagination',
        body: paginatorJson([notificationJson()]));
    harness.http.on('PUT', '/dashboard/pendencies/markRead', body: {});
    harness.http.on('PUT', '/dashboard/pendencies/markAllRead', body: {});
    harness.http.on('DELETE', '/dashboard/pendencies/deleteAllRead', body: {});
    harness.http.on('DELETE', '/dashboard/pendencies/delete', body: {});
    harness.http.on('GET', '/dashboard/pendencies/resume', body: resumeJson());
    harness.http.on('POST', '/dashboard/pendencies/sendCallback', body: {});
  });

  test('GetNotificationsImpl valida a referência e delega', () async {
    final useCase = GetNotificationsImpl(repository: harness.repository);
    final invalid = await useCase
        .call(GetNotificationParams(reference: '', limit: 10, page: 1));
    expect((invalid as Rejection).get(), isA<InvalidParamFailure>());
    expect(harness.http.requests, isEmpty);

    final ok = await useCase
        .call(GetNotificationParams(reference: 'U1', limit: 10, page: 1));
    expect(ok, isA<Success<Paginator>>());
    expect(harness.requestedPaths, ['/dashboard/U1/pendencies/pagination']);
  });

  test('ReadNotificationsImpl valida o id e delega', () async {
    final useCase = ReadNotificationsImpl(repository: harness.repository);
    final invalid =
        await useCase.call(ReadNotificationParams(notificationId: ''));
    expect((invalid as Rejection).get(), isA<InvalidParamFailure>());

    expect(await useCase.call(ReadNotificationParams(notificationId: 'n1')),
        Success(true));
    expect(harness.requestedPaths, ['/dashboard/pendencies/markRead']);
  });

  test('MarkAllReadNotificationImpl valida a referência e delega', () async {
    final useCase = MarkAllReadNotificationImpl(repository: harness.repository);
    final invalid =
        await useCase.call(MarkAllReadNotificationParams(reference: ''));
    expect((invalid as Rejection).get(), isA<InvalidParamFailure>());

    expect(await useCase.call(MarkAllReadNotificationParams(reference: 'U1')),
        Success(true));
    expect(harness.requestedPaths, ['/dashboard/pendencies/markAllRead']);
  });

  test('DeleteAllReadNotificationImpl delega direto', () async {
    final useCase =
        DeleteAllReadNotificationImpl(repository: harness.repository);
    expect(await useCase.call(DeleteAllReadNotificationParams(read: true)),
        Success(true));
    expect(harness.http.requests.single.url.queryParameters['read'], 'true');
  });

  test('DeleteNotificationImpl valida o id e delega', () async {
    final useCase = DeleteNotificationImpl(repository: harness.repository);
    final invalid =
        await useCase.call(DeleteNotificationParams(notificationId: ''));
    expect((invalid as Rejection).get(), isA<InvalidParamFailure>());

    expect(await useCase.call(DeleteNotificationParams(notificationId: 'n1')),
        Success(true));
    expect(harness.requestedPaths, ['/dashboard/pendencies/delete']);
  });

  test('NotificationResumeImpl exige referência não nula (vazia vale)',
      () async {
    final useCase = NotificationResumeImpl(repository: harness.repository);
    final invalid = await useCase.call(NotificationResumeParams());
    expect((invalid as Rejection).get(), isA<InvalidParamFailure>());

    final ok = await useCase.call(NotificationResumeParams(reference: ''));
    expect((ok as Success<NotificationResumeEntity>).get().totalRead, 3);
    expect(harness.requestedPaths, ['/dashboard/pendencies/resume']);
  });

  test('SendPushCallbackImpl valida o id e delega', () async {
    final useCase = SendPushCallbackImpl(repository: harness.repository);
    final invalid = await useCase.call(SendPushCallbackParams(
        notificationId: '', type: NotificationCallbackType.RECEBEU));
    expect((invalid as Rejection).get(), isA<InvalidParamFailure>());

    expect(
        await useCase.call(SendPushCallbackParams(
            notificationId: 'n1',
            type: NotificationCallbackType.ATUALIZAR_USUARIO)),
        Success(true));
    expect(harness.http.requests.single.url.queryParameters['type'],
        'ATUALIZAR_USUARIO');
  });
}
