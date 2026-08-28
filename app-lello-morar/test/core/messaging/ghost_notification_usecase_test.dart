import 'package:essentials/essentials.dart' hide isNotNull, isNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/messaging/use_case/ghost_notification_usecase.dart';
import 'package:morar/core/messaging/use_case/ghost_notification_usecase_impl.dart';
import 'package:morar/feature/home/presentation/bloc/home_bloc.dart';
import 'package:morar/feature/me/domain/entity/me.dart';
import 'package:morar/feature/me/domain/use_case/get_me/get_me.dart';
import 'package:morar/lello_app.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';
import 'package:shared_features/feature/ghost_notification/data/model/ghost_notification_model.dart';
import 'package:shared_features/shared_features.dart';

import '../../helpers/firebase_mocks.dart';
import '../../helpers/fixtures.dart';

class _FakeRepository extends Fake implements GhostNotificationRepository {
  final sent = <GhostNotificationModel>[];
  final types = <String>[];

  @override
  Future<Try<String?>> send(
    GhostNotificationModel model,
    String id,
    String type,
  ) async {
    sent.add(model);
    types.add(type);
    return Success('ok');
  }
}

class _FakeAuthenticationStore extends Fake implements AuthenticationStore {
  bool loggedOut = false;
  final switched = <Me?>[];

  @override
  Future<void> logout() async => loggedOut = true;

  @override
  Future<void> switchRole({
    AccessToken? token,
    String? role,
    bool isUpdate = false,
    dynamic me,
  }) async {
    switched.add(me as Me?);
  }
}

class _FakeGetMe extends Fake implements GetMe {
  _FakeGetMe({this.fail = false, this.throws = false, this.returnsNull = false});

  final bool fail;
  final bool throws;
  final bool returnsNull;
  int calls = 0;

  @override
  Future<Try<Me?>> call(DataOrigin? params) async {
    calls++;
    if (throws) throw StateError('boom');
    if (fail) return Rejection(UnknownFailure('me'));
    return Success(returnsNull ? null : testMe(name: 'Atualizado'));
  }
}

class _FakeSwitchRoles extends Fake implements SwitchRoles {
  _FakeSwitchRoles({this.fail = false});

  final bool fail;
  final params = <SwitchParams>[];

  @override
  Future<Try<AccessToken?>> call(SwitchParams? p) async {
    params.add(p!);
    if (fail) return Rejection(UnknownFailure('switch'));
    return Success(null);
  }
}

class _FakeHomeBloc extends Fake implements HomeBloc {
  int fcmCalls = 0;

  @override
  Future registerFcmToken() async => fcmCalls++;
}

late _FakeRepository _repository;
late _FakeAuthenticationStore _authStore;
late FakeSessionBloc _sessionBloc;
late _FakeHomeBloc _homeBloc;

GhostNotificationUsecaseImpl _useCase({
  _FakeGetMe? getMe,
  _FakeSwitchRoles? switchRoles,
}) {
  _repository = _FakeRepository();
  _authStore = _FakeAuthenticationStore();
  _sessionBloc = FakeSessionBloc();
  _homeBloc = _FakeHomeBloc();
  return GhostNotificationUsecaseImpl(
    repository: _repository,
    sessionBloc: _sessionBloc,
    authenticationStore: _authStore,
    getMe: getMe ?? _FakeGetMe(),
    switchRoles: switchRoles ?? _FakeSwitchRoles(),
    homeBloc: _homeBloc,
  );
}

