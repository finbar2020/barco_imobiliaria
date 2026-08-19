import 'dart:async';

import 'package:colaborador/feature/home/presentation/widget/pages/home_page/widgets/notification_icon.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_test/flutter_test.dart';
import 'package:badges/badges.dart';
import 'package:shared_features/shared_features.dart';

import '../../../../helpers/pump_app.dart';

class _FakeNotificationListBloc extends Fake implements NotificationListBloc {
  _FakeNotificationListBloc(this._state);

  final NotificationListState _state;
  final _controller = StreamController<NotificationListState>.broadcast();

  @override
  NotificationListState get state => _state;

  @override
  Stream<NotificationListState> get stream => _controller.stream;

  Future<void> dispose() => _controller.close();
}

Future<void> _pumpIcon(
  WidgetTester tester,
  NotificationListState state,
) async {
  final bloc = _FakeNotificationListBloc(state);
  addTearDown(bloc.dispose);
  await pumpApp(
    tester,
    NotificationIcon(notificationListBloc: bloc),
    localized: true,
    shrinkWrap: false,
    surface: const Size(120, 120),
  );
}

void main() {
  group('NotificationIcon', () {
    testWidgets('sem notificações não mostra contador', (tester) async {
      await _pumpIcon(tester, NotificationListPageState(notificationsNotRead: 0));

      expect(find.byType(Badge), findsNothing);
    });

    testWidgets('mostra a quantidade de notificações não lidas',
        (tester) async {
      await _pumpIcon(tester, NotificationListPageState(notificationsNotRead: 3));

      expect(find.byType(Badge), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('acima de 99 mostra 99+', (tester) async {
      await _pumpIcon(
        tester,
        NotificationListPageState(notificationsNotRead: 150),
      );

      expect(find.text('99+'), findsOneWidget);
    });

    testWidgets('estado sem página de notificações mostra o ícone simples',
        (tester) async {
      await _pumpIcon(tester, NotificationListEmptyState());

      expect(find.byType(Badge), findsNothing);
    });
  });
}
