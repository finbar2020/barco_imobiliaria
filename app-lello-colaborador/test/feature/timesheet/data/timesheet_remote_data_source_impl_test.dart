import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:colaborador/feature/timesheet/data/data_source/remote/timesheet_api.dart';
import 'package:colaborador/feature/timesheet/data/data_source/remote/timesheet_remote_data_source_impl.dart';
import 'package:colaborador/feature/timesheet/data/model/timesheet_element_detail_model.dart';
import 'package:colaborador/feature/timesheet/data/model/timesheet_model.dart';
import 'package:colaborador/feature/timesheet/data/model/timesheet_periods_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

class _FakeTimesheetApi extends Fake implements TimesheetApi {
  bool fail = false;

  Response<dynamic> _ok(dynamic body) => Response(
        http.Response(jsonEncode(body), 200),
        '',
      );

  @override
  Future<Response<dynamic>> getTimesheet(
    String condominiumId,
    DateTime period,
  ) async {
    if (fail) return Response(http.Response('erro', 500), 'erro');
    return _ok({
      'date_from': '2026-01-01T00:00:00.000',
      'date_to': '2026-01-31T00:00:00.000',
      'timesheet_status': 'notAssigned',
      'timesheet_elements': [],
    });
  }

  @override
  Future<Response<dynamic>> getTimesheetDetail(
    String condominiumId,
    DateTime period,
  ) async {
    if (fail) return Response(http.Response('erro', 500), 'erro');
    return _ok([
      {
        'time': '08:00',
        'timesheet_flag': 'inserted',
        'date': '2026-01-10T00:00:00.000',
      },
    ]);
  }

  @override
  Future<Response<dynamic>> getTimesheetPeriods(String condominiumId) async {
    if (fail) return Response(http.Response('erro', 500), 'erro');
    return _ok([
      {
        'period_month': '2026-01-01T00:00:00.000',
        'start_date': '2026-01-01T00:00:00.000',
        'end_date': '2026-01-31T00:00:00.000',
      },
    ]);
  }

  @override
  Future<Response<dynamic>> sendEmail(
    String condominiumId,
    String email,
    DateTime period,
  ) async {
    return Response(http.Response('', fail ? 500 : 200), '');
  }

  @override
  Future<Response<dynamic>> signTimesheet(
    String condominiumId,
    String timesheetSignType,
    DateTime period,
  ) async {
    return Response(http.Response('', fail ? 500 : 200), '');
  }
}

void main() {
  final period = DateTime(2026, 1, 10);

  group('TimesheetRemoteDataSourceImpl', () {
    test('busca espelho de ponto', () async {
      final dataSource = TimesheetRemoteDataSourceImpl(api: _FakeTimesheetApi());
      final result = await dataSource.getTimesheet('c1', period);
      expect(result, isA<TimesheetModel>());
      expect(result.timesheetStatus, 'notAssigned');
    });

    test('busca detalhe do espelho', () async {
      final dataSource = TimesheetRemoteDataSourceImpl(api: _FakeTimesheetApi());
      final result = await dataSource.getTimesheetDetail('c1', period);
      expect(result, hasLength(1));
      expect(result.first, isA<TimesheetElementDetailModel>());
      expect(result.first.time, '08:00');
    });

    test('lista períodos', () async {
      final dataSource = TimesheetRemoteDataSourceImpl(api: _FakeTimesheetApi());
      final result = await dataSource.getTimesheetPeriods('c1');
      expect(result, hasLength(1));
      expect(result.first, isA<TimesheetPeriodsModel>());
    });

    test('envia e-mail com sucesso', () async {
      final dataSource = TimesheetRemoteDataSourceImpl(api: _FakeTimesheetApi());
      expect(await dataSource.sendEmail('c1', 'a@b.com', period), isTrue);
    });

    test('assina espelho com sucesso', () async {
      final dataSource = TimesheetRemoteDataSourceImpl(api: _FakeTimesheetApi());
      expect(
        await dataSource.signTimesheet('c1', 'espelho', period),
        isTrue,
      );
    });

    test('retorna false quando api falha em ações booleanas', () async {
      final api = _FakeTimesheetApi()..fail = true;
      final dataSource = TimesheetRemoteDataSourceImpl(api: api);
      expect(await dataSource.sendEmail('c1', 'a@b.com', period), isFalse);
      expect(
        await dataSource.signTimesheet('c1', 'espelho', period),
        isFalse,
      );
    });

    test('lança quando api falha em consultas', () async {
      final api = _FakeTimesheetApi()..fail = true;
      final dataSource = TimesheetRemoteDataSourceImpl(api: api);
      expect(() => dataSource.getTimesheet('c1', period), throwsA(anything));
      expect(
        () => dataSource.getTimesheetDetail('c1', period),
        throwsA(anything),
      );
      expect(() => dataSource.getTimesheetPeriods('c1'), throwsA(anything));
    });
  });
}
