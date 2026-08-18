import 'package:colaborador/feature/home/presentation/widget/pages/home_page/widgets/notification_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/shared_features.dart';

import '../../../../helpers/pump_app.dart';

class _FakeNotificationBloc extends Fake implements NotificationListBloc {
  _FakeNotificationBloc(this._state);

  final NotificationListState _state;

  @override
  NotificationListState get state => _state;

  @override
  Stream<NotificationListState> get stream => Stream.value(_state);
}

void main() {
  testWidgets('golden — notification icon sem badge', (tester) async {
    await pumpApp(
      tester,
      NotificationIcon(
        notificationListBloc: _FakeNotificationBloc(
          NotificationListPageState(notificationsNotRead: 0),
        ),
      ),
      localized: true,
      surface: const Size(80, 80),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/notification_icon_empty.png'),
    );
  });

  testWidgets('golden — notification icon com badge', (tester) async {
    await pumpApp(
      tester,
      NotificationIcon(
        notificationListBloc: _FakeNotificationBloc(
          NotificationListPageState(notificationsNotRead: 5),
        ),
      ),
      localized: true,
      surface: const Size(80, 80),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/notification_icon_badge.png'),
    );
  });

  testWidgets('golden — notification icon com badge 99+', (tester) async {
    await pumpApp(
      tester,
      NotificationIcon(
        notificationListBloc: _FakeNotificationBloc(
          NotificationListPageState(notificationsNotRead: 120),
        ),
      ),
      localized: true,
      surface: const Size(80, 80),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/notification_icon_badge_99.png'),
    );
  });
}
