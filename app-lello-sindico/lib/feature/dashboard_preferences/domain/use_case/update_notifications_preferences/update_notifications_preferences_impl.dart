import 'package:essentials/essentials.dart';
import 'package:lello/feature/dashboard_preferences/domain/entity/notifications_preferences.dart';
import 'package:lello/feature/dashboard_preferences/domain/repository/notifications_preferences_repository.dart';
import 'package:lello/feature/dashboard_preferences/domain/use_case/update_notifications_preferences/update_notifications_preferences.dart';

class UpdateNotificationsPreferencesImpl
    extends UpdateNotificationsPreferences {
  final NotificationsPreferencesRepository repository;

  UpdateNotificationsPreferencesImpl({required this.repository});

  @override
  Future<Try<List<NotificationsPreferences>>> call(
      UpdateNotificationsPreferencesParam params) async {
    var error = validate(params);
    if (error != null) return Rejection(error);
    var result =
        await repository.updateNotificationsPreferences(params.condominiumId, params.notificationsPreferences);
    return result;
  }

  Failure? validate(UpdateNotificationsPreferencesParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
