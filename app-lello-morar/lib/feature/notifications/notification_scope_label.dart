import 'package:morar/feature/me/domain/entity/me.dart';
import 'package:shared_features/shared_features.dart';

String? buildNotificationScopeLabel(SingleNotification notification, Me? me) {
  if (me == null) return null;
  if (me.allUnitIds.length <= 1) return null;
  final reference = notification.reference;
  if (reference == null || reference.isEmpty) return null;

  for (final condo in me.condominiums ?? const []) {
    for (final block in condo.blocks ?? const []) {
      for (final unity in block.units ?? const []) {
        if (unity.notificationContext == reference) {
          return '${condo.name} · ${unity.namedTitle}';
        }
      }
    }
  }
  return null;
}
