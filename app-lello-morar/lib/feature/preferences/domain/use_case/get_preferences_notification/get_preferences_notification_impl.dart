import 'package:essentials/essentials.dart';
import 'package:morar/feature/preferences/domain/entity/preferences_notification_entity.dart';
import 'package:morar/feature/preferences/domain/repository/preferences_repository.dart';
import 'package:morar/feature/preferences/domain/use_case/get_preferences_notification/get_preferences_notification.dart';

class GetNotificationUseCaseImpl extends GetNotificationUseCase {
  final PreferencesRepository repository;

  GetNotificationUseCaseImpl({required this.repository});

  @override
  Future<Try<List<PreferencesNotificationEntity>>> call(
      GetNotificationParam params) async {
    final error = validate(params);

    if (error != null) return Rejection(error);
    final result = await repository.getPreferencesNotification();

    return result;
  }

  Failure? validate(GetNotificationParam params) {
    if (params.unityId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
