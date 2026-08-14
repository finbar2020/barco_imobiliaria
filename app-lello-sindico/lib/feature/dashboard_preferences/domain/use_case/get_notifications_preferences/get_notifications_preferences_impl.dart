import 'package:essentials/essentials.dart';
import 'package:lello/feature/dashboard_preferences/domain/entity/notifications_preferences.dart';
import 'package:lello/feature/dashboard_preferences/domain/repository/notifications_preferences_repository.dart';
import 'package:lello/feature/dashboard_preferences/domain/use_case/get_notifications_preferences/get_notifications_preferences.dart';

class GetNotificationsPreferencesUseCaseImpl
    extends GetNotificationsPreferencesUseCase {
  final NotificationsPreferencesRepository repository;
  GetNotificationsPreferencesUseCaseImpl({required this.repository});

  @override
  Future<Try<List<NotificationsPreferences>>> call(
      GetNotificationsPreferencesParam params) async {
    final error = _validate(params);

    if (error != null) return Rejection(error);

    var response = await repository.getNotificationsPreferences(params.condoId);
    return response;
  }

  Failure? _validate(GetNotificationsPreferencesParam? params) {
    if (params == null) return InvalidParamFailure();
    if (params.condoId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
