import 'package:colaborador/feature/preferences/domain/entity/preferences_notification_entity.dart';
import 'package:essentials/essentials.dart';

abstract class PutNotificationUseCase
    extends UseCase<String, PutNotificationParam> {}

class PutNotificationParam {
  final List<PreferencesNotificationEntity> entity;
  PutNotificationParam({required this.entity});
}
