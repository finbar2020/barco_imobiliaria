import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:colaborador/feature/preferences/data/data_source/preferences_api.dart';
import 'package:colaborador/feature/preferences/data/data_source/preferences_data_source_impl.dart';
import 'package:colaborador/feature/preferences/data/model/preferences_notification_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

class _FakePreferencesApi extends Fake implements PreferencesApi {
  bool failGet = false;
  bool failPut = false;

  @override
  Future<Response<dynamic>> getPreferencesNotification() async {
    if (failGet) return Response(http.Response('erro', 500), 'erro');
    return Response(
      http.Response(
        jsonEncode([
          {'active': true, 'module': 'gdp'},
          {'active': false, 'module': 'mkt'},
        ]),
        200,
      ),
      '',
    );
  }

  @override
  Future<Response<dynamic>> putPreferencesNotification(
    List<PreferencesNotificationModel> body,
  ) async {
    if (failPut) return Response(http.Response('erro', 500), 'erro');
    return Response(http.Response('', 200), '');
  }
}

void main() {
  group('PreferencesDataSourceImpl', () {
    test('lista preferências de notificação', () async {
      final dataSource =
          PreferencesDataSourceImpl(api: _FakePreferencesApi());
      final list = await dataSource.getPreferencesNotification();
      expect(list, hasLength(2));
      expect(list.first.module, 'gdp');
      expect(list.last.active, isFalse);
    });

    test('salva preferências de notificação', () async {
      final result = await PreferencesDataSourceImpl(api: _FakePreferencesApi())
          .putPreferencesNotification([
        PreferencesNotificationModel(active: true, module: 'gdp'),
      ]);
      expect(result, '');
    });

    test('lança quando get falha', () async {
      final dataSource = PreferencesDataSourceImpl(
        api: _FakePreferencesApi()..failGet = true,
      );
      expect(
        () => dataSource.getPreferencesNotification(),
        throwsA(anything),
      );
    });

    test('lança quando put falha', () async {
      final dataSource = PreferencesDataSourceImpl(
        api: _FakePreferencesApi()..failPut = true,
      );
      expect(
        () => dataSource.putPreferencesNotification([
          PreferencesNotificationModel(active: true, module: 'gdp'),
        ]),
        throwsA(anything),
      );
    });
  });
}
