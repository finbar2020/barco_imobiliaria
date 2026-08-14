import 'package:lello/feature/me/domain/entity/me.dart';
import 'package:shared_features/shared_features.dart';

String? buildNotificationScopeLabel(SingleNotification notification, Me? me) {
  if (me == null) return null;
  final condos = me.condominiums;
  if (condos == null || condos.length <= 1) return null;
  final reference = notification.reference;
  if (reference == null || reference.isEmpty) return null;

  for (final condo in condos) {
    if (condo.notificationContext == reference) {
      return condo.name;
    }
  }
  return null;
}
