import 'package:colaborador/core/messaging/use_case/ghost_notification_usecase.dart';
import 'package:colaborador/core/messaging/use_case/ghost_notification_usecase_impl.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/get_points/get_points_usecase.dart';
import 'package:colaborador/feature/session/domain/entity/session.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:colaborador/lello_app.dart';
import 'package:essentials/essentials.dart' hide isNotNull, isNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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

class _FakeSessionBloc extends Fake implements SessionBloc {
  @override
  Session? get getSession => testSession();
}

class _FakeAuthenticationStore extends Fake implements AuthenticationStore {
  bool loggedOut = false;

  @override
  Future<void> logout() async => loggedOut = true;
}

class _FakeGetPoints extends Fake implements GetPointsUsecase {
  _FakeGetPoints({this.points = const []});

  final List<DigitalPointEntity> points;
  int calls = 0;

  @override
  Future<Try<List<DigitalPointEntity>>> call(GetPointsParam? params) async {
    calls++;
    return Success(points);
  }
}

late _FakeRepository _repository;
late _FakeAuthenticationStore _authStore;

GhostNotificationUsecaseImpl _useCase({_FakeGetPoints? getPoints}) {
  _repository = _FakeRepository();
  _authStore = _FakeAuthenticationStore();
  return GhostNotificationUsecaseImpl(
    repository: _repository,
    sessionBloc: _FakeSessionBloc(),
    authenticationStore: _authStore,
    getPointsUsecase: getPoints ?? _FakeGetPoints(),
  );
}

void main() {
  setUp(() async {
    await setUpFakeFirebase();
    SharedPreferences.setMockInitialValues({});
    PackageInfo.setMockInitialValues(
      appName: 'colaborador',
      packageName: 'br.com.lello.colaborador',
      version: '9.9.9',
      buildNumber: '1',
      buildSignature: '',
    );
  });

  group('GhostNotificationUsecaseImpl', () {
    test('estou vivo envia o modelo com token e versão', () async {
      final result = await _useCase().call(
        GhostNotificationParams(id: '1', type: 'ESTOU_VIVO'),
      );

      expect(result, isA<Success<String?>>());
      expect(_repository.sent.single.token, 'fcm-token');
      expect(_repository.sent.single.appVersion, '9.9.9');
      expect(_repository.types.single, 'ESTOU_VIVO');
    });

    test('dados do app incluem o usuário logado', () async {
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

    test('relatório de ponto busca os pontos do colaborador', () async {
      final getPoints = _FakeGetPoints(points: [testPoint()]);

      await _useCase(getPoints: getPoints).call(
        GhostNotificationParams(id: '4', type: 'RELATORIO_PONTO'),
      );

      expect(getPoints.calls, 1);
      final custom = _repository.sent.single.customData as Map;
      expect((custom['timesheet_report'] as List).length, 1);
    });

    test('limpeza de dados sem navegação guarda o pedido para depois',
        () async {
      final result = await _useCase().call(
        GhostNotificationParams(id: '5', type: 'LIMPEZA_DADOS'),
      );

      expect(result, isA<Rejection>());
      expect(_authStore.loggedOut, isFalse);

      final preferences = await SharedPreferences.getInstance();
      expect(
        preferences.getString(SharedPreferencesKeys.ghostNotificationLogout),
        isNotNull,
      );
    });

    test('tipo desconhecido cai no comportamento de "estou vivo"', () async {
      final result = await _useCase().call(
        GhostNotificationParams(id: '6', type: 'TIPO_INEXISTENTE'),
      );

      expect(result, isA<Success<String?>>());
      expect(_repository.sent.single.customData, isEmpty);
    });

    testWidgets('limpeza de dados com navegação desloga e volta para a splash',
        (tester) async {
      final useCase = _useCase();
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigatorKey,
          routes: {
            SharedApplicationRoute.splash: (_) => const SizedBox(
                  key: Key('splash'),
                ),
          },
          home: const SizedBox(key: Key('home')),
        ),
      );

      final result = await useCase.call(
        GhostNotificationParams(id: '8', type: 'LIMPEZA_DADOS'),
      );
      await tester.pumpAndSettle();

      expect(result, isA<Success<String?>>());
      expect(_authStore.loggedOut, isTrue);
      expect(_repository.types.single, 'LIMPEZA_DADOS');
      expect(find.byKey(const Key('splash')), findsOneWidget);
      expect(find.byKey(const Key('home')), findsNothing);
    });

    test('atualizações de usuário e de token não geram dados customizados',
        () async {
      final useCase = _useCase();

      expect(
        await useCase.setCustomData(
          GhostNotificationParams(id: '9', type: 'ATUALIZAR_USUARIO'),
        ),
        isNull,
      );
      expect(
        await useCase.setCustomData(
          GhostNotificationParams(id: '10', type: 'UPDATE_FCM_TOKEN'),
        ),
        isEmpty,
      );
    });

    test('atualização de token não envia dados extras', () async {
      final result = await _useCase().call(
        GhostNotificationParams(id: '7', type: 'UPDATE_FCM_TOKEN'),
      );

      expect(result, isA<Rejection>());
      expect(_repository.sent, isEmpty);
    });
  });
}
