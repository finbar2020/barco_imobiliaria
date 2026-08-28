import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/shared_features.dart';

import 'notifications_support.dart';

void main() {
  test('começa vazio e reage a cada evento', () async {
    final bloc = NotificationListBloc();
    expect(bloc.state, isA<NotificationListEmptyState>());

    final states = <dynamic>[];
    final sub = bloc.stream.listen(states.add);

    bloc.add(NotificationLoadingEvent());
    bloc.add(NotificationFailedEvent());
    final list = [buildNotification()];
    bloc.add(NotificationSuccessEvent(
      notificationsNotRead: 4,
      notificationList: list,
      loading: true,
      pagError: true,
      singleNotification: list.first,
    ));
    bloc.add(NotificationSuccessEvent(notificationsNotRead: 0));
    await Future<void>.delayed(Duration.zero);

    expect(states, hasLength(4));
    expect(states[0], isA<NotificationListLoadingState>());
    expect(states[1], isA<NotificationListLoadedFailedState>());
    final page = states[2] as NotificationListPageState;
    expect(page.notificationsNotRead, 4);
    expect(page.notificationList, same(list));
    expect(page.loading, isTrue);
    expect(page.pagError, isTrue);
    expect(page.singleNotification, same(list.first));
    final empty = states[3] as NotificationListPageState;
    expect(empty.notificationList, isEmpty);
    expect(empty.loading, isFalse);
    expect(empty.pagError, isFalse);
    expect(empty.singleNotification, isNull);

    await sub.cancel();
    await bloc.close();
  });
}
