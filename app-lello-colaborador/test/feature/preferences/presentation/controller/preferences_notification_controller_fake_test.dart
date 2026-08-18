import 'package:colaborador/feature/preferences/domain/entity/preferences_notification_entity.dart';
import 'package:colaborador/feature/preferences/domain/use_case/get_preferences_notification/get_preferences_notification.dart';
import 'package:colaborador/feature/preferences/domain/use_case/put_preferences_notification/put_preferences_notification.dart';
import 'package:colaborador/feature/preferences/presentation/bloc/preferences_notification_bloc.dart';
import 'package:colaborador/feature/preferences/presentation/bloc/preferences_notification_state.dart';
import 'package:colaborador/feature/preferences/presentation/controller/preferences_notification_controller.dart';
import 'package:colaborador/feature/session/domain/entity/session.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fixtures.dart';

class _FakeGet extends Fake implements GetNotificationUseCase {
  bool fail = false;

  @override
  Future<Try<List<PreferencesNotificationEntity>>> call(
    GetNotificationParam params,
  ) async {
    if (fail) return Rejection(UnknownFailure('get'));
    return Success([
      PreferencesNotificationEntity(active: true, module: 'gdp'),
    ]);
  }
}

class _FakePut extends Fake implements PutNotificationUseCase {
  bool fail = false;

  @override
  Future<Try<String>> call(PutNotificationParam params) async {
    if (fail) return Rejection(UnknownFailure('put'));
    return Success('ok');
  }
}

class _NullSessionBloc extends Fake implements SessionBloc {
  @override
  Session? get getSession => null;
}

void main() {
  group('PreferencesNotificationController', () {
    test('getPreferences carrega preferências', () async {
      final bloc = PreferencesNotificationBloc();
      addTearDown(bloc.close);
      final controller = PreferencesNotificationController(
        bloc: bloc,
        getNotificationUseCase: _FakeGet(),
        putNotificationUseCase: _FakePut(),
        sessionBloc: FakeSessionBloc(),
      );
      final loadedFuture = bloc.stream.firstWhere(
        (s) => s is PreferencesNotificationLoadedState,
      );

      await controller.getPreferences();

      final loaded = await loadedFuture;
      expect(loaded, isA<PreferencesNotificationLoadedState>());
      expect(
        (loaded as PreferencesNotificationLoadedState).preferences.first.module,
        'gdp',
      );
    });

    test('getPreferences falha sem sessão', () async {
      final bloc = PreferencesNotificationBloc();
      addTearDown(bloc.close);
      final controller = PreferencesNotificationController(
        bloc: bloc,
        getNotificationUseCase: _FakeGet(),
        putNotificationUseCase: _FakePut(),
        sessionBloc: _NullSessionBloc(),
      );
      final failureFuture = bloc.stream.firstWhere(
        (s) => s is PreferencesNotificationFailureState,
      );

      await controller.getPreferences();

      expect(await failureFuture, isA<PreferencesNotificationFailureState>());
    });

    test('getPreferences propaga erro do use case', () async {
      final bloc = PreferencesNotificationBloc();
      addTearDown(bloc.close);
      final controller = PreferencesNotificationController(
        bloc: bloc,
        getNotificationUseCase: _FakeGet()..fail = true,
        putNotificationUseCase: _FakePut(),
        sessionBloc: FakeSessionBloc(),
      );
      final failureFuture = bloc.stream.firstWhere(
        (s) => s is PreferencesNotificationFailureState,
      );

      await controller.getPreferences();

      expect(await failureFuture, isA<PreferencesNotificationFailureState>());
    });

    test('putPreferences salva e emite sucesso', () async {
      final bloc = PreferencesNotificationBloc();
      addTearDown(bloc.close);
      final controller = PreferencesNotificationController(
        bloc: bloc,
        getNotificationUseCase: _FakeGet(),
        putNotificationUseCase: _FakePut(),
        sessionBloc: FakeSessionBloc(),
      );
      final loaded = PreferencesNotificationLoadedState(
        preferences: [PreferencesNotificationEntity(active: true, module: 'gdp')],
      );
      final successFuture = bloc.stream.firstWhere(
        (s) => s is PreferencesNotificationSuccessState,
      );

      await controller.putPreferences(loaded);

      expect(await successFuture, isA<PreferencesNotificationSuccessState>());
    });

    test('putPreferences propaga erro', () async {
      final bloc = PreferencesNotificationBloc();
      addTearDown(bloc.close);
      final controller = PreferencesNotificationController(
        bloc: bloc,
        getNotificationUseCase: _FakeGet(),
        putNotificationUseCase: _FakePut()..fail = true,
        sessionBloc: FakeSessionBloc(),
      );
      final loaded = PreferencesNotificationLoadedState(
        preferences: [PreferencesNotificationEntity(active: false, module: 'mkt')],
      );
      final failureFuture = bloc.stream.firstWhere(
        (s) => s is PreferencesNotificationFailureState,
      );

      await controller.putPreferences(loaded);

      expect(await failureFuture, isA<PreferencesNotificationFailureState>());
    });
  });
}
