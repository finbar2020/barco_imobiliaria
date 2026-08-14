import 'package:colaborador/feature/preferences/domain/repository/preferences_repository.dart';
import 'package:colaborador/feature/preferences/domain/use_case/put_preferences_notification/put_preferences_notification.dart';
import 'package:essentials/essentials.dart';

class PutNotificationUseCaseImpl extends PutNotificationUseCase {
  final PreferencesRepository repository;

  PutNotificationUseCaseImpl({required this.repository});

  @override
  Future<Try<String>> call(PutNotificationParam params) async {
    final result = await repository.putPreferencesNotification(params.entity);

    return result;
  }
}
