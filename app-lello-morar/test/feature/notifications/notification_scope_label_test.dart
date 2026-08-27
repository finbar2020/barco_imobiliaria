import 'package:flutter_test/flutter_test.dart';
import 'package:morar/feature/notifications/notification_scope_label.dart';
import 'package:shared_features/shared_features.dart';

import '../../helpers/fixtures.dart';

void main() {
  test('buildNotificationScopeLabel', () {
    final me = testMe(condominiums: [
      testCondominium(id: 'c1', name: 'Alfa', blocks: [
        testBlock(units: [testUnity(id: 'u1', title: '101.0', notificationContext: 'ctx-1')])
      ]),
      testCondominium(id: 'c2', name: 'Beta', blocks: [
        testBlock(id: 'b2', units: [testUnity(id: 'u2', title: '202', notificationContext: 'ctx-2')])
      ]),
    ]);
    expect(buildNotificationScopeLabel(SingleNotification(reference: 'ctx-1'), null), isNull);
    expect(buildNotificationScopeLabel(SingleNotification(reference: 'ctx-1'), testMe()), isNull);
    expect(buildNotificationScopeLabel(SingleNotification(), me), isNull);
    expect(buildNotificationScopeLabel(SingleNotification(reference: ''), me), isNull);
    expect(buildNotificationScopeLabel(SingleNotification(reference: 'ctx-1'), me), 'Alfa · 101');
    expect(buildNotificationScopeLabel(SingleNotification(reference: 'ctx-2'), me), 'Beta · 202');
    expect(buildNotificationScopeLabel(SingleNotification(reference: 'zzz'), me), isNull);
  });
}
