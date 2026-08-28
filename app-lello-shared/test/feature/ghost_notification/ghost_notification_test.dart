import 'dart:convert';

import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/ghost_notification/data/data_source/ghost_notification_api.dart';
import 'package:shared_features/feature/ghost_notification/data/model/ghost_notification_model.dart';
import 'package:shared_features/shared_features.dart' hide isNull, isNotNull;

import '../../helpers/fake_http.dart';

class _ThrowingDatasource extends Fake implements GhostNotificationDatasource {
  @override
  Future<String?> send(GhostNotificationModel model, String id, String type) async =>
      throw StateError('boom');
}

Map<String, dynamic> _json({dynamic customData = const {'k': 'v'}}) => {
      'id': '1',
      'token': 'fcm',
      'app_type': 'br.com.lello.morar',
      'recived_date': '2026-01-01',
      'app_version': '9.9.9',
      'device_name': 'Pixel',
      'loged_user_cpf': '123',
      'loged_user_id': 'u1',
      'custom_data': customData,
      'type': 'ESTOU_VIVO',
    };

void main() {
  group('GhostNotificationModel', () {
    test('fromJson/toJson preservam os campos', () {
      final model = GhostNotificationModel.fromJson(_json());

      expect(model.id, '1');
      expect(model.token, 'fcm');
      expect(model.appType, 'br.com.lello.morar');
      expect(model.recivedDate, '2026-01-01');
      expect(model.appVersion, '9.9.9');
      expect(model.deviceName, 'Pixel');
      expect(model.logedUserCpf, '123');
      expect(model.logedUserId, 'u1');
      expect(model.customData, {'k': 'v'});
      expect(model.type, 'ESTOU_VIVO');
      expect(model.toJson(), _json());

      final vazio = GhostNotificationModel.fromJson({});
      expect(vazio.id, isNull);
      expect(vazio.customData, isNull);
    });

    test('fromEntity/toEntity (o tipo não faz parte da entidade)', () {
      expect(GhostNotificationModel.fromEntity(null), isNull);

      final entity = GhostNotificationModel.fromJson(_json()).toEntity();
      expect(entity.id, '1');
      expect(entity.token, 'fcm');
      expect(entity.appType, 'br.com.lello.morar');
      expect(entity.recivedDate, '2026-01-01');
      expect(entity.appVersion, '9.9.9');
      expect(entity.deviceName, 'Pixel');
      expect(entity.logedUserCpf, '123');
      expect(entity.logedUserId, 'u1');
      expect(entity.customData, {'k': 'v'});

      final back = GhostNotificationModel.fromEntity(entity)!;
      expect(back.id, '1');
      expect(back.logedUserId, 'u1');
      expect(back.type, isNull);

      final novo = GhostNotificationEntity(id: 'x');
      expect(novo.id, 'x');
      expect(novo.token, isNull);
    });
  });

  test('GhostNotificationTypeUtils converte cada tipo e usa imAlive no padrão',
      () {
    const cases = {
      'ESTOU_VIVO': GhostNotificationType.imAlive,
      'DADOS_APP': GhostNotificationType.userAppData,
      'LOG_DETALHADO': GhostNotificationType.detailedLog,
      'LIMPEZA_DADOS': GhostNotificationType.dataCleaning,
      'RELATORIO_PONTO': GhostNotificationType.timesheetReport,
      'ATUALIZAR_USUARIO': GhostNotificationType.updateUser,
      'UPDATE_FCM_TOKEN': GhostNotificationType.updateFCMToken,
      'QUALQUER': GhostNotificationType.imAlive,
    };
    cases.forEach((key, value) {
      expect(GhostNotificationTypeUtils.stringToGhostNotificationEnum(key), value);
    });
    expect(GhostNotificationType.values, hasLength(7));
  });

  group('data source e repositório', () {
    late FakeHttp http;
    late GhostNotificationDataSourceImpl dataSource;
    late GhostNotificationRepositoryImpl repository;

    setUp(() {
      http = FakeHttp();
      dataSource = GhostNotificationDataSourceImpl(
          api: GhostNotificationApi.create(buildChopperClient(http)));
      repository = GhostNotificationRepositoryImpl(datasource: dataSource);
    });

    test('envia o modelo com id e tipo na query', () async {
      http.on('POST', '*', body: {});
      final model = GhostNotificationModel.fromJson(_json());

      final result = await repository.send(model, '42', 'ESTOU_VIVO');

      expect(result.fold((_) => null, (r) => r), '');
      final request = http.requests.single;
      expect(request.method, 'POST');
      expect(request.url.path, endsWith('ghostNotification'));
      expect(request.url.queryParameters, {'id': '42', 'tipo': 'ESTOU_VIVO'});
      expect(jsonDecode(request.body)['token'], 'fcm');
    });

    test('erro da API lança no data source e rejeita no repositório',
        () async {
      http.failAll(status: 500, body: {'status': 500, 'title': 'erro'});
      final model = GhostNotificationModel.fromJson(_json());

      await expectLater(
          dataSource.send(model, '1', 'X'), throwsA(isA<ApiFailure>()));

      final result = await repository.send(model, '1', 'X');
      expect((result as Rejection).get(), isA<UnknownFailure>());
    });

    test('exceção genérica vira UnknownFailure', () async {
      final failing =
          GhostNotificationRepositoryImpl(datasource: _ThrowingDatasource());
      final result = await failing.send(GhostNotificationModel(), '1', 'X');
      expect((result as Rejection).get(), isA<UnknownFailure>());
    });
  });
}
