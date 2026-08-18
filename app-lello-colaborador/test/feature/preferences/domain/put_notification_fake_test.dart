import 'package:colaborador/feature/preferences/domain/entity/preferences_notification_entity.dart';
import 'package:colaborador/feature/preferences/domain/repository/preferences_repository.dart';
import 'package:colaborador/feature/preferences/domain/use_case/put_preferences_notification/put_preferences_notification.dart';
import 'package:colaborador/feature/preferences/domain/use_case/put_preferences_notification/put_preferences_notification_impl.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakePrefsRepo extends Fake implements PreferencesRepository {
  List<PreferencesNotificationEntity>? last;
  bool fail = false;

  @override
  Future<Try<String>> putPreferencesNotification(
    List<PreferencesNotificationEntity> entity,
  ) async {
    if (fail) return Rejection(UnknownFailure('put'));
    last = entity;
    return Success('ok');
  }
}

void main() {
  test('PutNotificationUseCaseImpl encaminha a lista', () async {
    final repo = _FakePrefsRepo();
    final items = [PreferencesNotificationEntity(active: true, module: 'gdp')];
    final result = await PutNotificationUseCaseImpl(repository: repo)(
      PutNotificationParam(entity: items),
    );
    expect(result, isA<Success<String>>());
    expect((result as Success<String>).get(), 'ok');
    expect(repo.last, items);
  });

  test('rejeita erro do repositório', () async {
    final result = await PutNotificationUseCaseImpl(
      repository: _FakePrefsRepo()..fail = true,
    )(PutNotificationParam(
      entity: [PreferencesNotificationEntity(active: true, module: 'gdp')],
    ));
    expect(result, isA<Rejection<String>>());
  });
}
