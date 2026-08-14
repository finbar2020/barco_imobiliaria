import 'package:colaborador/feature/preferences/domain/entity/preferences_notification_entity.dart';
import 'package:essentials/essentials.dart';

abstract class GetNotificationUseCase
    extends UseCase<List<PreferencesNotificationEntity>, GetNotificationParam> {
}

class GetNotificationParam {
  final String unityId;
  GetNotificationParam({required this.unityId});
}
