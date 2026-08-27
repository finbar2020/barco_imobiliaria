import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/shared_features.dart' hide isNull, isNotNull;

void main() {
  group('SharedApplicationRedirectRoute', () {
    test('guarda os dados do redirecionamento e gera um uuid', () {
      final rota = SharedApplicationRedirectRoute(
        rote: 'BOLETOS',
        context: 'ctx',
        notificationId: 'n1',
        objectId: 'o1',
        inApp: true,
        uuidGroup: 'g1',
      );

      expect(rota.rote, 'BOLETOS');
      expect(rota.context, 'ctx');
      expect(rota.notificationId, 'n1');
      expect(rota.objectId, 'o1');
      expect(rota.inApp, isTrue);
      expect(rota.uuidGroup, 'g1');
      expect(rota.didRedirect, isFalse);
      expect(rota.uuid, isNotEmpty);
      expect(rota.toString(), 'Rote: BOLETOS, Context: ctx, ObjectId: o1');
    });

    test('valores padrão e uuid distinto por instância', () {
      final a = SharedApplicationRedirectRoute(
          rote: 'X', context: null, notificationId: null);
      final b = SharedApplicationRedirectRoute(
          rote: 'X', context: null, notificationId: null);

      expect(a.inApp, isFalse);
      expect(a.uuidGroup, '');
      expect(a.objectId, isNull);
      expect(a.uuid, isNot(b.uuid));
      expect(a.toString(), 'Rote: X, Context: null, ObjectId: null');
    });
  });

  test('as chaves de SharedPreferences são únicas por app', () {
    final chaves = <String>[
      SharedPreferencesKeys.accessToken,
      SharedPreferencesKeys.refreshToken,
      SharedPreferencesKeys.lastRole,
      SharedPreferencesKeys.lastSwitchRoles,
      SharedPreferencesKeys.updateDateCheck,
      SharedPreferencesKeys.reviewDateCheck,
    ];

    expect(chaves, everyElement(isNotEmpty));
    expect(chaves.toSet().length, chaves.length);
    // Cada app tem o seu prefixo próprio, mas os nomes se repetem entre apps.
    expect(SharedPreferencesKeys.managerSession,
        SharedPreferencesKeys.ownerSession);
  });
}
