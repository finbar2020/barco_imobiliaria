import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/condominium/domain/entity/condominium.dart';
import 'package:lello/feature/me/domain/entity/me.dart';
import 'package:lello/feature/notifications/notification_scope_label.dart';
import 'package:shared_features/shared_features.dart';

void main() {
  Condominium condo(String name, String ctx) => Condominium(
        id: name,
        name: name,
        reference: name,
        notificationContext: ctx,
      );

  test('não mostra rótulo com um único condomínio', () {
    final me = Me(condominiums: [condo('Aurora', 'ctx-1')]);
    final label = buildNotificationScopeLabel(
      SingleNotification(reference: 'ctx-1'),
      me,
    );
    expect(label, isNull);
  });

  test('mostra o nome do condomínio quando há mais de um', () {
    final me = Me(condominiums: [
      condo('Aurora', 'ctx-1'),
      condo('Sol', 'ctx-2'),
    ]);
    expect(
      buildNotificationScopeLabel(SingleNotification(reference: 'ctx-2'), me),
      'Sol',
    );
  });

  test('retorna nulo sem usuário ou sem referência', () {
    expect(
      buildNotificationScopeLabel(SingleNotification(reference: 'x'), null),
      isNull,
    );
    final me = Me(condominiums: [
      condo('Aurora', 'ctx-1'),
      condo('Sol', 'ctx-2'),
    ]);
    expect(buildNotificationScopeLabel(SingleNotification(), me), isNull);
  });
}