void main() {
  setUp(() async {
    await setUpFakeFirebase();
    SharedPreferences.setMockInitialValues({});
    PackageInfo.setMockInitialValues(
      appName: 'morar',
      packageName: 'br.com.lello.morar',
      version: '9.9.9',
      buildNumber: '1',
      buildSignature: '',
    );
  });

  group('GhostNotificationUsecaseImpl', () {
    test('estou vivo envia o modelo com token, versão e usuário', () async {
      final result = await _useCase().call(
        GhostNotificationParams(id: '1', type: 'ESTOU_VIVO'),
      );

      expect(result, isA<Success<String?>>());
      final model = _repository.sent.single;
      expect(model.token, 'fcm-token');
      expect(model.appVersion, '9.9.9');
      expect(model.appType, 'br.com.lello.morar');
      expect(model.logedUserCpf, _sessionBloc.session!.me!.cpf);
      expect(model.customData, isEmpty);
      expect(_repository.types.single, 'ESTOU_VIVO');
    });

    test('dados do app incluem a versão e o usuário logado', () async {
      await _useCase().call(
        GhostNotificationParams(id: '2', type: 'DADOS_APP'),
      );

      final custom = _repository.sent.single.customData as Map;
      expect(custom['appVersion'], '9.9.9');
      expect(custom['user'], isNotNull);
    });

    test('log detalhado envia a sessão serializada', () async {
      await _useCase().call(
        GhostNotificationParams(id: '3', type: 'LOG_DETALHADO'),
      );

      final custom = _repository.sent.single.customData as Map;
      expect(custom['detail_log'], isNotNull);
    });

    test('atualização de token pede um novo registro do fcm', () async {
      final result = await _useCase().call(
        GhostNotificationParams(id: '4', type: 'UPDATE_FCM_TOKEN'),
      );

      expect(result, isA<Success<String?>>());
      expect(_homeBloc.fcmCalls, 1);
      expect(_repository.sent, isEmpty);
    });

    test('tipo desconhecido é rejeitado como não implementado', () async {
      final result = await _useCase().call(
        GhostNotificationParams(id: '5', type: 'RELATORIO_PONTO'),
      );

      expect(result, isA<Rejection>());
      expect(_repository.sent, isEmpty);
    });

    /// Corrigido: `redirectForSplash` agora devolve `Future<Try<String?>>`,
    /// então `clearData`/`updateUser` respondem `Rejection`/`Success` em vez
    /// de lançar TypeError em runtime.
    test('limpeza de dados sem navegação guarda o pedido e responde rejeição',
        () async {
      final useCase = _useCase();

      final result = await useCase
          .call(GhostNotificationParams(id: '6', type: 'LIMPEZA_DADOS'));

      expect(result, isA<Rejection<String?>>());
      expect(_authStore.loggedOut, isFalse);
      expect(_repository.sent, isEmpty);
      final preferences = await SharedPreferences.getInstance();
      expect(
        preferences.getString(SharedPreferencesKeys.ghostNotificationLogout),
        contains('LIMPEZA_DADOS'),
      );
    });

    testWidgets('limpeza de dados com navegação desloga e volta para a splash',
        (tester) async {
      final useCase = _useCase();
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigatorKey,
          routes: {
            SharedApplicationRoute.splash: (_) =>
                const SizedBox(key: Key('splash')),
          },
          home: const SizedBox(key: Key('home')),
        ),
      );

      final result = await useCase
          .call(GhostNotificationParams(id: '7', type: 'LIMPEZA_DADOS'));
      await tester.pumpAndSettle();

      expect(result, isA<Success<String?>>());
      expect(_authStore.loggedOut, isTrue);
      expect(_repository.types.single, 'LIMPEZA_DADOS');
      expect(find.byKey(const Key('splash')), findsOneWidget);
      expect(find.byKey(const Key('home')), findsNothing);

      // Solta o navigator global para os testes seguintes verem
      // `navigatorKey.currentState == null`.
      await tester.pumpWidget(const SizedBox());
    });

    test('atualizar usuário busca o me, troca o papel e envia o resultado',
        () async {
      final getMe = _FakeGetMe();
      final switchRoles = _FakeSwitchRoles();

      final result = await _useCase(getMe: getMe, switchRoles: switchRoles)
          .call(GhostNotificationParams(id: '8', type: 'ATUALIZAR_USUARIO'));

      expect(result, isA<Success<String?>>());
      expect(getMe.calls, 1);
      expect(_sessionBloc.updatedMes.single?.name, 'Atualizado');
      expect(switchRoles.params.single.role, _sessionBloc.session!.unity!.id);
      expect(_authStore.switched.single?.name, 'Atualizado');
      final custom = _repository.sent.single.customData as Map;
      expect(custom['me'], isNotNull);
    });

    test('falha no switch roles sem navegação guarda o logout pendente',
        () async {
      final result = await _useCase(switchRoles: _FakeSwitchRoles(fail: true))
          .call(GhostNotificationParams(id: '9', type: 'ATUALIZAR_USUARIO'));

      // Corrigido: o resultado do redirect é propagado pelo fold do switch;
      // sem navegação o redirect responde rejeição e nada é enviado.
      expect(result, isA<Rejection<String?>>());
      expect(_repository.sent, isEmpty);
      expect(_authStore.switched, isEmpty);
      final preferences = await SharedPreferences.getInstance();
      expect(
        preferences.getString(SharedPreferencesKeys.ghostNotificationLogout),
        isNotNull,
      );
    });

    test('falha ou ausência do me guarda o logout pendente', () async {
      for (final getMe in [
        _FakeGetMe(fail: true),
        _FakeGetMe(returnsNull: true),
      ]) {
        SharedPreferences.setMockInitialValues({});
        final useCase = _useCase(getMe: getMe);

        final result = await useCase.call(
          GhostNotificationParams(id: '10', type: 'ATUALIZAR_USUARIO'),
        );

        expect(result, isA<Rejection<String?>>());
        expect(_repository.sent, isEmpty);
        final preferences = await SharedPreferences.getInstance();
        expect(
          preferences.getString(SharedPreferencesKeys.ghostNotificationLogout),
          isNotNull,
        );
      }
    });

    test('exceção ao buscar o me cai no redirect de segurança', () async {
      final useCase = _useCase(getMe: _FakeGetMe(throws: true));

      final result = await useCase.call(
        GhostNotificationParams(id: '11', type: 'ATUALIZAR_USUARIO'),
      );

      expect(result, isA<Rejection<String?>>());
      expect(_repository.sent, isEmpty);
      final preferences = await SharedPreferences.getInstance();
      expect(
        preferences.getString(SharedPreferencesKeys.ghostNotificationLogout),
        isNotNull,
      );
    });

    test('setCustomData cobre os tipos sem dados extras', () async {
      final useCase = _useCase();

      expect(
        await useCase.setCustomData(
          GhostNotificationParams(id: '12', type: 'ATUALIZAR_USUARIO'),
        ),
        {'me': ''},
      );
      expect(
        await useCase.setCustomData(
          GhostNotificationParams(id: '13', type: 'UPDATE_FCM_TOKEN'),
        ),
        isEmpty,
      );
      expect(
        await useCase.setCustomData(
          GhostNotificationParams(id: '14', type: 'LIMPEZA_DADOS'),
        ),
        isEmpty,
      );
    });
  });
}
