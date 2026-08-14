import 'package:essentials/essentials.dart';
import 'package:morar/feature/preferences/domain/entity/preferences_notification_entity.dart';

abstract class GetNotificationUseCase
    extends UseCase<List<PreferencesNotificationEntity>, GetNotificationParam> {
}

class GetNotificationParam {
  final String unityId;
  GetNotificationParam({required this.unityId});
}
