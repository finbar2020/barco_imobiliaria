import 'package:colaborador/feature/preferences/domain/entity/preferences_notification_entity.dart';
import 'package:colaborador/feature/preferences/domain/repository/preferences_repository.dart';
import 'package:colaborador/feature/preferences/domain/use_case/get_preferences_notification/get_preferences_notification.dart';
import 'package:colaborador/feature/preferences/domain/use_case/get_preferences_notification/get_preferences_notification_impl.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakePrefsRepo extends Fake implements PreferencesRepository {
  bool fail = false;

  @override
  Future<Try<List<PreferencesNotificationEntity>>>
      getPreferencesNotification() async {
    if (fail) return Rejection(UnknownFailure('prefs'));
    return Success([
      PreferencesNotificationEntity(active: true, module: 'acordos'),
    ]);
  }
}

void main() {
  group('GetNotificationUseCaseImpl', () {
    test('rejeita unityId vazio', () async {
      final result = await GetNotificationUseCaseImpl(
        repository: _FakePrefsRepo(),
      )(GetNotificationParam(unityId: ''));
      expect(result, isA<Rejection<List<PreferencesNotificationEntity>>>());
    });

    test('lista preferências', () async {
      final result = await GetNotificationUseCaseImpl(
        repository: _FakePrefsRepo(),
      )(GetNotificationParam(unityId: 'u1'));
      expect(result, isA<Success<List<PreferencesNotificationEntity>>>());
      expect(
        (result as Success<List<PreferencesNotificationEntity>>).get().first.title,
        'notification_module_agreements',
      );
    });

    test('rejeita erro do repositório', () async {
      final result = await GetNotificationUseCaseImpl(
        repository: _FakePrefsRepo()..fail = true,
      )(GetNotificationParam(unityId: 'u1'));
      expect(result, isA<Rejection<List<PreferencesNotificationEntity>>>());
    });
  });

  group('PreferencesNotificationEntity.title', () {
    test('mapeia módulos conhecidos', () {
      expect(
        PreferencesNotificationEntity(module: 'gdp').title,
        'notification_module_gdp',
      );
      expect(
        PreferencesNotificationEntity(module: 'xyz').title,
        'notification_module_others',
      );
    });
  });
}
