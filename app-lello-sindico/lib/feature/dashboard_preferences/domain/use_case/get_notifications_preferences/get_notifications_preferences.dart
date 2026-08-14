import 'package:essentials/essentials.dart';
import 'package:lello/feature/dashboard_preferences/domain/entity/notifications_preferences.dart';


abstract class GetNotificationsPreferencesUseCase extends UseCase<List<NotificationsPreferences>, GetNotificationsPreferencesParam> {}

class GetNotificationsPreferencesParam {
  final String condoId;

  GetNotificationsPreferencesParam({required this.condoId});
}
